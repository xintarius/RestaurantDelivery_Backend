# support tickets
class Api::SupportTicketsController < Api::ApplicationController

  def show_courier_ticket_details
    @ticket = current_courier.support_tickets.find(params[:id])

    render json: @ticket

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Nie znaleziono zgłoszenia" }, status: :not_found
  end

  def courier_ticket
    tickets = SupportTicket.where(courier: current_courier)
                 .select(:id, :subject, :message, :status, :created_at, :updated_at)

    render json: tickets
  end

  def create_courier_ticket
    ticket = SupportTicket.new(ticket_params)
    ticket.courier_id = current_courier
    if ticket.save
      render json: ticket, status: :created
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def ticket_params
    params.require(:support_ticket).permit(:subject, :message)
  end
end
