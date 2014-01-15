class Gorodish < ActiveRecord::Base
  validates :element, presence: true, uniqueness: { case_sensitive: false }
  has_many :mnemonics, dependent: :destroy
end
