class ServiceError < RuntimeError; end

class Roker
  require 'soap/wsdlDriver'
  require 'xsd/mapping'
  require 'uri'
  require 'open-uri'
  require 'hpricot'
  require 'numeric'
  require 'time_layout'
  require 'time_span'
  require 'weather_parameter'
  
  attr_accessor :lat, :lng, :started_at, :ended_at
  
  WSDL_URL = "http://www.weather.gov/forecasts/xml/DWMLgen/wsdl/ndfdXML.wsdl"
  WSDL_PARAMETERS = { :maxt => true, :mint => true, :temp => true, :dew => true, :appt => false, :pop12 => true, :qpf => true, :snow => false, :sky => true, :rh => true, :wspd => true, :wdir => true, :wx => false, :icons => false, :waveh => true, :incw34 => false, :incw50 => false, :incw64 => false, :cumw34 => false, :cumw50 => false, :cumw64 => false, :wgust => false, :conhazo => false, :ptornado => false, :phail => false, :ptstmwinds => false, :pxtornado => false, :pxhail => false, :pxtstmwinds => false, :ptotsvrtstm => false, :pxtotsvrtstm =>false}
  WSDL_PRODUCT = "time-series"
  
  def initialize(attributes={})
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
    self.started_at, self.ended_at = self.ended_at, self.started_at if self.ended_at && self.started_at > self.ended_at
  end
  
  
  def weather_forecasts_attributes
    @weather_forecasts_attributes ||= find_weather_forecasts_attributes
  end
  
  def find_weather_forecasts_attributes
    weather_forecasts_attributes = []
    interval = shortest_time_span
    self.started_at.upto(self.ended_at, interval, false) do |current_started_at|
      current_time_span = TimeSpan.new(:start_at => current_started_at, :duration => interval)
      current_weather_forecast_attributes = {
        :lat => self.lat, 
        :lng => self.lng, 
        :started_at => current_time_span.start_at, 
        :ended_at => current_time_span.end_at
      }
      parameters.each do |key, parameter|
        current_weather_forecast_attributes[key] = parameter.value_at(current_time_span) if parameter
      end
      weather_forecasts_attributes << current_weather_forecast_attributes
    end
    weather_forecasts_attributes
  end
  
  def time_layouts
    @time_layouts ||= parse_time_layouts
  end
  
  def parse_time_layouts
    tls = {}
    self.weather_doc.search('time-layout').each do |tl|
      key = (tl/'layout-key').first.inner_html
      
      start_at = []
      tl.search('start-valid-time').each do |s|
        start_at << self.class.parse_time(s.inner_html)
      end
      
      end_at = []
      tl.search('end-valid-time').each do |e|
        end_at << self.class.parse_time(e.inner_html)
      end
      
      tls[key] = TimeLayout.new(:start_at => start_at, :end_at => end_at, :key => key)
    end
    tls
  end
  
  def shortest_time_span
    shorty = nil
    self.time_layouts.each do |key, time_layout|
      shorty = time_layout.interval if (shorty.nil? || shorty > time_layout.interval)
    end
    shorty
  end
  
  def parameters
    @parameters ||= parse_parameters
  end
  
  
  def parse_parameters
    {
      :maximum_temperature =>           self.parse_parameter("temperature[@type='maximum']"),
      :minimum_temperature =>           self.parse_parameter("temperature[@type='minimum']"),
      :temperature =>                   self.parse_parameter("temperature[@type='hourly']"),
      :dewpoint_temperature =>          self.parse_parameter("temperature[@type='dew point']"),
      :liquid_precipitation =>          self.parse_parameter("precipitation[@type='liquid']"),
      :probability_of_precipitation =>  self.parse_parameter("probability-of-precipitation"),
      :wind_speed =>                    self.parse_parameter("wind-speed[@type='sustained']"),
      :wind_direction =>                self.parse_parameter("direction[@type='wind']"),
      :cloud_cover =>                   self.parse_parameter("cloud-amount[@type='total']"),
      :relative_humidity =>             self.parse_parameter("humidity[@type='relative']"),
      :wave_height =>                   self.parse_parameter("water-state", "waves[@type='significant']")
    }
  end
  
  def parse_parameter(xpath, value_xpath=nil, calculation_method=nil)
    element = self.weather_doc.at(xpath)
    if element
      time_layout_key = element.attributes['time-layout']
      time_layout = self.time_layouts[time_layout_key]
      values = []
      element = element.at(value_xpath) if value_xpath
      element.search('value').each do |val|
        values << val.inner_html.to_f
      end
      WeatherParameter.new(:time_layout => time_layout, :values => values, :calculation_method => calculation_method)
    end
  end
  
  def weather_doc
    @weather_doc ||= Hpricot::XML(self.weather_xml)
  rescue Timeout::Error, 
         Errno::EINVAL, 
         Errno::ECONNRESET, 
         EOFError,
         Net::HTTPBadResponse, 
         Net::HTTPHeaderSyntaxError,
         Net::ProtocolError => e
    service_error = ServiceError.new
    service_error.set_backtrace(e.backtrace)
    raise service_error
  end
  
  def weather_xml
    @weather_xml ||=  weather_xml_soap
    # TODO can I do away with the weather_xml_soap and just use a url and URI.parse?
    # @weather_xml ||= weather_xml_uri
  end
  
protected
  
  def weather_xml_soap
    soap_driver = SOAP::WSDLDriverFactory.new(WSDL_URL).create_rpc_driver
    soap_driver.NDFDgen(self.lat, self.lng, WSDL_PRODUCT, self.started_at.strftime("%Y-%m-%dT%H:%M:%S-05:00"), self.ended_at.strftime("%Y-%m-%dT%H:%M:%S-05:00"), WSDL_PARAMETERS)
  end
  
  def weather_xml_uri
    URI.parse(self.service_url).read
  end
  
  def num_days
    return 1 unless self.ended_at
    ((self.ended_at.beginning_of_day-self.started_at.beginning_of_day)/1.day).ceil
  end
  
  def service_url
    sprintf("http://www.weather.gov/forecasts/xml/sample_products/" + 
            "browser_interface/ndfdBrowserClientByDay.php?" + 
            "&format=24+hourly&numDays=%s&lat=%s&lon=%s&startDate=%s", 
            num_days, self.lat, self.lng, self.started_at.to_s(:weather))
  end
  
  def self.parse_time(str='')
    # "2008-11-24T07:00:00-05:00"
    str =~ /(....)-(..)-(..)T(..):(..):(..)-(..):(..)/i
    Time.mktime($1, $2, $3, $4, $5, $6, $7, $8)
    # Time.parse(str)
  rescue
    raise ServiceError, "Unsupported time format #{str}"
  end
  
end


# require 'uri'
# require 'open-uri'
# 
# module Roker
#   class ServiceError < RuntimeError; end
# 
#   def chance_of_rain(zip)
#     doc = Hpricot::XML(weather_xml(zip))
#     (doc/'probability-of-precipitation'/'value').first.inner_html.to_i
#   rescue Timeout::Error, 
#          Errno::EINVAL, 
#          Errno::ECONNRESET, 
#          EOFError,
#          Net::HTTPBadResponse, 
#          Net::HTTPHeaderSyntaxError,
#          Net::ProtocolError => e
#     service_error = ServiceError.new
#     service_error.set_backtrace(e.backtrace)
#     raise service_error
#   end
# 
#   protected
# 
#   def weather_xml(zip)
#     url = service_url(zip)
#     URI.parse(url).read
#   end
# 
#   def service_url(zip)
#     zip_code = ZipCode.find_by_zip!(zip)
# 
#     sprintf("http://www.weather.gov/forecasts/xml/sample_products/" + 
#             "browser_interface/ndfdBrowserClientByDay.php?" + 
#             "&format=24+hourly&numDays=2&lat=%s&lon=%s&startDate=%s", 
#             zip_code.lat, zip_code.lng, Time.now.to_s(:weather))
#   end
# end
