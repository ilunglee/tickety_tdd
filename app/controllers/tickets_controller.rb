class TicketsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_ticket, only: [:edit, :update, :destroy] 

  def index 
    @ticket = Ticket.new
    @tickets = Ticket.limit(10)
  end

  def create 
    respond_to do |format|
      @ticket = current_user.tickets.new(ticket_attributes)
      
      if @ticket.save 
        format.html{redirect_to tickets_path, notice: "Your ticket was created successfully!"}
        format.js{ render }
      else
        flash.now[:error] = "Please correct the form" 
        format.html{render :new}
        format.js { render js: "alert('you must fill in all the fields');" }
      end
    end

  end

  def show 
    @ticket   = Ticket.find params[:id]
  end

  def edit
  end

  def new
    @ticket = Ticket.new
  end

  def update
    respond_to do |format|
      if @ticket.update_attributes(ticket_attributes)
        if params.has_key? :page
          format.html{redirect_to tickets_path}
          format.js { render }
        else
          format.html{redirect_to @ticket, notice: "ticket updated successfully"}
        end
      else
        flash.now[:error] = "couldn't update"
        render :edit
      end
    end
  end

  def destroy
    if @ticket.destroy
      redirect_to tickets_path, notice: "quesiton deleted successfully"
    else
      redirect_to tickets_path, notice: "we had trouble deleting"
    end
  end


  private

  def find_ticket
    @ticket = current_user.tickets.find params[:id]
    redirect_to root_path, notice: "Access Denined" unless @ticket
  end

  def ticket_attributes
    params.require(:ticket).permit([:title, :body, :status]) # this requires the ticket object
  end

end
