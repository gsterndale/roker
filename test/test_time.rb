require 'helper'

class TestTime < Test::Unit::TestCase
  
  context "a date time" do
    setup do
      @time = Time.mktime(1979, 3, 29, 14, 32, 40)
      @bom  = Time.mktime(1979, 3, 29, 14, 32,  0)
      @eom  = Time.mktime(1979, 3, 29, 14, 32, 59)
      @boh  = Time.mktime(1979, 3, 29, 14,  0,  0)
      @eoh  = Time.mktime(1979, 3, 29, 14, 59, 59)
    end
    should "beginning_of_minute be beginning of minute" do
      assert_equal @bom, @time.beginning_of_minute
    end
    should "end_of_minute be end of minute" do
      assert_equal @eom, @time.end_of_minute
    end
    should "beginning_of_hour be beginning of hour" do
      assert_equal @boh, @time.beginning_of_hour
    end
    should "end_of_hour be end of hour" do
      assert_equal @eoh, @time.end_of_hour
    end
    
    should "beginning_of(1.minute) equal beginning_of_minute" do
      assert_equal @time.beginning_of_minute, @time.beginning_of(1.minute)
    end
    should "beginning_of(1.hour) equal beginning_of_hour" do
      assert_equal @time.beginning_of_hour, @time.beginning_of(1.hour)
    end
    should "beginning_of(1.day) equal beginning_of_day" do
      assert_equal @time.beginning_of_day, @time.beginning_of(1.day)
    end
    should "beginning_of(1.week) equal beginning_of_week" do
      assert_equal @time.beginning_of_week, @time.beginning_of(1.week)
    end
    should "beginning_of(1.month) equal beginning_of_month" do
      assert_equal @time.beginning_of_month, @time.beginning_of(1.month)
    end
    should "beginning_of(1.year) equal beginning_of_year" do
      assert_equal @time.beginning_of_year, @time.beginning_of(1.year)
    end
    should "end_of(1.minute) equal end_of_minute" do
      assert_equal @time.end_of_minute, @time.end_of(1.minute)
    end
    should "end_of(1.hour) equal end_of_hour" do
      assert_equal @time.end_of_hour, @time.end_of(1.hour)
    end
    should "end_of(1.day) equal end_of_day" do
      assert_equal @time.end_of_day, @time.end_of(1.day)
    end
    should "end_of(1.week) equal end_of_week" do
      assert_equal @time.end_of_week, @time.end_of(1.week)
    end
    should "end_of(1.month) equal end_of_month" do
      assert_equal @time.end_of_month, @time.end_of(1.month)
    end
    should "end_of(1.year) equal end_of_year" do
      assert_equal @time.end_of_year, @time.end_of(1.year)
    end
    
    context "a time 1 day later and a one hour interval" do
      setup do
        @time2 = @time + 1.day
        @interval = 1.hour
      end
      should "yield block 25 times on upto" do 
        @time.expects(:foo).times(25).returns(1)
        @time.upto(@time2, @interval) do 
          @time.foo
        end
      end
      should "yield block 24 times on upto not inclusive" do 
        @time.expects(:foo).times(24).returns(1)
        @time.upto(@time2, @interval, false) do 
          @time.foo
        end
      end
    end
    
  end
  
end