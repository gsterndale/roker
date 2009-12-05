require 'helper'

class TestTimeLayout < Test::Unit::TestCase
  context "a new TimeLayout passed a time spans" do
    setup do
      @interval   = 3.hours
      @start_at   = Time.now+1.hour
      @length = 4
      @time_spans = []
      (0..(@length-1)).each do |i|
        @time_spans << TimeSpan.new(:start_at => @start_at+i*@interval, :duration => @interval)
      end
      @time_layout = TimeLayout.new(:time_spans => @time_spans)
    end
    
    should "have time-spans" do
      assert !@time_layout.time_spans.empty?
    end
    should "have a start_at equal to first time_span start_at" do
      assert_equal @time_spans.first.start_at, @time_layout.start_at
    end
    should "have a end_at equal to last time_span end_at" do
      assert_equal @time_spans.last.end_at, @time_layout.end_at
    end
    should "have a duration" do
      assert_equal @length * @interval, @time_layout.duration
    end
    should "have an interval" do
      assert_equal @interval, @time_layout.interval
    end
    should "have a length" do
      assert_equal @length, @time_layout.length
    end
    
    should "find second time span when using bracket access with 1 as index" do
      assert_equal @time_spans[1], @time_layout[1]
    end
    
    should "find index_at of 2 for specified time enveloped by third time span" do
      assert_equal 2, @time_layout.index_at(@time_spans[2].start_at+@interval/2)
    end
    
    should "find index_at of 2 for specified time when second time span ends and third time span starts" do
      assert_equal @time_spans[2].start_at, @time_spans[1].end_at
      assert_equal 2, @time_layout.index_at(@time_spans[2].start_at)
    end
    
    should "find index_at of nil for specified time outside time layout" do
      assert_nil @time_layout.index_at(@start_at - 1.hour)
    end
    
    should "have indices_enveloping of [1,2], [0.5, 1.0, 0.5] for time span overlapping second, third and fourth @time_spans" do
      assert_equal [[1,2,3], [0.5, 1.0, 0.5]], @time_layout.indices_enveloping(TimeSpan.new(:start_at => @time_spans[1].start_at+@interval/2, :end_at => @time_spans[3].end_at-@interval/2))
    end
  end
  
  context "a new TimeLayout passed start_at and end_at arrays" do
    setup do
      @interval   = 3.hours
      @start_at   = Time.now+1.hour
      @length     = 4
      @start_ats  = []
      @end_ats    = []
      (0..(@length-1)).each do |i|
        @start_ats << @start_at+i*@interval
        @end_ats   << @start_at+(i+1)*@interval
      end
      @time_layout = TimeLayout.new(:start_at => @start_ats, :end_at => @end_ats)
    end
    
    should "have time_spans" do
      assert !@time_layout.time_spans.empty?
    end
    should "have a start_at equal to first start_at" do
      assert_equal @start_ats.first, @time_layout.start_at
    end
    should "have a end_at equal to last end_at" do
      assert_equal @end_ats.last, @time_layout.end_at
    end
    should "have a duration" do
      assert_equal @length * @interval, @time_layout.duration
    end
    should "have an interval" do
      assert_equal @interval, @time_layout.interval
    end
    should "have a length" do
      assert_equal @length, @time_layout.length
    end
  end
  
  
  context "a new TimeLayout passed start_at array only" do
    setup do
      @interval   = 2.days
      @start_at   = Time.now+1.hour
      @length     = 4
      @start_ats  = []
      (0..(@length-1)).each do |i|
        @start_ats << @start_at+i*@interval
      end
      @time_layout = TimeLayout.new(:start_at => @start_ats)
    end
    
    should "have interval of difference between start_ats" do
      assert_equal @start_ats[1] - @start_ats[0], @time_layout.interval
    end
    should "have time_spans" do
      assert !@time_layout.time_spans.empty?
    end
    should "have a start_at equal to first start_at" do
      assert_equal @start_ats.first, @time_layout.start_at
    end
    should "have a end_at equal to last end_at" do
      assert_equal @start_ats.last+@interval, @time_layout.end_at
    end
    should "have a duration" do
      assert_equal @length * @interval, @time_layout.duration
    end
    should "have a length" do
      assert_equal @length, @time_layout.length
    end
  end
  
  context "a new TimeLayout passed start_at array with one element only" do
    setup do
      @interval   = 2.days
      @start_at   = Time.now+1.hour
      @length     = 1
      @start_ats  = []
      (0..(@length-1)).each do |i|
        @start_ats << @start_at+i*@interval
      end
      @time_layout = TimeLayout.new(:start_at => @start_ats)
    end
    
    should "have default interval" do
      assert_equal TimeLayout::DEFAULT_INTERVAL, @time_layout.interval
    end
    should "have time_spans" do
      assert !@time_layout.time_spans.empty?
    end
    should "have a start_at equal to first start_at" do
      assert_equal @start_ats.first, @time_layout.start_at
    end
    should "have a end_at equal to last end_at" do
      assert_equal @start_ats.last+TimeLayout::DEFAULT_INTERVAL, @time_layout.end_at
    end
    should "have a duration" do
      assert_equal @length * TimeLayout::DEFAULT_INTERVAL, @time_layout.duration
    end
    should "have a length" do
      assert_equal @length, @time_layout.length
    end
  end
end