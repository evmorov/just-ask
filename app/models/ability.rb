class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can %i[questions answers comments users everywhere], :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment, Subscription], user_id: user.id
    can(:destroy, Attachment) { |attachment| user.author_of? attachment.attachable }
    can(%i[upvote downvote], [Question, Answer]) { |votable| !user.author_of?(votable) }
    can(:best, Answer) { |answer| user.author_of? answer.question }
    can :me, User
  end
end
