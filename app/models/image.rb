class Image < ActiveRecord::Base
  attr_reader :file_remote_url
  belongs_to :user
  validates :user_id, presence: true

  has_attached_file :file, :styles => { :small => "160x120>" }

  def file_remote_url=(url_value)
    self.file = URI.parse(url_value)
    @file_remote_url = url_value
  end
end
