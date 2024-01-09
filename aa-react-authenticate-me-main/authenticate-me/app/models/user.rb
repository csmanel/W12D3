class User < ApplicationRecord
  has_secure_password
  validates :username, :email, :session_token, presence: true, uniqueness: true
  validates :username, length: { in: 3..40 }, format: {without: URI::MailTo::EMAIL_REGEXP, message: 'cant be an email'}
  validates :email, length: { in: 3..100 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { in:6..40}, allow_nil: true

before_validation :ensure_session_token 

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.authenticate(password)
      return user 
    else
      nil
    end
  end

  def reset_session_token! 
    self.session_token = generate_unique_session_token
    self.save! 
    self.session_token 
  end

  private 
  def ensure_session_token 
    self.session_token ||= generate_unique_session_token
  end

  def generate_unique_session_token 
    loop do
      token = SecureRandom::urlsafe_base64
      return token unless User.exists?(session_token: token)
    end
  end



end
