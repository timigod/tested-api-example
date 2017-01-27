class Ticket < ApplicationRecord
  include Filterable
  validates_presence_of :status
  validates_presence_of :body
  validates_presence_of :subject
  belongs_to :user
  belongs_to :category
  has_many :replies
  belongs_to :assignee, -> { where role: :support }, class_name: 'User', foreign_key: 'assignee_id', counter_cache: :assigned_tickets_count

  enum status: [:open, :closed]

  scope :status, -> (status) { where status: Ticket.statuses[status] }
  scope :user_id, -> (user_id) { where user_id: user_id }
  after_create :assign_support


  def assign_support
    self.assignee = selected_support
    self.save
    Notifier.support_assignment(selected_support, self).deliver
  end

  private



  def selected_support
    users = User.where(role: :support).order('assigned_tickets_count ASC').group_by(&:assigned_tickets_count)
    minimum = users.keys.min
    user = users[minimum].sample
    return user
  end


end
