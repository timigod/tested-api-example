class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
  include DeviseTokenAuth::Concerns::User
  validates_presence_of :role
  validates_presence_of :image

  enum role: [:registered, :support, :admin]

  has_many :tickets
  has_many :replies, foreign_key: 'sender_id'
  has_many :assigned_tickets, class_name: 'Ticket', foreign_key: 'assignee_id'



  def assigned_tickets
    return Ticket.none unless self.role == :support
    super
  end
end


