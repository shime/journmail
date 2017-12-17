class HighScoreCalculator
  def self.call(*args)
    new(*args).call
  end

  def initialize
    @streaks = User.all.map {|u| u.streak}.uniq.sort.reverse
    @score = User.all.map {|u| [u.streak, u.email]}.
      sort.map {|u| {rank: @streaks.index(u[0]) + 1, email: u[1], streak: u[0]}}.reject {|o| o[:streak] == 0}.reverse
  end

  def call
    @score.group_by {|u| [u[:rank], u[:streak]]}
      .map do |o|
        hash = {}
        hash[o[0]] = o[1].reduce([]) {|sum, o| sum << gravatar_for(o[:email]) }
        hash
    end.flatten(1).to_a
  end

  def gravatar_for(email)
    Utils::Gravatar.url(email, {default: "https://journmail.com/images/user-circle.png"})
  end
end
