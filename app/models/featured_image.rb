class FeaturedImage < ActiveRecord::Base
  validates :data, presence: true
  validates :mnemonic_aide, presence: true
  validates :hanzi_id, presence: true
  validates :commentary, presence: true
  default_scope -> { order('created_at ASC') }
  belongs_to :hanzi
end
