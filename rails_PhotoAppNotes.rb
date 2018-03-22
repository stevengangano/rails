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

NOTE for development:

comment config/environments/development.rb, production.rb
comment config/enviornment.rb
comment model/user.rb => add :confirmable



Update Layout and Test in Production

1) Go to application.html.erb file under app/views/layouts folder and remove the
sidebar code, then add in the following right after the </ul> tag after Link3:

<ul class="nav navbar-right col-md-4">

<% if current_user %>
  <li class="col-md-8 user-name">
    <%= link_to ('<i class="fa fa-user"></i> ' + truncate(current_user.email, length: 25)).html_safe,
                edit_user_registration_path, title: 'Edit Profile' %>
  </li>

  <li class="col-md-1">&nbsp;</li>

  <li class="col-md-3 logout"><%= link_to('Logout', destroy_user_session_path,
                              class: 'btn btn-xs btn-danger', title: 'Logout', :method => :delete) %></li>
  <% else %>
  <li class="col-md-4 pull-right">
    <%= link_to('Sign In', new_user_session_path, class: 'btn btn-primary', title: 'Sign In') %>
  </li>

  <% end %>

</ul>

2) Create a file under app/assets/stylesheets folder called custom.css.scss and
fill it in with the following(edit as you need):

.user-name {
  padding: 0 !important ;
  padding-left: 5px;
  padding-top: 15px !important;
  text-align: center;

  a {
    color: black !important;
    margin: 0 !important;
    padding: 5px!important;
  }

  a:hover, a:focus {
    color: #000 !important;
  }

}

.logout {
  padding-left: 0;
}

.nav.navbar-right {
  padding-bottom: 10px;
  padding-top: 5px;
}

.nav.navbar-nav {

  .navbar-link {
    border-radius: 5px;
    color: #fff;
    margin-top: 15px;
    padding: 8px;
  }

  .navbar-link:focus, .navbar-link:hover {
    background: #3071a9;
    color: #fff;
  }

  li a {
    margin-right: 5px;
  }
}

.nav.navbar-right li {
  .btn {
    color: #fff !important;
    margin-top: 5%;
  }

  .btn-danger:hover, .btn-danger:focus {
    background-color: darken(#d9534f,20%) !important;
  }

  .btn-primary:hover, .btn-primary:focus {
    background-color: darken(#428bca,20%) !important;
  }
}

.btn-primary:visited, .btn-danger:visited {
  color: #fff;
}

3) git push to github and heroku, heroku run rake db:migrate, sign up user
   and if no email confirmation, type: heroku logs to find confirmation link.

5) Style welcome/index.html.erb





Stripe for payment management

1) Sign up for an account at stripe.com
2) Copy publishable key and test key

Publishable key: pk_test_psArKofI111hHTSXd3gyCzek
Test key: sk_test_ZohGsPILiMHTYxozopAuwup2

3) Look at registrations_controller for Devise
4) Add gem 'stripe' => bundle Install
5) Go to config/initializers, create file stripe.rb:

  Type:

  Rails.configuration.stripe = {


  :publishable_key => Rails.application.secrets.stripe_publishable_key,
  :secret_key => Rails.application.secrets.stripe_secret_key

  }

  Stripe.api_key = Rails.application.secrets.stripe_secret_key

  Go to config/secrets.yml:

  development:
    secret_key_base: 9eb8298ea024afb9105937d19e40e56f4c59b39218d50a154842fef37f017b2b5a45f4a7348b987220795da7a3783925e14e1f2e51c350acbff3350a4aa1df80
    stripe_publishable_key: pk_test_psArKofI111hHTSXd3gyCzek
    stripe_secret_key: sk_test_ZohGsPILiMHTYxozopAuwup2

  test:
    secret_key_base: d08e36064d0209960d502035c768b447c2394dd65f9df06cf1b092cb79c6cf3e0225d3d36c6596850f1c7ba9f768e6d54fbe2801be709521fad21aa6d94fb799

  # Do not keep production secrets in the repository,
  # instead read values from the environment.
  production:
    secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
    stripe_publishable_key: ENV['stripe_publishable_key']
    stripe_secret_key: ENV['stripe_publishable_key']

Open your .zshrc file and type: (https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac)

export STRIPE_TEST_SECRET_KEY=yoursecrettestkeyfromstripe
export STRIPE_TEST_PUBLISHABLE_KEY=yourpublishabletestkeyfromstripe

Open a new terminal window for these to take effect

Now set these for heroku from your terminal window type in:

heroku config:set STRIPE_TEST_SECRET_KEY=yoursecrettestkey
heroku config:set STRIPE_TEST_PUBLISHABLE_KEY=yourpublishabletestkey

Create Payment Model

1) Type: rails generate model Payment email:string token:string user_id:integer
2) Type: rake db:migrate
3) Create associations between user and payment Models

   Go to models/user.rb:

   class User < ActiveRecord::Base
     # Include default devise modules. Others available are:
     # :confirmable, :lockable, :timeoutable and :omniauthable
     devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :trackable, :validatable
     has_one :payment => Add this
     #will handle payment through the registrations new form
     accepts_nested_attributes_for :payment => Add this
   end

   Go to models/payment.rb:

   class Payment < ActiveRecord::Base
     #acces atributes from payment form in views/devise/registrations/new.html.erb:
     attr_accessor :card_number, :card_CVV, :card_expires_mont, :card_expires_year

     belongs_to :user

     #Displays months Jan - Dec
     def self.month_options
       Date::MONTHNAMES.compact.each_with_index.map { |name, i | ["#{i+1} - #{{name}}", i+1]}
     end

     #Displays today's year - 10 years from today's date
     def self.year_options
       (Date.today.year..(Date.today.year+10)).to_a
     end


     def process_payment
       customer = Stripe::Customer.create email: email, card: token

       Stripe::Charge.create customer: customer.id,
                             amount: 10000,
                             description: 'Premium',
                             currency: 'usd'
     end

   end


Update form for credit card payments

1) Go to views/devise/registrations/new.html.erb:

    <%= fields_for( :payment) do |p| %>
      <div class="row col-md-12">
          #CARD NUMBER
          <div class="form-group col-md-4 no-left-padding">
              <%= p.label :card_number, "Card Number", data: { stripe: 'label'} %>
              <%= p.text_field :card_number, class: "form-control", required: true, data: { stripe: 'number'} %>
          </div>
          #CARD CVV
          <div class="form-group col-md-2">
              <%= p.label :card_cvv, "Card CVV", data: { stripe: 'label'} %>
              <%= p.text_field :card_cvv, class: "form-control", required: true, data: { stripe: 'cvc'} %>
          </div>
          <div class="form-group col-md-6">
              <div class="col-md-12">
                <%= p.label :card_expires, "Card Expires", data: { stripe: 'label'} %>
              </div>
              #EXP MONTH dropdown
              <div class="col-md-3">
                <%= p.select :card_expires_month, options_for_select(Payment.month_options),
                { include_blank: 'Month'},
                "data-stripe" => "exp-month",
                class: "form-control", required: true %>
              </div>
              #EXP YEAR drop down
              <div class="col-md-3">
                <%= p.select :card_expires_year, options_for_select(Payment.year_options.push),
                { include_blank: 'exp-month'},
                class: "form-control",
                data: {stripe: "exp-year"}, required: true %>
              </div>
          </div>
      </div>
    <% end %>


Adding Javascript Events for form submission:

1) Go to your application.html.erb file under app/views/layouts folder and right above the line for <%= javascript_include_tag "application" %> enter in the following:

<%= javascript_include_tag "https://js.stripe.com/v2/" %>

2) Go to new.html.erb file under app/views/devise/registrations folder and on top of the file add in the following code:

<script language="Javascript">
  Stripe.setPublishableKey("pk_test_psArKofI111hHTSXd3gyCzek");
</script>

3) In the <%= form_for line add a class of 'cc_form' and make it look like below:

<%= form_for(resource, :as => resource_name, :url => registration_path(resource_name), html: { role: "form", class: 'cc_form' }) do |f| %>

4) Under app/assets/javascripts folder, create a file called credit_card_form.js and fill it in with the following code:

$(document).ready(function() {

  var show_error, stripeResponseHandler, submitHandler;

  submitHandler = function (event) {
     var $form = $(event.target);
     $form.find("input[type=submit]").prop("disabled", true);

     //If Stripe was initialized correctly this will create a token using the credit card info
     if(Stripe){
       Stripe.card.createToken($form, stripeResponseHandler);
     } else {
       show_error("Failed to load credit card processing functionality. Please reload this page in your browser.")
     }
     return false;
  };

  $(".cc_form").on('submit', submitHandler);

  stripeResponseHandler = function (status, response) {
    var token, $form;

    $form = $('.cc_form');

    if (response.error) {
      console.log(response.error.message);
      show_error(response.error.message);
      $form.find("input[type=submit]").prop("disabled", false);
    } else {
      token = response.id;
      $form.append($("<input type=\"hidden\" name=\"payment[token]\" />").val(token));
      $("[data-stripe=number]").remove();
      $("[data-stripe=cvv]").remove();
      $("[data-stripe=exp-year]").remove();
      $("[data-stripe=exp-month]").remove();
      $("[data-stripe=label]").remove();
      $form.get(0).submit();
    }

    return false;
  };
  show_error = function (message) {
    if($("#flash-messages").size() < 1){
      $('div.container.main div:first').prepend("<div id='flash-messages'></div>")
    }
    $("#flash-messages").html('<div class="alert alert-warning"><a class="close" data-dismiss="alert">×</a><div id="flash_alert">' + message + '</div></div>');
    $('.alert').delay(5000).fadeOut(3000);
    return false;
  };
});


Note above where we wrote $("[data-stripe=cvv]").remove();, if using a new account in stripe, change the cvv here with cvc, so data-stripe=cvc


Create registrations_controller.rb:

class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.class.transaction do
      resource.save
    yield resource if block_given?
    if resource.persisted?
      @payment = Payment.new({ email: params["user"]["email"],
        token: params[:payment]["token"], user_id: resource.id })

        flash[:error] = "Please check registrations errors" unless @payment.valid?

        begin
          @payment.process_payment
          @payment.save
        rescue Exception => e
          flash[:error] = e.message

          resource.destroy
          puts 'Payment failed'
          render :new and return
        end

        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end
  end

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:payment)
  end
end

Go to config/routes.rb

Rails.application.routes.draw do
  #For registrations look at my controllers/registrations_controller.rb then go to devise/registrations_controller.rb
  devise_for :users, :controllers => { :registrations => 'registrations' } => ADD this
  root 'welcome#index'


Fixing conflict bug (when a user signs up the first time there is an error)

1) Go to javascript/application.js:

  Remove "//= require turbolinks"

2) Remove gem "turbolinks" => Run bundle install

****ADD CONFIRMABLE FOR PRODUCTION****
