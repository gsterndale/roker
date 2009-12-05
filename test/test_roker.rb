require 'helper'

class TestRoker < Test::Unit::TestCase
  def setup
    super
    stub_weather_service
  end
  
  context "roker attributes" do
    setup do
      @num_days = 2
      @started_at = Time.mktime(2008, 11, 24, 4, 0, 0) # Time.parse("2008-11-24T04:00:00-05:00") #Time.now+3.days
      @ended_at = @started_at+@num_days.days
      @attributes = {:lat => 42, :lng => -81, :started_at => @started_at, :ended_at => @ended_at}
    end
    
    context "a roker" do
      setup { assert @roker = Roker.new(@attributes)}
      
      should "respond to lat" do
        assert @roker.respond_to?(:lat)
      end
      should "respond to lng" do
        assert @roker.respond_to?(:lng)
      end
      should "respond to started_at" do
        assert @roker.respond_to?(:started_at)
        assert_equal @started_at, @roker.started_at
      end
      should "respond to ended_at" do
        assert @roker.respond_to?(:ended_at)
        assert_equal @ended_at, @roker.ended_at
      end
      
      context "weather_forecasts_attributes" do
        setup { assert @weather_forecasts_attributes = @roker.weather_forecasts_attributes }
        
        should "weather_forecasts_attributes be array" do
          assert @weather_forecasts_attributes.is_a?(Array)
        end
        
        should "attributes have at least one item" do
          assert !@weather_forecasts_attributes.empty?
        end
        
        context "first weather forecast attributes" do
          setup { assert @weather_forecast_attributes = @weather_forecasts_attributes.first }
          should "have lat, lng, started_at, ended_at" do
            assert_not_nil @weather_forecast_attributes[:lat]
            assert_not_nil @weather_forecast_attributes[:lng]
            assert_not_nil @weather_forecast_attributes[:started_at]
            assert_not_nil @weather_forecast_attributes[:ended_at]
          end
          should "have weather attributes" do
            # assert_not_nil @weather_forecast_attributes[:maximum_temperature]
            assert_not_nil @weather_forecast_attributes[:minimum_temperature]
            assert_not_nil @weather_forecast_attributes[:temperature]
            assert_not_nil @weather_forecast_attributes[:dewpoint_temperature]
            assert_not_nil @weather_forecast_attributes[:liquid_precipitation]
            assert_not_nil @weather_forecast_attributes[:probability_of_precipitation]
            assert_not_nil @weather_forecast_attributes[:wind_speed]
            assert_not_nil @weather_forecast_attributes[:wind_direction]
            assert_not_nil @weather_forecast_attributes[:cloud_cover]
            assert_not_nil @weather_forecast_attributes[:relative_humidity]
            assert_not_nil @weather_forecast_attributes[:wave_height]
          end
        end
        
      end
      
      should "have weather xml" do
        assert_not_nil @roker.weather_xml # stubbed
      end
      
      should "have weather doc" do
        assert_not_nil @roker.weather_doc
      end
      
      should "parse parameters" do
        assert_not_nil @roker.parse_parameters
      end
      
      should "parse parameters as hash" do
        assert @roker.parse_parameters.is_a?(Hash)
      end
      
      should "parameters not be empty?" do
        assert !@roker.parse_parameters.empty?
      end
      
    end
  end
  
end
