require 'spec_helper' #give you access to the entrie rails app or you can modify to require only specific files

describe Ticket do 
    
    it "Capitalize the title" do
      ticket = Ticket.new(title: "not capitalize title")
      ticket.save
      expect(ticket.title).to eq("Not capitalize title")
    end

end