class TravelTimeFormatter
  def initialize(number_minutes)
    @minutes = number_minutes
  end

  def call
    if @minutes < 0 || @minutes > 90
      nil
    elsif @minutes == 60
      "1 hour"
    elsif @minutes > 60
      "1 hour and #{@minutes%60} minute#{@minutes%60 ==1 ? "" : "s"}"
    else
      "#{@minutes} minute#{@minutes ==1 ? "" : "s"}"
    end
  end
end
