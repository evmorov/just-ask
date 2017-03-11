class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook, :twitter]

  validates :username, presence: true, uniqueness: true

  def author_of?(obj)
    id == obj.user_id
  end

  def self.create_if_not_exist_w_auth(email, username, provider, uid)
    user = User.find_by(email: email)
    transaction do
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(
          username: username,
          email: email,
          password: password,
          password_confirmation: password
        )
      end
      user.authorizations.create!(provider: provider, uid: uid)
      user
    end
  end

  def self.find_by_auth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    authorization.try(:user)
  end
end
