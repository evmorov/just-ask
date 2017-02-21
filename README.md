# Just-Ask

Just-Ask is a Stack Overflow clone that was made for educational purpose. Written in [Ruby on Rails 5](http://rubyonrails.org/).

## User stories

- Guest can sign up
- User can sign in and sign out
- User can sign in with Facebook or Twitter
- User can ask a question
- User can post an answer to a question
- User can comment a question and an answer
- User can edit or delete his question or answer
- User can vote for a question or an answer
- User can add files when creating an answer or asking a question
- User can delete his files
- Author of a question can mark any answer as the best answer
- User can subscribe to a question for new answers
- Users receive a daily digest with questions that were created in last 24 hours
- User can search a question, answer, comment or everywhere

## Some technologies are used

### Gems

- [cancancan](https://github.com/CanCanCommunity/cancancan) for authorization
- [capistrano](https://github.com/capistrano/capistrano) for deploying the code
- [carrierwave](https://github.com/carrierwaveuploader/carrierwave) and [cacoon](https://github.com/nathanvda/cocoon) for adding files
- [devise](https://github.com/plataformatec/devise) for authentification
- [doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) for OAuth2 providers
- [omniauth](https://github.com/omniauth/omniauth) for authentification with social networks
- [responders](https://github.com/plataformatec/responders) for drying up controllers
- [sidekiq](https://github.com/mperham/sidekiq) for background processing
- [skim](https://github.com/appjudo/skim) for client-side templates
- [slim](https://github.com/slim-template/slim) as a template language
- [thinking-spinx](https://github.com/pat/thinking-sphinx) for connecting ActiveRecord with Sphinx

### Rails built-in features

- [Action Cable](http://edgeguides.rubyonrails.org/action_cable_overview.html) for real-time features
- [Nested Forms](http://guides.rubyonrails.org/form_helpers.html#nested-forms) and [Polymorphic Associations](http://guides.rubyonrails.org/association_basics.html#polymorphic-associations)
- REST API

### Testing

The app has model, controller and acceptance (feature) specs.

- [RSpec](https://github.com/rspec/rspec)
- [Capybara](https://github.com/teamcapybara/capybara)
