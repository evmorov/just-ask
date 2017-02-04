FactoryGirl.define do
  sequence :name do |n|
   "Test oauth application #{n}"
  end

  sequence :uid do |n|
    n
  end

  factory :oauth_application, class: Doorkeeper::Application do
    name
    redirect_uri 'urn:ietf:wg:oauth:2.0:oob'
    uid
    secret '87654321'
  end
end
