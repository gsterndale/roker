require File.dirname(__FILE__) + '/numeric'
require File.dirname(__FILE__) + '/time_span'

# assert interval is constant
# assert start_at of one TimeSpan can equal end_at of another
class TimeLayout
  attr_accessor :key
  attr_reader :time_spans
  
  DEFAULT_INTERVAL = 1.day
  
  # :time_spans or :start_at required
  def initialize(args)
    @key = args[:key]
    if args[:time_spans] and args[:time_spans].is_a?(Array)
      @time_spans = args[:time_spans]
    else
      @time_spans = []
      if args[:end_at].nil? || args[:end_at].is_a?(Array) && args[:end_at].compact.empty?
        @interval = calculate_interval_from_times(args[:start_at]) 
        args[:end_at] = nil
      end
      args[:start_at].each_with_index do |start_at,i|
        if args[:end_at]
          @time_spans << TimeSpan.new(:start_at => start_at, :end_at => args[:end_at][i])
        else
          @time_spans << TimeSpan.new(:start_at => start_at, :duration => self.interval)
        end
      end
    end
  end
  
  def index_at(t)
    @time_spans.each_with_index do |time_span,i|
      return i if time_span.envelopes?(t, false)
    end
    # if t falls on the end of a time_span and not the start of any others
    @time_spans.each_with_index do |time_span,i|
      return i if time_span.envelopes?(t, true)
    end
    nil
  end
  
  def indices_enveloping(time_span)
    indices = []
    weights = []
    @time_spans.each_with_index do |ts,i|
      if ts.overlaps?(time_span, false)
        indices << i
        weights << ts.overlap_by(time_span, false)
      end
    end
    return indices, weights
  end
  
  def [](i)
    @time_spans[i] if (@time_spans && @time_spans.is_a?(Array) && i >= 0 && i < @time_spans.length)
  end
  
  def start_at # of entire TimeLayout
    @start_at ||= self.time_spans.inject(nil){|memo,time_span| (memo && memo < time_span.start_at) ? memo : time_span.start_at }
  end
  
  def end_at # of entire TimeLayout
    @end_at ||= self.time_spans.inject(nil){|memo,time_span| (memo && memo > time_span.end_at) ? memo : time_span.end_at }
  end
  
  def interval
    @interval ||= (@time_spans.first.duration || calculate_interval_from_time_spans)
  end
  
  def length
    @length ||= @time_spans.length
  end
  
  def time_spans=(arr=[])
    @interval = nil
    @start_at = nil
    @end_at   = nil
    @time_spans = arr
  end
  
  def duration
    self.end_at - self.start_at
  end
  
protected
  
  def calculate_interval_from_times(times=[])
    times.length < 2 ? DEFAULT_INTERVAL : times[1] - times[0]
  end
  
  def calculate_interval_from_time_spans
    time_spans.length < 2 ? DEFAULT_INTERVAL : time_spans[1].start_at - time_spans[0].start_at
  end
  
end