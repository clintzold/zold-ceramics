require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "welcome_email" do
    let(:mail) { SubscriptionMailer.welcome_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "goodbye_email" do
    let(:mail) { SubscriptionMailer.goodbye_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Goodbye email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "new_batch_email" do
    let(:mail) { SubscriptionMailer.new_batch_email }

    it "renders the headers" do
      expect(mail.subject).to eq("New batch email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
