Given("I am a paying user") do
  @current_user = CreateUserService.call(email: 'shime@twobucks.co', status: 'paying')
end

Given("I've received an email notification") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I have {int} entries") do |int|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I am unregistered user") do
  @current_user = CreateUserService.call(email: 'shime@twobucks.co')
end

Given("I go to registration URL") do
  visit("/register/#{@current_user.token}")
end

When("I register with {string}") do |email|
  @mail_client = double
  allow(@mail_client).to receive(:deliver_with_template)
  RegisterService.call(email, @mail_client)
end

When("I post an email to inbound endpoint") do
  post "/inbound", JSON.generate({
    text_body: File.read(File.join(File.dirname(__FILE__),
                                   "./email_response.txt")),
    mailbox_hash: @current_user.token}), { 'CONTENT_TYPE' => 'application/json' }
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

When("time is {int}:{int} in my timezone") do |hours, minutes|
  time = Time.local(2017, 12, 1, hours, minutes, 0)
  Timecop.travel(time)
end

When("I respond to email notification") do
  EmailResponseService.call(@current_user.token, "Response text")
end

When("I add a new log entry") do
  pending # Write code here that turns the phrase above into concrete actions
end

When("email notification is sent") do
  @mail_client = double
  allow(@mail_client).to receive(:deliver_with_template)
  EmailNotifierService.call(@mail_client)
end

Then("server response should be success") do
  expect(last_response.status).to be(200)
end

Then("I should receive an email notification") do
  expect(@mail_client).to have_received(:deliver_with_template)
end

Then("a new log entry should be created") do
  expect(LogEntry.count).to be(1)
end

Then("last log entry should belong to a current user") do
  expect(LogEntry.last.user.id).to eq(@current_user.id)
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
  expect(@mail_client).to have_received(:deliver_with_template)
end

Then("the next payment should be scheduled for {int} days and should be {int}$") do |int, int2|
  pending # Write code here that turns the phrase above into concrete actions
end

Then("I should become a paying user") do
  expect(@current_user.reload.paying?).to be(true)
end

Then("I should receive an email to pay") do
  pending # Write code here that turns the phrase above into concrete actions
end

Then("it should only contain the reply text") do
  expect(LogEntry.last.body).to eq("Das ist die Zeitung!")
end

Then("the new user should be created") do
  expect(User.count).to be(2)
end
