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

  def self.create_user_and_auth(auth)
    transaction do
      password = Devise.friendly_token[0, 20]
      user = User.create!(
        username: auth[:username],
        email: auth[:email],
        password: password,
        password_confirmation: password
      )
      user.authorizations.create!(provider: auth[:provider], uid: auth[:uid])
      user
    end
  end
end
