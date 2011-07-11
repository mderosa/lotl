require 'spec_helper'

describe CollaboratorsController do

  describe "POST 'create'" do
    describle "logic" do
      it "if c E C-set                     then C-set == C-set'"
      it "if c !E Clb-set and c E User-set then Clb-set.size + 1 = C-set'.size"
      it "if c !E Clb-set and c !E Usr-set then Clb-set.size + 1 = Clb-set'.size and Usr.size + 1 = Usr'.size and email"
    end

    describe "page flow" do
      it "non email format => project_path w/form validation error, bad format"
      it "if c E C-set                     => project_path w/ for validation error, already collaborator"
      it "if c !E Clb-set and c E User-set => project_path w/ flash successe"
      it "if c !E Clb-set and c !E Usr-set => project_path w/ flash sucess, has been invited"
    end
  end

  describe "PUT'delete'" do
    it "c !E Clb-set => project_path w/ flash error message"
    it "c E Clb-set => project_path w/ flash success message"

  end

end
