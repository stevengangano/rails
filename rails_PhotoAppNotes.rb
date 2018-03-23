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

  Type: (FOR DEVELOPMENT):

  Go to config/initializers/stripe.rb:

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

  production:
    secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
    stripe_publishable_key: ENV['stripe_publishable_key']
    stripe_secret_key: ENV['stripe_publishable_key']

    OR

    Type (FOR PRODUCTION):

    Rails.configuration.stripe = {
      :publishable_key => ENV['STRIPE_TEST_PUBLISHABLE_KEY'],
      :secret_key => ENV['STRIPE_TEST_SECRET_KEY']
    }

    Stripe.api_key = Rails.configuration.stripe[:secret_key]


Create .zshrc file and type:

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


Uploading image:

1) Add the following gems to your gemfile:

gem 'carrierwave'
gem 'carrierwave-aws', '~> 1.0', '>= 1.0.2'
gem 'mini_magick'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.2'

2) Generating Image resources:


   Type: rails generate scaffold Image name:string picture:string user:references

   #MIGRATION
   create    db/migrate/20180322190456_create_images.rb
   #MODELS
   create    app/models/image.rb
   create      test/models/image_test.rb
   create      test/fixtures/images.yml
    route    resources :images
   invoke  scaffold_controller
   #CONTROLLER
   create    app/controllers/images_controller.rb
   #CRUD ROUTES
   create      app/views/images
   create      app/views/images/index.html.erb
   create      app/views/images/edit.html.erb
   create      app/views/images/show.html.erb
   create      app/views/images/new.html.erb
   create      app/views/images/_form.html.erb

   create      test/controllers/images_controller_test.rb

   create      app/helpers/images_helper.rb
   invoke      test_unit

   create      app/views/images/index.json.jbuilder
   create      app/views/images/show.json.jbuilder
   create      app/views/images/_image.json.jbuilder

   create      app/assets/javascripts/images.coffee

   create      app/assets/stylesheets/images.scss

   create    app/assets/stylesheets/scaffolds.scss

3) Type: rake db:migrate

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.string   "picture"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end


4) Adding bootstrap styling to views/images:

  Type: rails g bootstrap:themed Images
  Type: Y => overrides original styling to bootstrap


5) Create assosciation with Images and User:

  In models/user.rb, type:

  has_many :images => since user can add many images_helper

  In models/image.rb, check if it shows:

  belongs_to :user => generated by scaffold b/c we added "user:references" in scaffold generation


6) Creating an Image upload generator:

   Type: rails generate uploader Picture

   create  app/uploaders/picture_uploader.rb


 3) Go to uploaders/picture_uploader.rb

 class PictureUploader < CarrierWave::Uploader::Base
   include CarrierWave::MiniMagick
   process resize_to_limit: [300, 300]

   storage :file

   def store_dir
     "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
   end

   def extension_whitelist
     %w(jpg jpeg gif png)
   end

 end

7) Go to models/image.rb file:

    class Image < ActiveRecord::Base
      belongs_to :user
      #":picture" is from schema.rb. Needed to upload file. mount_uploader is from carrier-wave
      #"PictureUploader" is from uploaders/uploader.rb
      mount_uploader :picture, PictureUploader
      validate :picture_size
      validates_presence_of :picture

      private
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "should be less than 5MB")
        end
      end

    end

8)  Go to apps/views/images/_form.html.erb:

    1) Go to line 1, and add "multipart: true":

    <%= form_for @image, :html => { multipart: true, :class => "form-horizontal image" } do |f| %>

    2) Change the picture to accept image uploads of jpeg/gif/png:

    <div class="form-group">
      <%= f.label :picture, :class => 'control-label col-lg-2' %>
      <div class="col-lg-10">
        <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png', :class => 'form-control' %>
      </div>
      <%=f.error_span(:picture) %>
    </div>

    3) Remove class form-control class in the form above

    Note: Remove "User ID" form field

9) Go to 'images/new' in web browser to see if form works:

   Note if there is an error "uninitialized constant Image::PictureUploader",
   restart your server.


   6) Go to images_controller.rb, add ":picture" to "def image_params" method

   class ImagesController < ApplicationController
     before_action :set_image, only: [:show, :edit, :update, :destroy]

     # GET /images
     # GET /images.json
     def index
       @images = Image.all
     end

     # GET /images/1
     # GET /images/1.json
     def show
     end

     # GET /images/new
     def new
       @image = Image.new
     end

     # GET /images/1/edit
     def edit
     end

     # POST /images
     # POST /images.json
     def create
       @image = Image.new(image_params)
       @image.user = current_user

       respond_to do |format|
         if @image.save
           format.html { redirect_to @image, notice: 'Image was successfully created.' }
           format.json { render :show, status: :created, location: @image }
         else
           format.html { render :new }
           format.json { render json: @image.errors, status: :unprocessable_entity }
         end
       end
     end

     # PATCH/PUT /images/1
     # PATCH/PUT /images/1.json
     def update
       respond_to do |format|
         if @image.update(image_params)
           format.html { redirect_to @image, notice: 'Image was successfully updated.' }
           format.json { render :show, status: :ok, location: @image }
         else
           format.html { render :edit }
           format.json { render json: @image.errors, status: :unprocessable_entity }
         end
       end
     end

     # DELETE /images/1
     # DELETE /images/1.json
     def destroy
       @image.destroy
       respond_to do |format|
         format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
         format.json { head :no_content }
       end
     end

     private
       # Use callbacks to share common setup or constraints between actions.
       def set_image
         @image = Image.find(params[:id])
       end

       # Never trust parameters from the scary internet, only allow the white list through.
       def image_params
         params.require(:image).permit(:name, :picture, :user_id)
       end
   end


10) Showing user ID on views/images/show.html.erb:

    Go to 'create' action, in images_controller.rb:

    Type: @image.user = current_user => grabs current user info

    In views/images/show.html.erb:

    Type: @images.user_id => Grabs user ID (ex: 1), @images.inspect shows current_user info

11) Displaying image instead of a string to images/show.html.erb:

  <%- model_class = Image -%>
  <div class="page-header">
    <h1><%=t '.title', :default => model_class.model_name.human.titleize %></h1>
  </div>

  <dl class="dl-horizontal">
    <dt><strong><%= model_class.human_attribute_name(:name) %>:</strong></dt>
    <dd><%= @image.name %></dd>
    <dt><strong><%= model_class.human_attribute_name(:picture) %>:</strong></dt>

    #Grabs IMAGE URL and turns it into an image if image is a picture
    #(/uploads/image/picture/2/fb.jpg)
    <dd><%= image_tag(@image.picture.url, class: "img-thumbnail", size: "150x150") if @image.picture?,  %></dd> => Add this
    <dt><strong><%= model_class.human_attribute_name(:user_id) %>:</strong></dt>
    <dd><%= @image.user_id %></dd>
  </dl>

12) Remove links from form images/index.html.erb:

    Only show the "name" "picture" and "actions" column


13) Show images in images/index.html.erb:

  <% @images.each do |image| %>
  <tr>

    <td><%= link_to image.name, image_path(image) %></td> => Link to show page
    <td><%= image_tag(image.picture.url, class: "img-thumbnail", size: "150x150") %></td> => ADD this


Validating Images

14) White list for images jpg, jpeg, gif, png, go to uploadders/picture_uploader.rb:

    Uncomment:

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_whitelist
      %w(jpg jpeg gif png)
    end

15) Go to models/image.rb: => If image is greater than 5MB, show error.

    class Image < ActiveRecord::Base
      belongs_to :user
      mount_uploader :picture, PictureUploader
      validate :picture_size

      private
      def picture_size
        if picture.size > 5.megabytes
          errors.add(:picture, "should be less than 5MB")
        end
      end

    end

16) Create error message grom app/view/images/_form.html.erb:

    <script type="text/javascript">
      $('#image_picture').bind('change', function() {
      var size_in_megabytes = this.files[0].size/1024/1024;
        if (size_in_megabytes > 5) {
          alert('Maximum file size is 5MB.');
      }
    });
    <script>


17) Open your picture_uploader.rb file within the app/uploaders folder and add the following two lines right below the class definition:

    Note: Will only display if <= 300x300

    class PictureUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
      process resize_to_limit: [300, 300]

18) When an image is uploaded, it goes to:

  public/uploads/image/picture

  Note: This is from uploaders/uploader.rb:

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

Uploading images for production:

1) Create an AWS account (steven@therubythree.com)
2) Create a .env file in the root folder of photo-app and type:

    S3_BUCKET_NAME=
    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_REGION=

3) Go to ".gitignore" file in root path and type:

    # I don't want to show my secrets.yml and .env
    /config/secrets.yml
    .env
    .zshrc
    .profile

4) Create a bucket name on AWS by going to S3
5) Click on bucket name and go to properties
6) At the top, look for region in the URL:

  region=us-east-1

7) Grab Access key ID and secret access key from AWS and put into .env file:

    Go to name at the top > My security credentials


8) Fill in the information in .env file:

    S3_BUCKET_NAME=stebz-photo-app
    AWS_ACCESS_KEY_ID=AKIAJ46D5PG7JFXAAJYQ
    AWS_SECRET_ACCESS_KEY=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
    AWS_REGION=us-east-1

9) Go to config/application.rb and type:

   require "dotenv-rails" => So you can access S3 BUCKET IN CONSOLE

10) Go to rails console and type:

   ENV.fetch('AWS_ACCESS_KEY_ID') => shows ""
   ENV.fetch('AWS_SECRET_ACCESS_KEY') => shows ""
   ENV.fetch('AWS_REGION') => shows "us-east-1"

11) Set your credentials for AWS with heroku:

    heroku config:set S3_BUCKET_NAME=stebz-photo-app
    heroku config:set AWS_ACCESS_KEY_ID=AKIAJ46D5PG7JFXAAJYQ
    heroku config:set AWS_SECRET_ACCESS_KEY=WvC3XvbFvmPRkHsc6i3ZxUX7mmzWPXK3rt+CNqiU
    heroku config:set AWS_REGION=us-east-1

12) Go to https://github.com/sorentwo/carrierwave-aws and copy:

    CarrierWave.configure do |config|
      config.storage    = :aws
      config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
      config.aws_acl    = 'public-read'

      # Optionally define an asset host for configurations that are fronted by a
      # content host, such as CloudFront.
      config.asset_host = 'http://example.com'

      # The maximum period for authenticated_urls is only 7 days.
      config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

      # Set custom options such as cache control to leverage browser caching
      config.aws_attributes = {
        expires: 1.week.from_now.httpdate,
        cache_control: 'max-age=604800'
      }

      config.aws_credentials = {
        access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
        secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
        region:            ENV.fetch('AWS_REGION') # Required
      }

      # Optional: Signing of download urls, e.g. for serving private content through
      # CloudFront. Be sure you have the `cloudfront-signer` gem installed and
      # configured:
      # config.aws_signer = -> (unsigned_url, options) do
      #   Aws::CF::Signer.sign_url(unsigned_url, options)
      # end
    end

13) Create a file called config/initalizers/carrierwave.rb and paste:

    Note: Remove config.asset.host, and comments at the bottom like so:

    CarrierWave.configure do |config|
      config.storage    = :aws
      config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
      config.aws_acl    = 'public-read'

      # The maximum period for authenticated_urls is only 7 days.
      config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

      # Set custom options such as cache control to leverage browser caching
      config.aws_attributes = {
        expires: 1.week.from_now.httpdate,
        cache_control: 'max-age=604800'
      }

      config.aws_credentials = {
        access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
        secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
        region:            ENV.fetch('AWS_REGION') # Required
      }

    end

14) Go to uploads/uploader.rb:

    Change from storage:file to storage :aws

15) Restart rails server and upload an image:

    Right click image and open in a new tab to see if it's coming
    from s3 bucket

16) Go rails console and type: Image.all
17) Type: Image.find(id).picture

18) Customize upload button in images/_form.html.erb:

<div class="form-group">
  <%= f.label :picture, :class => 'control-label col-lg-2' %>
  <div class="col-lg-10">
    <label class="btn btn-primary">
      Upload an image <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png', style: 'display: none;' %>
    <label
  </div>
  <%=f.error_span(:picture) %>
</div>


ADDITIONAL NOTES:
1) FOR PRODUCTION CHANGE stripe.rb AND CHANGE secrets.yml
2) Credit card test info => 4012 8888 8888 1881
