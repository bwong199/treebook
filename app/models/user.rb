class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # attr_accessible :email, :password, :password_confirmation, :remember_me, 
  # 					:first_name, :last_name, :profile_name
has_attached_file :avatar, styles: {
  large: "800x800>", medium: "300x200>", small: "260x180>", thumb:"80x80#"
}
validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :profile_name, 
  			presence: true, 
  			uniqueness: true, 
  			format:{ 
  				with: /\A[a-zA-Z0-9_-]+\z/,
  				message: "must be formatted correctly."
  				}
  has_many :activities
  has_many :albums
  has_many :pictures
  has_many :statuses
  has_many :comments, through:  :statuses
  has_many :likes, through: :statuses
  has_many :user_friendships, dependent: :destroy
  has_many :friends, -> { where(user_friendships: { state: 'accepted' }).order('name DESC') }, :through => :user_friendships
  # has_many :friends, through: :user_friendships,conditions: {user_friendships: {state: 'accepted'}}

  has_many :pending_user_friendships, -> { where(state: 'pending') }, class_name: 'UserFriendship', foreign_key: 'user_id'
  # has_many :pending_user_friendships, class_name: "userFriendship", 
  #                                     foreign_key: :user_id,
  #                                     conditions: {state: 'pending'}

  has_many :pending_friends, through: :pending_user_friendships, source: :friend
  # has_many :pending_friends, through: :pending_user_friendships,
  #                                      sources: :friend
  has_many :requested_user_friendships,  -> { where(state: 'requested') },class_name: "UserFriendship", foreign_key: :user_id
           
  has_many :requested_friends, through: :requested_user_friendships, source: :friend

  has_many :blocked_user_friendships,  -> { where(state: 'blocked') },class_name: "UserFriendship", foreign_key: :user_id
           
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend

  has_many :accepted_user_friendships,  -> { where(state: 'accepted') },class_name: "UserFriendship", foreign_key: :user_id
           
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend

  has_attached_file :avatar

  def self.get_gravatars
    all.each do |user|
      if !user.avatar?
        user.avatar = URI.parse(user.gravatar_url)
        user.save
      end
    end
  end 

  def full_name
  	first_name + " " + last_name
  end 

  def to_param
    profile_name
  end

  def to_s
    first_name
  end 

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

  def accepted_friends?(other_user)
    accepted_friends.include?(other_user)
  end

  def create_activity(item, action)
    activity = activities.new
    activity.targetable = item 
    activity.action = action
    activity.save
    activity
  end

end
