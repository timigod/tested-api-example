class Api::V1::TicketsController < ApplicationController
  before_action :set_ticket, only: [:close, :reopen, :reply]
  before_action :verify_assignee_or_user, only: [:close, :reopen, :reply]

  def index
    case current_user.role
      when "registered"
        @tickets = Ticket.filter(filtering_params, {user_id: current_user.id})
      when "support"
        @tickets = Ticket.filter(filtering_params)
    end
    paginate json: @tickets, status: 200
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user = current_user
    if @ticket.save
      render json: @ticket, status: 201
    else
      render json: {errors: @ticket.errors.full_messages}, status: 422
    end
  end

  def reply
    if (@ticket.status == 'closed')
      head 403
    else
      @reply = Reply.new(body: params[:body], sender_id: current_user.id, ticket_id: @ticket.id)
      if @reply.save!
        render json: @reply, status: 201
      else
        render json: {errors: @reply.errors.full_messages}, status: 422
      end
    end
  end


  def close
    if @ticket.status == 'closed'
      head 403
    else
      ActiveRecord::Base.transaction do
        @ticket.update(status: :closed)
        @reply = Reply.create(body: 'closed', sender_id: current_user.id, ticket_id: @ticket.id, status_change: true)
        render json: @reply, status: 200
      end
    end
  end

  def reopen
    if @ticket.status == 'open'
      head 403
    else
      ActiveRecord::Base.transaction do
        @ticket.update(status: :open)
        @reply = Reply.create(body: 'reopened', sender_id: current_user.id, ticket_id: @ticket.id, status_change: true)
        render json: @reply, status: 200
      end
    end
  end

  private

  def verify_assignee_or_user
    if (current_user != @ticket.user && @ticket.assignee != current_user)
      head 403 and return
    end
  end


  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def filtering_params
    params.slice(:status, :user_id)
  end

  def ticket_params
    params.permit(:subject, :body, :category_id)
  end
end
