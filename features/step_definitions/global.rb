Given("there are some issues with mail delivery service") do
  @mail_client = double
  allow(@mail_client).to receive(:deliver_with_template).and_raise("boom")
end

Given("the mail delivery service works") do
  @mail_client = double
  allow(@mail_client).to receive(:deliver_with_template)
  allow(Postmark::ApiClient).to receive(:new).and_return(@mail_client)
end

Given("I am a paying user") do
  @current_user = CreateUserService.call({ email: 'shime@twobucks.co', status: User::STATUSES[:paying] }, true)
end

Given("I am a paying user in {string} timezone") do |timezone|
  @current_user = CreateUserService.call({ email: 'shime@twobucks.co', status: User::STATUSES[:paying], timezone: timezone }, true)
end

Given("I've received an email notification") do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I have {int} entries") do |int|
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I am unregistered user") do
  @current_user = CreateUserService.call({ email: 'shime@twobucks.co' }, true)
end

Given("I go to registration confirmation URL") do
  visit("/register/#{@current_user.token}")
end


Given("{int} paying users exist") do |count|
  count.times do 
    CreateUserService.call({ email: "#{SecureRandom.uuid}@example.com", status: User::STATUSES[:paying] }, true)
  end
end

Given("{int} unsubscribed users exist") do |count|
  count.times do 
    CreateUserService.call({ email: "#{SecureRandom.uuid}@example.com", status: User::STATUSES[:unsubscribed] }, true)
  end
end

Given("a user with email {string} exists") do |email|
  CreateUserService.call({ email: email }, true)
end

When("I visit the unsubscribe page") do 
  visit("/unsubscribe/#{@current_user.token}")
end

When("I try to register with {string}") do |email|
  begin
    RegisterService.call(email)
  rescue 
  end
end

When("I try to register with {string} via API") do |email|
  post '/register', { email: email }.to_json
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

When("time is {int}:{int} in {string} timezone") do |hours, minutes, timezone|
  Time.zone = timezone
  time = Time.zone.local(2017, 12, 1, hours, minutes, 0)
  Timecop.travel(time)
end

When("I respond to email notification") do
  EmailResponseService.call(@current_user.token, "Response text")
end

When("I add a new log entry") do
  LogEntry.create(user_id: @current_user.id, body: "hi")
end

When("email notification is sent") do
  @mail_client = double
  allow(@mail_client).to receive(:deliver_with_template)
  EmailNotifierService.call(@mail_client)
end

When("I log entries for {int} consecutive days") do |int|
  (1..int).each do |number|
    LogEntry.create(user_id: @current_user.id, body: "hi", created_at: number.days.from_now)
  end
  Timecop.travel(int.days.from_now)
end

When("I don't log anything on a third day") do 
  Timecop.travel(1.day.from_now)
end

When("it's a third day") do
  # do nothing
end

When("the day has passed") do
  Timecop.travel(1.day.from_now)
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

Then("my daily streak should be {int}") do |number|
  expect(@current_user.streak).to be(number)
end

Then("my longest streak should be {int}") do |number|
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
  expect(User.count).to be(1)
end

Then("server response status should be {int}") do |status|
  expect(last_response.status).to be(status)
end

Then("there should be {int} registered user(s)") do |count|
  expect(User.count).to be(count)
end

Then("I should be unsubscribed") do
  expect(@current_user.reload).to be_unsubscribed
end

Then("{int} email notifications should be received") do |count|
  expect(@mail_client).to have_received(:deliver_with_template).exactly(count).times
end
