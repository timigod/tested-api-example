class TicketSerializer < ActiveModel::Serializer
  attributes :id, :subject, :status, :body, :created_at
  belongs_to :user
  belongs_to :assignee
  has_many :replies
end
