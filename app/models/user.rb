class User < ApplicationRecord
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  validates :name,     presence: true, length: { maximum: 40 }
  validates :email,    presence: true, 
                       length: { maximum: 255 }, 
                       uniqueness: { case_sensitive: false },
                       email_format: { message: "doesn't look like an email address" }
  
  before_create { generate_token(:remember_token) }
  before_create { generate_token(:activation_token) }
  
  # Sends an activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Check correctness of given token.
  def authenticated?(token)
    self[:activation_token] == token ? true : false
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  private
  
    # Generate random token.
    def generate_token(column)
      self[column] = SecureRandom.urlsafe_base64
    end
end
