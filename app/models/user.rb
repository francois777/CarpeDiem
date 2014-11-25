class User < ActiveRecord::Base
  has_secure_password

  before_save { email.downcase! }
  before_create :create_remember_token

  validates :first_name, presence: true, length: { minimum: 2, maximum: 15 }
  validates :last_name,  presence: true, length: { minimum: 2, maximum: 25 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  # http://www.rubular.com
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 50 }
  validates :password, presence: true, length: {minimum: 6, maximum: 20 }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.hash(token)
    Digest:: SHA1.hexdigest(token.to_s)
  end

  def full_name
    first_name + ' ' + last_name
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end

end
