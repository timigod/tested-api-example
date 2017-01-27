class ReplySerializer < ActiveModel::Serializer
  attributes :id, :ticket_id, :body, :created_at, :status_change
  belongs_to :sender
end
