class Mnemonic < ActiveRecord::Base
  validates :aide, presence: true
  validates :user_id, presence: true
  belongs_to :user
  belongs_to :pinyindefinition
  belongs_to :gorodish
  has_many :images, dependent: :destroy
  validate :either_pinyindefinition_or_gorodish_mnemonic

  def either_pinyindefinition_or_gorodish_mnemonic
    if gorodish_id.nil? && pinyindefinition_id.nil?
      errors.add(:gorodish_id, "gorodish_id and pinyindefinition_id can't both be nil!")
    end
    if !gorodish_id.nil? && !pinyindefinition_id.nil?
      errors.add(:gorodish_id, "gorodish_id and pinyindefinition_id can't both be not nil!")
    end
  end
end
