class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :subtitle
  belongs_to :hanzi
  default_scope -> { order(Arel.sql('created_at ASC')) }
  validates :user_id, presence: true
  validates :content, presence: true
  validate :either_subtitle_or_hanzi_comment

  def either_subtitle_or_hanzi_comment
    if hanzi_id.nil? && subtitle_id.nil?
      errors.add(:hanzi_id, "hanzi_id and subtitle_id can't both be nil!")
    end
    if !hanzi_id.nil? && !subtitle_id.nil?
      errors.add(:hanzi_id, "hanzi_id and subtitle_id can't both be not nil!")
    end
  end
end
