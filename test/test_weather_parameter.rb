require 'helper'

class TestWeatherParameter < Test::Unit::TestCase
  context "a new WeatherParameter passed a TimeLayout and values" do
    setup do
      @interval   = 3.hours
      @start_at   = Time.now+1.hour
      @length = 4
      time_spans = []
      @values = []
      (0..(@length-1)).each do |i|
        time_spans << TimeSpan.new(:start_at => @start_at+i*@interval, :duration => @interval)
        @values << i.to_f # just to make each value unique and testable
      end
      @time_layout = TimeLayout.new(:time_spans => time_spans)
      @weather_parameter = WeatherParameter.new(:time_layout => @time_layout, :values => @values)
    end
    
    should "have default calculation method" do
      assert_not_nil WeatherParameter::DEFAULT_CALCULATION_METHOD
      assert_equal WeatherParameter::DEFAULT_CALCULATION_METHOD, @weather_parameter.calculation_method
    end
    
    should "have time_layout" do
      assert_not_nil @weather_parameter.time_layout
    end
    
    should "have values" do
      assert !@weather_parameter.values.empty?
    end
    
    should "have value for [1]" do
      assert_equal 1.0, @weather_parameter[1]
    end
    
    should "have value_at of 0.0 @start_at" do
      assert_equal 0.0, @weather_parameter.value_at(@start_at)
    end
    
    should "have value_at of 0.0 @start_at + half interval" do
      assert_equal 0.0, @weather_parameter.value_at(@start_at+@interval/2)
    end
    
    should "have value_at of 1.0 at @start_at + 1.5 x interval" do
      assert_equal 1.0, @weather_parameter.value_at(@start_at+@interval*1.5)
    end

    should "have value_at of 1.66666666666667 during @start_at + 1.5 x interval - @start_at + 3 x interval" do
      assert_equal((1.0+2.0/3).to_s, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*3)).to_s)
    end
    
    should "have value_at of 2.2 during @start_at + 1.5 x interval - @start_at + 4 x interval" do
      assert_equal 2.2, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*4))
    end
    
    should "have value_at of 2.2 during @start_at + 1.5 x interval - @start_at + 10 x interval" do
      assert_equal 2.2, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*10))
    end
    
    should "have value_at of nil outside time_layout" do
      assert_equal nil, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at-100, :end_at => @start_at-10))
    end
    
    context "with the 'first' calculation method" do
      setup { @weather_parameter.calculation_method = :first }
      should "have value_at of 0.0 @start_at" do
        assert_equal 0.0, @weather_parameter.value_at(@start_at)
      end
      
      should "have value_at of 0.0 @start_at + half interval" do
        assert_equal 0.0, @weather_parameter.value_at(@start_at+@interval/2)
      end
      
      should "have value_at of 1.0 at @start_at + 1.5 x interval" do
        assert_equal 1.0, @weather_parameter.value_at(@start_at+@interval*1.5)
      end
      
      should "have value_at of 1.0 during @start_at + 1.5 x interval - @start_at + 3 x interval" do
        assert_equal 1.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*3))
      end
      
      should "have value_at of 2.0 during @start_at + 2 x interval - @start_at + 3 x interval" do
        assert_equal 2.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*2, :end_at => @start_at+@interval*3))
      end
      
      should "have value_at of 1.0 during @start_at + 1.5 x interval - @start_at + 4 x interval" do
        assert_equal 1.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*4))
      end
      
      should "have value_at of 1.0 during @start_at + 1.5 x interval - @start_at + 10 x interval" do
        assert_equal 1.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*10))
      end
      
      should "have value_at of nil outside time_layout" do
        assert_equal nil, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at-100, :end_at => @start_at-10))
      end
    end
    
    context "with the 'max' calculation method" do
      setup { @weather_parameter.calculation_method = :max }
      should "have value_at of 0.0 @start_at" do
        assert_equal 0.0, @weather_parameter.value_at(@start_at)
      end
      
      should "have value_at of 0.0 @start_at + half interval" do
        assert_equal 0.0, @weather_parameter.value_at(@start_at+@interval/2)
      end
      
      should "have value_at of 1.0 at @start_at + 1.5 x interval" do
        assert_equal 1.0, @weather_parameter.value_at(@start_at+@interval*1.5)
      end
      
      should "have value_at of 2.0 during @start_at + 1.5 x interval - @start_at + 3 x interval" do
        assert_equal 2.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*3))
      end
      
      should "have value_at of 2.0 during @start_at + 2 x interval - @start_at + 3 x interval" do
        assert_equal 2.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*2, :end_at => @start_at+@interval*3))
      end
      
      should "have value_at of 3.0 during @start_at + 1.5 x interval - @start_at + 4 x interval" do
        assert_equal 3.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*4))
      end
      
      should "have value_at of 3.0 during @start_at + 1.5 x interval - @start_at + 10 x interval" do
        assert_equal 3.0, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at+@interval*1.5, :end_at => @start_at+@interval*10))
      end
      
      should "have value_at of nil outside time_layout" do
        assert_equal nil, @weather_parameter.value_at(TimeSpan.new(:start_at => @start_at-100, :end_at => @start_at-10))
      end
    end
    
  end
end