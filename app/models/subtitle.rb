class Subtitle < ActiveRecord::Base
  belongs_to :movie

  validates :sentence, presence: true
  validates :start, presence: true
  validates :stop,  presence: true
  validates :movie_id, presence: true
  validate :start_must_be_greater_than_zero
  validate :start_must_be_before_stop
  has_many :comments, dependent: :destroy
  has_many :reverse_examples, foreign_key: "subtitle_id", class_name: "Example", dependent: :destroy
  has_many :expressions, through: :reverse_examples, source: :expression
  default_scope -> { order('start ASC') }
  
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
