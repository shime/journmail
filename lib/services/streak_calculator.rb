require "active_support/time"
require_relative "./../models/log_entry"

class StreakCalculator
  def self.call(*args)
    new(*args).call
  end

  def initialize(user)
    @user = user

    @days = LogEntry.where(user_id: @user.id).order{created_at.desc}.select(:created_at).map {|row|
      row.values
    }.map {|value| value[:created_at].in_time_zone(@user.timezone).to_date}
  end

  def call
    unless first_day_is_today_or_yesterday?
      return 0
    end

    calculate_streak
  end

  private

    def calculate_streak(streak = 1)
      @days.each_with_index do |day, index|
        if @days[index + 1] == day.in_time_zone(@user.timezone).yesterday
          streak += 1
        else
          break
        end
      end
      streak
    end

    def first_day_is_today_or_yesterday?
      @days.first == Date.current.in_time_zone(@user.timezone) ||
        @days.first == Date.current.in_time_zone(@user.timezone).yesterday
    end
end
