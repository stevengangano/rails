Photo-App

1) ADD to Gemfile:

gem 'devise'

gem 'twitter-bootstrap-rails'

gem 'devise-bootstrap-views'

Then run bundle install --without production

2) Install Devise

Then install devise:

rails generate devise:install

rails generate devise User

3)

Pull up the migration file that just got created and uncomment the 4 lines under confirmable:

t.string :confirmation_token

t.datetime :confirmed_at

t.datetime :confirmation_sent_at

t.string :unconfirmed_email

4)

Pull up the user.rb model file under app/models and in the line for devise, add in a:

:confirmable, after :registerable

5) Run migration to create "USERS" table => rake db:migrate


6) Go to application_controller:

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #Must be logged in to view any of the pages.
  before_action :authenticate_user! => Add this
end


7) Go to welcome_controller:

class WelcomeController < ApplicationController
  #Do not need to be signed in index page ("/")
  skip_before_action :authenticate_user!, only: [:index] => Add this

  def index
  end
end


9) Type: rails g bootstrap:install static

insert  app/assets/javascripts/application.js
create  app/assets/javascripts/bootstrap.js.coffee
create  app/assets/stylesheets/bootstrap_and_overrides.css
create  config/locales/en.bootstrap.yml
  gsub  app/assets/stylesheets/application.css

10) Type: rails g bootstrap:layout application
   Type: Y

   This overrides the styling for welcome/application.html.erb

11) rails g devise:views:locale en

   Creates config/locale/devise.en.yml

12) Type: rails g devise:views:bootstrap_templates

    create  app/views/devise
    create  app/views/devise/confirmations/new.html.erb
    create  app/views/devise/mailer/confirmation_instructions.html.erb
    create  app/views/devise/mailer/reset_password_instructions.html.erb
    create  app/views/devise/mailer/unlock_instructions.html.erb
    create  app/views/devise/passwords/edit.html.erb
    create  app/views/devise/passwords/new.html.erb
    create  app/views/devise/registrations/edit.html.erb
    create  app/views/devise/registrations/new.html.erb
    create  app/views/devise/sessions/new.html.erb
    create  app/views/devise/shared/_links.html.erb
    create  app/views/devise/unlocks/new.html.erb

13) Go to assets/stylesheets/application.css

    *= require devise_bootstrap_views => Add this
    *= require_tree .
    *= require_self


Setting up Email with confirmation

1)

First add in your credit card details to your heroku account

Then enter in:

heroku addons:create sendgrid:starter

Set the sendgrid apikey credentials you created for heroku:
(Go to yourapp => SendGrid => Settings => API KEYS)

API_KEY: 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

heroku config:set SENDGRID_USERNAME=apikey

heroku config:set SENDGRID_PASSWORD=enterintheapikey

To display your settings you can type in:

heroku config:get SENDGRID_USERNAME

2)

Open your .profile file:

export SENDGRID_USERNAME=apikey

export SENDGRID_PASSWORD=entireapikey

Then open a new terminal window for these to take effect

3) Under config/environment.rb file add in the following code at the bottom:

ActionMailer::Base.smtp_settings = {

:address => 'smtp.sendgrid.net',

:port => '587',

:authentication => :plain,

:user_name => ENV['SENDGRID_USERNAME'],

:password => ENV['SENDGRID_PASSWORD'],

:domain => 'heroku.com',

:enable_starttls_auto => true

}

3) Now update the development.rb file under config/environments folder and add the following two lines:

config.action_mailer.delivery_method = :test

config.action_mailer.default_url_options = { :host => :host => 'http://localhost:3000'}

4) Now update the production.rb file under config/environments folder and add the following two lines:

config.action_mailer.delivery_method = :smtp

config.action_mailer.default_url_options = { :host => 'yourherokuappname.herokuapp.com', :protocol => 'https'}

Test it out in development by signing up a user and then grabbing the confirmation link from the web output in your terminal and copying/pasting the link in your browser
