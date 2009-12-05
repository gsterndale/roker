require 'helper'

class TestTimeSpan < Test::Unit::TestCase
  context "a new TimeSpan passed a start_at and end_at" do
    setup do
      @start_at = Time.now+1.hour
      @duration = 3.hours
      @end_at = @start_at+@duration
      @time_span = TimeSpan.new(:start_at => @start_at, :end_at => @end_at)
    end
    should "have a start_at" do
      assert_equal @start_at, @time_span.start_at
    end
    should "have a end_at" do
      assert_equal @end_at, @time_span.end_at
    end
    should "have a duration" do
      assert_equal @end_at - @start_at, @time_span.duration
    end
    
    should "envelopes? @start_at" do
      assert @time_span.envelopes?(@start_at)
    end
    
    should "envelopes? @end_at" do
      assert @time_span.envelopes?(@end_at)
    end
    
    should "envelopes? @end_at when include_end param specified as true" do
      assert @time_span.envelopes?(@end_at, true)
    end
    
    should "not envelopes? @end_at when include_end param specified as false" do
      assert !@time_span.envelopes?(@end_at, false)
    end
    
    should "not envelopes? prior time" do
      assert !@time_span.envelopes?(@start_at - 1.hour)
    end
    
    should "not envelopes? later time" do
      assert !@time_span.envelopes?(@end_at + 1.hour)
    end
    
    should "overlaps? another TimeSpan that happens during @time_span" do
      assert @time_span.overlaps?(TimeSpan.new(:start_at => @start_at+1, :end_at => @end_at-1))
    end
    
    should "overlaps? another TimeSpan that starts during @time_span, but ends after" do
      assert @time_span.overlaps?(TimeSpan.new(:start_at => @start_at+1, :end_at => @end_at+1))
    end
    
    should "overlaps? another TimeSpan that starts before @time_span and ends during" do
      assert @time_span.overlaps?(TimeSpan.new(:start_at => @start_at-1, :end_at => @end_at-1))
    end
    
    should "overlaps? another TimeSpan that starts before @time_span and ends after" do
      assert @time_span.overlaps?(TimeSpan.new(:start_at => @start_at-1, :end_at => @end_at+1))
    end
    
    should "overlaps? another TimeSpan that abutts @time_span" do
      assert @time_span.overlaps?(TimeSpan.new(:start_at => @end_at, :end_at => @end_at+10))
    end
    
    should "not overlaps? another TimeSpan that abutts @time_span afterward when include_end param specified as false" do
      assert !@time_span.overlaps?(TimeSpan.new(:start_at => @end_at, :end_at => @end_at+10), false)
    end
    
    should "not overlaps? another TimeSpan that abutts @time_span beforehand when include_end param specified as false" do
      assert !@time_span.overlaps?(TimeSpan.new(:start_at => @start_at-10, :end_at => @start_at), false)
    end
    
    should "not overlaps? another TimeSpan that happens before @time_span" do
      assert !@time_span.overlaps?(TimeSpan.new(:start_at => @start_at-10, :end_at => @start_at-5))
    end
    
    should "not overlaps? another TimeSpan that happens after @time_span" do
      assert !@time_span.overlaps?(TimeSpan.new(:start_at => @end_at+10, :end_at => @end_at+50))
    end
    
    should "have overlap of @duration/2 with another TimeSpan that starts halfway through @time_span and ends after" do
      assert_equal @duration/2, @time_span.overlap(TimeSpan.new(:start_at => @start_at+@duration/2, :end_at => @end_at+@duration*2))
    end
    
    should "have overlap_by of 0.5 with another TimeSpan that starts halfway through @time_span and ends after" do
      assert_equal 0.5, @time_span.overlap_by(TimeSpan.new(:start_at => @start_at+@duration/2, :end_at => @end_at+@duration*2))
    end
    
    should_eventually "enveloped_by?"
  end
end