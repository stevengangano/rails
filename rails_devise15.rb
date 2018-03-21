Devise (Rails 4.2.8)

1) Type: git pull => checks if you are up to database
2) Type: git checkout -b authentication => creates a new branch
3) Go to rubygems.org/rubygems
4) Search for devise and include into gemfile, run bundle install

    Type: gem Devise
    Type: bundle install

  Note: Devise includes bcrypt (password encryption algorithm, stored
  as a hash instead of a string"), ORM_adapater (another way to connect
  to the database), warden (stores session data)

5) Install devise generator

  Type:

  rails generate devise:install => creates the 2 files below

  1) create config/initializers/devise.rb:

    -Changing password legnth:
      config.password.length = 6..128 (min..max)

    -validate email formats by changing the regex

    -config.reset_password_with - 6.hours => You have 6 hrs to reset password before it expires

    -config.mailer_sender = 'support@devcamp.com' => For example, if someone forgets their password an email is sent to them. This is the "from" category.


  2) create config/locales/devise.en.yml

  Some setup you must do manually if you haven't yet:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in config/environments/development.rb:

       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }  => Put this in config/environments/development.rb at the very bottom

     In production, :host should be set to the actual host of your application.

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

       root to: "home#index"

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p> => Include in application.html
       <p class="alert"><%= alert %></p> => Include in application.html

  4. You can copy Devise views (for customization) to your app by running:

       rails g devise:views => Type this

       Note:

       Creates a devise folder in views. Devise folder has a bunch folders and files.
       Registration is signing up. Sessions is signing in.


6) Type: rails generate devise User

   Note:

   Creates a migration file, models/user.rb, and routes in routes.rb (devise_for :users)

7) Go to models/user.rb:

    class User < ActiveRecord::Base
      # Include default devise modules. Others available are:
      # :confirmable(they cant access app until they confirmed they are a real human. Email is sent to User to confirm), :lockable (Can lock a user out if they fail to login too many times), :timeoutable (ability to logout a user after 5 hours or something) and :omniauthable (Can integrate 3rd party through FB or google)
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable
    end


8) Type: rake routes => shows the routes for Users

9) Go to db migrations file => DeviseCreateUsers:

   You can uncomment confirmable, lockable so they can be used.

10) Include custom attribute name to the DeviseCreateUsers migration file:

    Type: t.string :name => Creates column name to trackable
    Type: rake db:migrate => If column does not show up in schema.rb, do a rake db:rollback, then reenter and do rake db:migrate.

11) Go to /users/sign_up => Create an account

12) Go rails console, type: User.last

    Note: This shows the last User entered in the database_authenticatable


Customizing routes

1) Type: rake routes => shows the current routes for users
2) Go to routes.rb

  Type: devise_for :users, path: '', path_names: { sign_in: 'login',
  sign_out: 'logout', sign_up: 'register'}

  Note:
  Instead of /users/sign_in => /login
  Instead of /users/sign_out => /logout
  Instead of /users/sign_up => /register

3) Creating logout link:

  To find out path, type: rake routes | grep user => shows updated routes

  Include in welcome/index.html.erb

  <%= link_to "Logout", destroy_user_sesion_path, method: :delete %>

4) Go to /register and create a new username.

5) Displaying logout link if user is signed in, displaying login link if
   user is signed out.

   Type: rake routes | grep user => shows updated routes

   Go to welcome.index.html.erb:

   <% if current_user %>
     <%= link_to "Logout", destroy_user_session_path, method: :delete %>
   <% else %>
     <%= link_to "Register", new_user_registration_path %>
     <%= link_to "Login", new_user_session_path %>
   <% end %>


Customize attributes (adding "name" to register form)

1) Go to views/devise/registrations/edit.html.erb(/edit), new.html.erb(register):

<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %> => autofocus: true = cursor will start there
</div>

Add this:

<div class="field">
  <%= f.label :name %><br />
  <%= f.text_field :name %>
</div>

2) Create a new user and then go to rails console

3) Type: User.last => does not show "name" b/c it was not white listed in the controller

4) Go to controllers/application_controller.rb

  Note:

  This is the master controller. When a controller is created it is always a subclass of
  Application Controller.

  Add this:

  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    #Run method "configure_permitted_parameters" if communicating with devise_for
    before_filter :configure_permitted_parameters, if: :devise_controller?

    #alternate way to white listing parameters that are passed in
    def configure_permitted_parameters
      #allows name to be passed to "sign_up" page aka /register
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      #allows name to be passed to "account_update" page aka /edit
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

  end

5) Create a new user (/register) then go to /edit. Name populates

6) Go to rails console, type User.all. Name shows.


Cleaning up the application controller

1) Putting the white list parameters from application_controller.rb in controllers/concerns/devise_whitelist.rb:

   Go to devise_whitelist.rb and type:

   #exporting white list params
   #module has to be named after the file
   #For example if named devise_white_list.rb = module DeviseWhiteList
   module DeviseWhitelist
     extend ActiveSupport::Concern

     included do
       #Run method "configure_permitted_parameters" if communicating with devise_for
       before_filter :configure_permitted_parameters, if: :devise_controller?
     end

     def configure_permitted_parameters
       #allows name to be passed to "sign_up" page aka /register
       devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
       #allows name to be passed to "account_update" page aka /edit
       devise_parameter_sanitizer.permit(:account_update, keys: [:name])
     end

   end

2) Go to controllers/application_controller.rb:

    class ApplicationController < ActionController::Base
      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :exception

      include DeviseWhitelist => import file here

    end

Virtual attributes => Create an attribute not in the migration/schema

1) Creating a variable to store first name and last name. Go to models/user.#!/usr/bin/env ruby -wKU

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #name must always be entered on the form
  validates_presence_of :name

  def first_name
    #Takes the first and last name, splits them, and then grabs 1st element
    #in the array.
    #For example:
    #Go to rails console => type User.all => User.last => user = User.last =>
    # => user.first_name => "John"
    self.name.split.first
  end

  def last_name
    self.name.split.last
  end

end

2) To call this first_name method go to views/welcome/index.html.erb:

  Type:

  #Displays: Hi, Steven welcome to the page
  <h1> Hi, <%= current_user.first_name if current_user %> welcome to the page </h1>


3) If an attribute is missing, you can update with the following in rails console:

  User.update_all(name: "Steven Gangano")

Using BCrypt to implement encryption

1) Type: gem install pry
2) Type: gem install bcrypt
3) Type: pry => pry is an alternative to irb
4) Type: require 'bcrypt'
5) For example encryping in the console:

   ssn = BCrypt::Password.create("612-45-9434") => returns a salt. Cost is default at 10.

6) Checking if SSN is correct
   Type: ssn == "612-45-9434" => returns true

7) Changing level of encryption for faster speed:

  For example:

  phone = BCrypt::Password.create('555-555-5555', cost: 4) => 4 is the mininum level of encryption

8) Generating random set of numbers 0-100 => rand 100
9) Generating random set of characters:

  Type: salt = BCrypt::Engine.generate_salt

10) Push to master branch


Overriding current_user in welcome/index.html.erb:

1) Go to application_controller.rb

  Type:
  #if there is current_user logged leave as is (super)
  #if not, show Guest User
  def current_user
    super || OpenStruct.new(name: "Guest User", first_name: "Guest",
    last_name: "User", email: "guest@yahoo.com")
  end

2) Go to welcome/index.html.erb:

  <h1> Hi, <%= current_user.first_name %> welcome to the page </h1> <br> => Remove if current_user

  <% if current_user.is_a?(User) %> => Add this
    <%= link_to "Logout", destroy_user_session_path, method: :delete %>
  <% else %>
    <%= link_to "Register", new_user_registration_path %> <br>
    <%= link_to "Login", new_user_session_path %>
  <% end %>


  Note:
  Remove "if current_user"
  Check if current_user is a class of "User" if so show login link, if not
  it is a class of "OpenStruct" show login/register links


3) Build a Concern for current_user method

   Create a controllers/concerns/current_user_concern.rb:

   def current_user
     super || guest_user
   end

   def guest_user
     OpenStruct.new(name: "Guest User",
                    first_name: "Guest",
                    last_name: "User",
                    email: "guest@yahoo.com")
   end

4) Go application_controller.rb:

  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include DeviseWhitelist
    include CurrentUserConcern => Add this]

  end


Controllers

application_controller.rb => Parent controller to every controller

Custom

Inspecting variable:

<%= params.inspect %>
<%= Portfolio.find(params[:id]).inspect %>
<%= Portfolio.find(params[:id]).title %>

Sessions => Taking data from one page to another

1) Go to application_controller.rb:

    before_action :set_source

    def set_source
      session[:source] = params[:q] if params [:q]
    end

3) go to show.html.erb

  <%= session.inspect %>
