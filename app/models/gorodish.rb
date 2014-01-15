class Gorodish < ActiveRecord::Base
  validates :element, presence: true, uniqueness: { case_sensitive: false }
end
