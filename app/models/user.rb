class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  validate :avatar_size
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  validates :name,     presence: true, length: { maximum: 40 }
  validates :email,    presence: true, 
                       length: { maximum: 255 }, 
                       uniqueness: { case_sensitive: false },
                       email_format: { message: "is invalid" }
  
  before_create { generate_token(:remember_token) }
  before_create { generate_token(:activation_token) }
  has_many :microposts, dependent: :destroy
  has_many :following_relationships, class_name: "Relationship",
                                     foreign_key: "follower_id",
                                     dependent: :destroy
  has_many :followers_relationships, class_name: "Relationship",
                                     foreign_key: "followed_id",
                                     dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed
  has_many :followers, through: :followers_relationships


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

  # Follow a user
  def follow(user)
    following << user
  end

  # Unfollow a user
  def unfollow(user)
    following.delete(user)
  end

  # True if current user is following the other user
  def following?(user)
    following.include?(user)
  end
  
  # Return all microposts of current user and following users
  def posts
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
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
