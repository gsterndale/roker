require File.dirname(__FILE__) + '/numeric'

class TimeSpan
  attr_accessor :start_at, :end_at, :duration
  
  def initialize(args={})
    @start_at = args[:start_at]
    
    if @end_at = args[:end_at]
      @end_at, @start_at = @start_at, @end_at if @start_at > @end_at
      @duration = @end_at - @start_at
    elsif @duration = args[:duration]
      @end_at = @start_at + @duration
    end
  end
  
  def first
    @start_at
  end
  
  def last
    @end_at
  end
  
  def envelopes?(t, include_end=true)
    t >= @start_at && ( t < @end_at || (include_end && t <= @end_at) )
  end
  
  # TODO
  def enveloped_by?(args, include_end=true)
    case
    when args.is_a?(TimeSpan)
    when args.is_a?(Range)
    when args.is_a?(Array)
    end
  end
  
  def overlaps?(t, include_end=true)
    if include_end
      t.end_at >= @start_at && t.start_at <= @end_at
    else
      t.end_at > @start_at && t.start_at < @end_at
    end
  end
  
  # ratio: overlap/duration
  def overlap_by(t, include_end=true)
    self.overlap(t, include_end)/@duration.to_f
  end
  
  def overlap(t, include_end=true)
    return 0 unless self.overlaps?(t, include_end)
    e = t.end_at > @end_at ? @end_at : t.end_at
    s = t.start_at < @start_at ? @start_at : t.start_at
    o = e-s
    !include_end && o <= 1 ? 0.0 : o
  end
  
end