class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def author_of?(obj)
    id == obj.user_id
  end

  def self.find_for_oauth(auth)
    transaction do
      authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
      return authorization.user if authorization

      email = auth.info.email
      user = User.find_by(email: email)

      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end

      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      user
    end
  end
end
