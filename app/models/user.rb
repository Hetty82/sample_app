# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible :email, :name, :password, :password_confirmation
  has_many :microposts, dependent: :destroy

  before_save { self.email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  has_secure_password # moved it here for ordering error messages
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.alphabetical
    reorder("name ASC")
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
