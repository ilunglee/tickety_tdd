require 'spec_helper'

describe User do #giving us access tot he comment describe + class_name
  describe ".full_name" do
    it "return user full name" do
      user = User.new(first_name: "Nelson", last_name: "Lee")
      expect(user.full_name).to eq("Nelson Lee")
    end

    it "return user email" do
      user = User.new(email: "lungbao@gmail.com")
      expect(user.full_name).to eq("lungbao@gmail.com")
    end
  end
end