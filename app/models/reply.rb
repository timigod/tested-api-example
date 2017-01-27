class Reply < ApplicationRecord
  validates_presence_of :ticket_id
  validates_presence_of :body
  validates_presence_of :sender_id

  belongs_to :sender, class_name: 'User'
  belongs_to :ticket


end
