require 'spec_helper'

feature "Creating a Ticket" do

  let(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
  end

  it "creates an ticket in the database" do
    visit tickets_path
    click_on "New Ticket"
    fill_in "ticket title", with: "some valid title"
    fill_in "ticket description", with: "some valid body"
    click_on "Save"
    expect(current_path).to eq(tickets_path)
    expect(page).to have_text /some valid title/i
  end

  it "doesn't create an title with empty title" do
    visit new_ticket_path
    save_and_open_page
    fill_in "ticket title", with: ""
    fill_in "ticket body", with: "some valid body"
    click_on "Save"
    expect(page).to have_text(/must have title/i)
    expect(Ticket.count).to eq(0)
  end

end