class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    #before_save { self.email = email.downcase }
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: { with:VALID_EMAIL_REGEX }, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    validates :phone_number, presence: true, length: { is: 9 }
    has_secure_password
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def feed(compare = '', time = 0)
        following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
        if time == 0
            Micropost.where(" (user_id IN (#{following_ids}) OR user_id = :user_id) ", user_id: id)
        else
            query = "created_at #{compare}"
            Micropost.where(" (user_id IN (#{following_ids}) OR user_id = :user_id) AND #{query} :time", user_id: id, time: time)
        end
    end

    # Follows a user.
    def follow(other_user)
        following << other_user
    end
    
    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end
    
    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end
end
