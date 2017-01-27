require 'rails_helper'
require 'api/v1/tickets_controller'


RSpec.describe Api::V1::TicketsController, type: :controller do

  before(:all) do
    create_list(:open_ticket, 10)
    create_list(:closed_ticket, 10)
  end

  describe 'GET index' do
    it 'returns correct types' do
      get :index, @user_auth_headers
      expect_status(200)
      expect_json_types('*', optional(id: :int, subject: :string, body: :string, created_at: :date, user: {first_name: :string, last_name: :string, email: :string}))
    end

    it 'returns only tickets that belong to logged in user' do
      get :index, @user_auth_headers
      expect_status(200)
      expect_json('*.user', id: @user.id)
    end


    it 'returns correctly status filtered tickets' do
      status_filter = Ticket.statuses.keys.sample
      headers = {'status' => status_filter}
      headers.merge! @support_auth_headers
      get :index, headers
      expect_status(200)
      expect_json('*', status: status_filter)
    end

    it 'returns correctly user filtered tickets' do
      user_id_filter = User.includes(:tickets).where.not(tickets: {id: nil}).sample.id
      headers = {'user_id' => user_id_filter}
      headers.merge! @support_auth_headers
      get :index, headers
      expect_status(200)
      expect_json('*.user', id: user_id_filter)
    end
  end


  describe 'POST create' do
    it 'returns correct types' do
      body = {'subject' => Faker::Lorem.sentence, 'body' => Faker::Lorem.paragraph}
      body.merge!(@user_auth_headers)
      post :create, body
      expect_status(201)
      expect_json_types(id: :int, subject: :string, body: :string, created_at: :date,
                        user: {first_name: :string, last_name: :string, email: :string, image: :string},
                        assignee: {first_name: :string, last_name: :string, image: :string},
                        replies: :array_of_objects
      )
      expect_json(status: 'open')
    end

    it 'creates ticket for signed in user' do
      body = {'subject' => Faker::Lorem.sentence, 'body' => Faker::Lorem.paragraph}
      body.merge!(@user_auth_headers)
      post :create, body
      expect_status(201)
      expect_json('user', id: @user.id)
    end

    it 'prevents support from creating tickets' do
      body = {'subject' => Faker::Lorem.sentence, 'body' => Faker::Lorem.paragraph}
      body.merge!(@support_auth_headers)
      post :create, body
      expect_status(403)
    end
  end

  describe 'POST reply' do
    it 'returns correct response' do
      ticket_id = create(:open_ticket, user: @user).id
      body = {'id' => ticket_id, 'body' => Faker::Lorem.paragraph}
      body.merge!(@user_auth_headers)
      post :reply, body
      expect_status(201)
      expect_json_types(id: :int, ticket_id: :int, body: :string, created_at: :date, sender: {first_name: :string, last_name: :string, email: :string, image: :string, role: :string})
      expect_json(ticket_id: ticket_id, status_change: false)
      expect_json('sender', id: @user.id)
    end

    it 'prevents closed tickets from being replied' do
      ticket = create(:closed_ticket, user: @user)
      body = {'id' => ticket.id, 'body' => Faker::Lorem.paragraph}
      body.merge!(@user_auth_headers)
      post :reply, body
      expect_status(403)
    end
  end

  describe 'POST close' do
    it 'returns correct response' do
      ticket = create(:open_ticket, user: @user)
      body = {'id' => ticket.id}
      body.merge!(@user_auth_headers)
      post :close, body
      expect_status(200)
      expect(Ticket.find(ticket.id).status).to eq 'closed'
      expect_json_types(id: :int, ticket_id: :int, body: :string, created_at: :date, sender: {first_name: :string, last_name: :string, email: :string, image: :string, role: :string})
      expect_json(ticket_id: ticket.id, status_change: true, body: 'closed')
      expect_json('sender', id: @user.id)
    end

    it 'prevents closing already closed tickets' do
      ticket = create(:closed_ticket, user: @user)
      body = {'id' => ticket.id}
      body.merge!(@user_auth_headers)
      post :close, body
      expect_status(403)
    end
  end

  describe 'POST reopen' do
    it 'returns correct response' do
      ticket = create(:closed_ticket, user: @user)
      body = {'id' => ticket.id}
      body.merge!(@user_auth_headers)
      post :reopen, body
      expect_status(200)
      expect(Ticket.find(ticket.id).status).to eq 'open'
      expect_json_types(id: :int, ticket_id: :int, body: :string, created_at: :date, sender: {first_name: :string, last_name: :string, email: :string, image: :string, role: :string})
      expect_json(ticket_id: ticket.id, status_change: true, body: 'reopened')
      expect_json('sender', id: @user.id)
    end

    it 'prevents opening already closed tickets' do
      ticket = create(:open_ticket, user: @user)
      body = {'id' => ticket.id}
      body.merge!(@user_auth_headers)
      post :reopen, body
      expect_status(403)
    end
  end


end
