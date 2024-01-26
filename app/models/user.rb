class User < ApplicationRecord
  has_many :reviews, dependent: :destroy

  has_secure_password

  validates :username, :name, presence: true
  validates :email, presence: true,
                    format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8, allow_blank: true }

  def gravatar_id
    Digest::MD5.hexdigest email.downcase
  end
end
