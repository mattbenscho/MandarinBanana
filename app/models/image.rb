class Image < ActiveRecord::Base
  belongs_to :user
  belongs_to :mnemonic
  validates :user_id, presence: true
  validates :mnemonic_id, presence: true
end
