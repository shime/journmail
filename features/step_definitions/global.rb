Given("I am a paying user") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I've received an email notification") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I have {int} entries") do |int|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I am unregistered user") do
  @current_user = User.new
end

When("I register with my email") do
  @current_user.email = "foo@bar.com"
  @mail_client = Mailgun::Client.new 'your-api-key'
  @mail_client.enable_test_mode!

  RegisterService.call(@current_user, @mail_client)
end

When("I go to a history page") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I haven't payed for {int} days") do |int|
  pending # Write code here that turns the phrase above into concrete actions
end

When("I log entries for two consecutive days") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I don't log anything on a third day") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("time is {int}:{int} in my timezone") do |int, int2|
  pending # Write code here that turns the phrase above into concrete actions
end

When("I respond to email notification") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("I add a new log entry") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should receive an email notification") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("a new log entry should be created") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see a notification that I should pay") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should see {int} entries") do |int|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("my daily streak should increment by one") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("my daily streak should be zero") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("my longest streak should be two") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should receive a registration email") do
  @mail = Mailgun::Client.deliveries.first
  expect(@mail).to_not be_nil
end

Then("the next payment should be scheduled for {int} days and should be {int}$") do |int, int2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should become a paying user") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should receive an email to pay") do
  pending # Write code here that turns the phrase above into concrete actions
end
