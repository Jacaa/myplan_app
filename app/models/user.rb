class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validate :avatar_size
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  validates :name,     presence: true, length: { maximum: 40 }
  validates :email,    presence: true, 
                       length: { maximum: 255 }, 
                       uniqueness: { case_sensitive: false },
                       email_format: { message: "doesn't look like an email address" }
  
  before_create { generate_token(:remember_token) }
  before_create { generate_token(:activation_token) }
  
  # Send an activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # Send a password reset email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Set password reset token
  def set_reset_token
    token = SecureRandom.urlsafe_base64
    update_columns(reset_token: token, reset_sent_at: Time.zone.now)
  end

  # Check correctness of given token
  def authenticated?(column, token)
    self[column] == token ? true : false
  end

  # Activate an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  private
  
    # Generate random token
    def generate_token(column)
      self[column] = SecureRandom.urlsafe_base64
    end

    # Validate size of the avatar
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avatar, "should be less than 5MB")
      end
    end
end
