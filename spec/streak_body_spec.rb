require_relative "./spec_helper"
require_relative "../lib/utils/streak_body"

describe StreakBody do
  context "when it's a new user" do
    before do
      @user = User.new
      allow(@user).to receive(:log_entries).and_return([])

      @result = StreakBody.call(@user)
    end

    it "notifies user that this is a first email" do
      expect(@result).to match(/first email reminder.*Post every day/)
    end
  end

  context "when it's not a new user" do
    before do
      @user = User.new
      allow(@user).to receive(:log_entries).and_return(['foo'])
    end

    context "when user streak is 0" do
      before do
        allow(@user).to receive(:streak).and_return(0)

        @result = StreakBody.call(@user)
      end

      it "encourages users to post more" do
        expect(@result).to match(/struggling with posting regularly.*try posting every day/)
      end
    end

    context "when user streak is 1" do
      before do
        allow(@user).to receive(:streak).and_return(1)

        @result = StreakBody.call(@user)
      end

      it "mentions streak in email" do
        expect(@result).to match(/your streak is currently one day/)
      end
    end

    context "when user streak is 2+" do
      before do
        allow(@user).to receive(:streak).and_return(4)

        @result = StreakBody.call(@user)
      end

      it "mentions streak in email" do
        expect(@result).to match(/Your streak is now 4 days/)
      end
    end
  end
end
