require_relative "../models/user"

class StreakBody
  FIRST_EMAIL = "Looks like this is your first email reminder. Post every day in order to train your consistency. Try keeping your streak for as long as possible for the ultimate results."
  STREAK_ZERO = "Looks like you're struggling with posting regularly. Your current streak is zero, so try posting every day in order to improve it. This is a nice way to work on your consistency."
  STREAK_ONE = "Looks like you posted something yesterday, so your streak is currently one day. Post something today and it will increase. If you skip posting it will return to zero."

  def self.call(user)
    if user.log_entries.count == 0
      return FIRST_EMAIL
    end

    case user.streak
    when 0
      STREAK_ZERO
    when 1
      STREAK_ONE
    else
      "Nice work on posting every day! Looks like you're working on your consistency. Your streak is now #{user.streak} days, so keep posting every day to keep it from falling down to zero."
    end
  end
end
