class TimeHumanizer
  def initialize(now, time)
    @now = now
    @time = time
  end

  def run
    seconds_elapsed = ((@now - @time) * 24 * 60 * 60).to_i
    if seconds_elapsed < 60
      "now"
    elsif seconds_elapsed < 3600
      minutes = seconds_elapsed/60
      "#{minutes} minute#{minutes == 1 ? "" : "s"} ago"
    elsif seconds_elapsed < 86400
      hours = seconds_elapsed/3600
      "#{hours} hour#{hours == 1 ? "" : "s"} ago"
    else
      days = seconds_elapsed/86400
      "#{days} day#{days == 1 ? "" : "s"} ago"
    end
  end
end
