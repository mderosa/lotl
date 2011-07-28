require "spec_helper"

describe AdminMailer do

  describe "activation_instructions" do
    let(:mail) { 
      AdminMailer.activation_instructions(User.new(:email => "dude@duderanch.com"), "localhost" )
    }

    it "renders the headers" do
      mail.subject.should eq("Activation instructions")
      mail.to.should eq(["dude@duderanch.com"])
      mail.from.should eq(["lawoftheloop@gmail.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Thanks for trying out LOOP")
    end
  end

  describe "project_invitation" do
    let(:mail) { AdminMailer.project_invitation }

    it "renders the headers" do
      mail.subject.should eq("Project invitation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["lawoftheloop@gmail.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
