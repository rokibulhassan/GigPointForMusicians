class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.have_facebook_credentials?
      can :read, :all
      can :create, Gig
      can :update, Gig do |gig|
        gig.try(:user_id) == user.id
      end
      can :destroy, Gig do |gig|
        gig.try(:user_id) == user.id
      end
    else
      can :read, Gig
    end
  end
end
