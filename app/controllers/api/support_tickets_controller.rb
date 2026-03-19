# support tickets
class SupportTicketsController < ApplicationController

  def create_courier_ticket
    ticket = SupportTicket.new(ticket_params)

    if ticket.save
      render json: ticket, status: :created
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ticket_params
    params.require(:support_ticket).permit(:courier, :subject, :message, :status)
  end
end