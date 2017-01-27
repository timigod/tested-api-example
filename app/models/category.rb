class Category < ApplicationRecord
  before_create :make_slug
  validates_presence_of :name
  validates_presence_of :slug
  has_many :tickets

  private

  def make_slug
    self.slug = self.name.parameterize
  end
end
