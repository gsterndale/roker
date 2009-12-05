require File.dirname(__FILE__) + '/numeric'
require File.dirname(__FILE__) + '/time_layout'
require File.dirname(__FILE__) + '/time_span'

class WeatherParameter
  attr_accessor :time_layout, :values, :calculation_method
  
  DEFAULT_CALCULATION_METHOD = :mean
  
  def initialize(args)
    @time_layout  = args[:time_layout]
    @values       = args[:values]
    @calculation_method = args[:calculation_method] || DEFAULT_CALCULATION_METHOD
  end
  
  def [](i)
    @values[i] if (@values && @values.is_a?(Array) && i >= 0 && i < @values.length)
  end
  
  def value_at(t)
    if t.is_a?(TimeSpan)
      self.send @calculation_method, t
    else
      self[@time_layout.index_at(t)]
    end
  end
  
protected
  
  def mean(t)
    indices, weights = @time_layout.indices_enveloping(t)
    return nil if indices.nil? || indices.empty?
    values = indices.inject([]) {|memo,i| memo << @values[i]; memo }
    sum = 0.0
    values.each_with_index{|value,i| sum = sum + value * weights[i] }
    total_weight = weights.inject{|total,w| total + w }
    sum/total_weight
  end
  
  def first(t)
    indices, weights = @time_layout.indices_enveloping(t)
    return nil if indices.nil? || indices.empty?
    values[indices.first]
  end
  
  def max(t)
    indices, weights = @time_layout.indices_enveloping(t)
    return nil if indices.nil? || indices.empty?
    indices.map{|i| values[i] }.max
  end
  
  # def min(t)
  #   
  # end
  # 
  # def median(t)
  #   
  # end
  # 
  # def mode(t)
  #   
  # end
  # 
  # def last(t)
  #   
  # end
  
end