require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DudesHelper. For example:
#
# describe DudesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end

class Fixture
  include SecurityHelper
  attr_accessor :session

  def initialize
    @session = {}
  end
end

describe SecurityHelper do

  it "calling current user on the security helper should fail if there is not user in the session" do
    expect {
      f = Fixture.new
      c = f.current_user}.to raise_exception(SecurityError)
  end
end

