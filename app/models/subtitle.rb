class Subtitle < ActiveRecord::Base
  validates :sentence, presence: true
  validates :start, presence: true
  validates :stop,  presence: true
  validate :start_must_be_greater_than_zero
  validate :start_must_be_before_stop
  has_many :comments, dependent: :destroy

  default_scope -> { order('created_at ASC') }
  
  def start_must_be_greater_than_zero
    return unless start
    errors.add(:start, "must be greater than zero") unless
      self.start > 0
  end
  
  def start_must_be_before_stop
    return unless start and stop
    errors.add(:start, "must be before stop") unless
      self.start < self.stop
  end
end
