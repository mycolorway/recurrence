class Recurrence_
  module Event
    class Weekly < Base # :nodoc: all
      private

      def validate
        @options[:on] = Array.wrap(@options[:on]).inject([]) do |days, value|
          days << valid_weekday_or_weekday_name?(value)
        end

        @options[:on].sort!
      end

      def next_in_recurrence
        return @date if !initialized? && @options[:on].include?(@date.wday)

        if next_day = @options[:on].find { |day| day > @date.wday }
          to_add = next_day - @date.wday
          # sunday is week's last day so add interval
          to_add += (@options[:interval] - 1) * 7 if @date.wday == 0
        else
          to_add = (7 - @date.wday)                # Move to next week
          # Add extra intervals (monday is week first day, so sunday not add interval)
          to_add += (@options[:interval] - 1) * 7 unless @options[:on].first == 0
          to_add += @options[:on].first            # Go to first required day
        end

        new_date = @date.to_date + to_add
        @options[:handler].call(new_date.day, new_date.month, new_date.year)
      end
    end
  end
end
