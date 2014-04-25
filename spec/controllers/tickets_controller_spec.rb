require 'spec_helper'

describe TicketsController do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }
  let(:ticket1) { create(:ticket, user: user1) }

  describe "#index" do

    it "assigns a variable @tickets" do
      get :index
      expect(assigns(:tickets)).to be
    end

    it "includes all tickets in the database" do
      ticket = create(:ticket)
      get :index
      expect(assigns(:tickets)).to include(ticket)
    end

    it "renders index template" do 
      get :index
      expect(response).to render_template(:index)
    end

    it "only fetches 10 tickets" do
      20.times{ create(:ticket) }
      get :index
      expect(assigns(:tickets).length).to eq(10)
    end
  end

  describe "#new" do

    context "with signed in user" do
      before {sign_in user}

      it "assgins a new ticket" do
        get :new
        expect(assigns(:ticket)).to be_a_new(Ticket)
      end 

      it "redners :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "without signin user" do
      it "redirect to sign in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end 
  end

  describe "#create" do
    context "with sign in user" do
      before {sign_in user}

      context "with valid reticket" do

        def valid_request
          post :create, ticket: {title: "valid title" , body: "valid body" }
        end


        it "creates a ticket in the database" do
          expect { valid_request }. to change{ Ticket.count }.by(1)
        end

        it "redirects to tickets listing page with valid request" do
          valid_request
          expect(response).to redirect_to(tickets_path)
        end

        it "sets a flash message" do
          valid_request
          expect(flash[:notice]).to be
        end

        it "assigns the tickets to the signed in user" do
          expect{ valid_request }.to change { user.tickets.count }.by(1)
        end

      end

      context "with invalid reticket" do
        def invalid_request
          post :create, ticket: { title: "", 
                                    body: "valid_body"}
        end

        it "doesn't change the number of tickets in the database" do
          expect { invalid_request }.to_not change{ Ticket.count }
        end

        it "renders new template" do
          invalid_request
          expect(response).to render_template(:new)
        end


      end

    end

    context "with no signed in user" do
      it "redirect to sign in page" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "#show" do
    context "without sign in user" do
      it "assigns the ticket with the passed id" do
        get :show, id: ticket.id
        expect(assigns(:ticket)).to eq(ticket)
      end

      it "renders the show template" do
        get :show, id: ticket.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe "#edit" do
    context "signed out user" do
      it "redirects to new session path" do
        get :edit, id: ticket.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with a sign in user" do
      before {sign_in user}

      it "assigns the ticket with current passed id" do
        get :edit, id: ticket.id
        expect(assigns(:ticket)).to eq(ticket)
      end

      it "raises error if trying to edit others ticket" do
        expect { get :edit, id: ticket1.id }.to raise_error 
      end

    end
  end

  describe "#update" do

    context "with signed in user" do
      before { sign_in user }

      it "updates the ticket with new title" do
        patch :update, id: ticket.id, ticket: {title: "some new title"}
        ticket.reload
        expect(ticket.title).to match /some new title/i
      end

      it "redirects to ticket show page after update" do
        patch :update, id: ticket.id, ticket: {title: "some new title"}
        expect(response).to redirect_to(ticket)
      end

      it "renders edit template with fail update" do
        patch :update, id: ticket.id, ticket: { title: ""}
        expect(response).to render_template(:edit)
      end

      it "sets flash message with successful update" do
        patch :update, id: ticket.id, ticket: { title: "new title"}
        expect(flash[:notice]).to be
      end

      it "raises an error if trying to update another user's ticket" do
        expect do
        patch :update, id: ticket1.id, ticket: { title: "new title"}
        end.to raise_error
      end


    end
  end

  describe "#destroy" do

    context "with signed in user" do
      before {sign_in user}
      before { ticket }

      it "removes the ticket from the database" do
        expect do
          delete :destroy, id: ticket.id 
        end.to change { Ticket.count }.by(-1)
      end

      it "redirects to tickets listings page with success!" do
        delete :destroy, id: ticket.id
        expect(response).to redirect_to(tickets_path)
      end

      it "raises error when trying to delete a ticket by another owner" do
        expect do
          delete :destroy, id: ticket1.id
        end.to raise_error
      end

    end
  end
end
