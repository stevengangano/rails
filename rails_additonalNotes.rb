EXTRA NOTES:

Notice: <%%= notice %>

Generators:

Creating a model generator:

Type: rails g model Skill title:string percent_utilized:integer

Note:
1) Creates a migration File
2) Creates a model File
3) Type: rake db:migrate => to update the schema
4) Go to rails console:

  Type: Skill.create!(title: "Rails", percent_utilized: 75) => ! fails silently

  "Skill" from Skill.create is from the model class Skill

5) Type: Skill.all => shows all skills

6) skills_controller.rb:

def home
  @skills = Skill.all
end

7) models/skill.rb:

class Skill < ApplicationRecord

end

8) view/home.html.erb:

<%= @skills.inspect %> => Shows all skill data. In console Skill.all


Creating controller pages with generator:

Type: rails g controller Pages home about contact

Note:
1)Creates a controller with defined methods
2)Creates views for home about and contact
3)Creates routes for each each page

Data Flow (MVC = Model View Controller)

pages_controller.rb:

def home
  @posts = Blog.all
end

models/blog.rb:

class Blog < ApplicationRecord

end

view/home.html.erb:

<%= @posts.inspect %> => Shows all blog data. In console Blog.all

Creating a resource generator (minimalist generator):

Type: rails g resource Portfolio title: string subtitle:string body:text main_image:text_area thumb_image:text_area

Note:
1) Creates a migration file
2) Creates model file
3) Creates controller
4) Creates a views folder
5) Creates CRUD routes in routes.rb
6) Type: rake db:migrate

Changing scaffolding defaults:

Go to config/locales/application.rb:

1) change templating engine :erb to :ejs
2) Changing test framework
3) Change stylesheets and javascript to false to prevent generating
   with scaffolds

Overriding scaffolding template for index.html.erb:

1) Create lib/templates/erb/scaffold/index.html.erb (create)
2) Type for example: <h1> My post </h1>
3) If a scaffold is generated it will always show My Post on index.html






Data Flow in Rails:

1) Create a migration File => creates columns title, percent_utilized, main_image
2) Create a model File => can be empty, needed for validations
3) Type: rake db:migrate => to update the schema.rb
4) Go to rails console and create some data based of schema:

  Type: Portfolio.create!(title: "World Series", percent_utilized: 75, main_image: "http://placehold.it/350x200") => ! fails silently
        Portfolio.create!(title: "Superbowl", percent_utilized: 50, main_image: "http://placehold.it/350x100")
        Portfolio.create!(title: "Spring Training", percent_utilized: 50, main_image: "http://placehold.it/350x100")
5) Creates routes
6) Create controller

  class PortfoliosController < ApplicatonController
    def index
      @portfolio_items = Portfolio.all
    end

    def new
      @portfolio_item = Portfolio.new
    end

    def create
      @portfolio_item = Portfolio.new(params.require(:portfolio).permit(:title, :percent_utilized)
      if @portfolio_item.save, => if able to save,
        flash[:notice] = "Article was successfully created" => it displays flash message and
          redirect_to portfolios_path
        else
          redirect_to portfolios_path
    end

    def edit
      @portfolio_item = Portfolio.find(params[:id])
    end

    def update
      @portfolio_item = Portfolio.find(params[:id])
      if @portfolio.save => If you are able to save to the database,
          flash[:notice] = "Article was successfully created" => it displays flash message. Linked to views/application.html.erb
          redirect_to portfolios_path => redirects to "/article"
        else
          render :new => if not, render "/portfolio/new". ":new" is method at top.
        end
    end

    def show
      @portfolio_item = Portfolio.find(params[:id])
    end

    def destroy
      @portfolio_item = Portfolio.find(params[:id])
      @portfolio_item.destroy => Destroys the portfolio
      flash[:notice] = "Article was successfully deleted"
      redirect_to portfolio_path => Redirects to /portfolio
    end
  end

7) Create a index.html.erb

  <%= @portfolio_items.inspect %> => shows all items from Portfolio.all

  <% @portfolio_items.each do |portfolio_item| %>
    <p> <%= link_to portfolio_item.title, portofolio_path(portfolio_item.id) %> </p> => "title" can be found in schema.rb
    <p> <%= portfolio_item.percent_utilized %> </p> => "percent_utilized" can be found in schema.rb
    <%= image_tag portfolio_item.main_image unless portfolio_item.main_image.nil? %> => Will allow the form to submit if no image is in database

    <%= link_to "Edit", edit_portfolio_path(portfolio_item.id) %> => OR
    <a href="portfolios/<%= #{{portfolio_item.id}} %>/edit"> Edit Two </a>
    <%= link_to "Delete", portfolio_path(portfolio_item), method: :delete, data: { confirm: 'Are you sure?'} %> => Knows which path bc of the "DELETE" VERB. See rake routes.

  <% end %>


8) Create new.html.erb

  <%= form_for(@portfolio_item) do |f| %>
    <div class="field">
      <%= f.label :title %><br>
      <%= f.text_field :title %>
    </div>
    <div class="field">
      <%= f.label :percent_utilized %><br>
      <%= f.text_field :percent_utilized %>
    </div>

    <div class="field">
      <%= f.label :main_image %><br>
      <%= f.text_field :main_image %>
    </div>

    <div class="actions">
      <%= f.submit %>
    </div>
  <% end %>

9) Create edit.html.erb (copy new.html.erb) and create edit action

<%= form_for(@portfolio_item) do |f| %> => form_for populates text fields
  <div class="field">
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </div>
  <div class="field">
    <%= f.label :percent_utilized %><br>
    <%= f.text_field :percent_utilized %>
  </div>

  <div class="field">
    <%= f.label :main_image %><br>
    <%= f.text_field :main_image %>
  </div>

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>

10) Create update method

11) Create links to edit button on index.html.erb

    Link to URL: <%= link_to "Create Link", new_portfolio_url %> => Shows URL

12) Create show action in controller

13) Create show.html.erb: => go to portfolio/1/edit

    <h1> Show </h1>

    <%= @portfolio_item.inspect %>

    <%= image_tag @portfolio_item.main_image %>
    <h1> <%= @portfolio_item.title %> </h1>
    <p> <%= @portfolio_item.percent_utilized %> </p>

14) Create show link in index.html.erb:

15) Create destroy action in controller.rb
16) Create destroy button in index.html.erb


Routing Notes

1) Custom hard route

get '/lead/advertising/something/lead', to: 'pages#contact', as: 'lead'

Note:
Instead of 'lead/advertising/something_path', you can type 'lead_path'

2) Nesting

routes.rb
namespace :admin do
  get 'dashboard/main'
  get 'dashbaord/user'
  get 'dashboard/blog'
end

controllers/admin/dashboard_controller.rb
class Admin::DashboardController < application_controller
    def main
    end

    def user
    end

    def blog
    end
end

Create: views/admin/dashboard/main.html.erb, user.html.erb, blog.html.erb

Go to: admin/dashboard/main

Rebuilding Routes for 'resources:posts'

1) routes.rb

  Type: resources :posts => ":posts" has to be named after the controller

2) Create posts_controller.rb

  PostsController < ApplicationController
    def index
    end
    def missing
    end
  end

3) Create folder posts
4) Create index.html.erb
5) Go to "/posts" = index.html.erb

Globbing => A catch all post

1)
resources:posts => should be on top
get 'posts/*missing', to: 'posts#missing'

2)
creating missing.html.erb

3)
Type: posts/anything you want

Creating completing custom routes:

routes.rb:

get 'query/:else/:another_one', to 'pages#something'

controller.rb:

#needs to be match routes
def something
  @else = params[:else]
  @another = params[:another_one]
end

views/something.html.erb:

<h1> <%= @else %> <h1>
<h1> <%= @another %> <h1>

Type in web brower: /query/test1/test2

Displays on screen: test1, test2


Models

#title and percent utilized must be required or error will show
#will show on notice in application.html.erb
validates_presence_of :title, :percent_utilized, :main_image

Data Relationships

1) Create a relationship between Topic and Portfolio tables

  For example:

  Portfolio:
  World Series topic_id: 1
  Superbowl topic_id: 2
  Spring Training topic_id: 1

  Topics:
  1 baseball
  2 football

2) Type: rails g model Topic title:string
3) rake db:migration
4) In models/topic.rb

  Type: validates_presence_of :title

5) Create a migration file:

  Type: rails g migration add_topic_reference_to_portfolio topic:references

  Go to migration file and check if:

  :portfolio, :topic, foreign_key: true

6) If so, rake db:migrate. Should add topic_id to "portfolio table"

7) Go to models/portfolio.rb

  Type: belongs_to :topic

8) Go to models/topic.rb:

  Type: has_many :portfolios

9) Create a few Topics

   In console, type:

   Topic.create!(title: "Ruby Programming")
   Topic.create!(title: "Software Engineering")

10) Create a portfolio with a topic id:

    Portfolio.create!(title: "Spring Training", percent_utilized: 50, main_image: "http://placehold.it/350x100", topic_id: Topic.first.id)


Custom Scopes (?)


Setting defaults => For example: if no main image is typed into the form

Go to models/portfolio.rb:

after_initialize :set_defaults

def set_defaults
 self.main_image ||= "https://plcehold.it/600x400"
end

OR

if self.main_image == nil
  self.main_image = "https://plcehold.it/600x400"
end


Customizing PAGE TITLE

1) go to views/layouts/application.html.erb

 <title> <%= @page_title %> </title>
  <meta name="keywords" content="<%= @seo_keywords %>" />

2) Go to controller

  def index
    @article = Article.all
    @page_title = "Home Page"
  end

  def show
    @page_title = "Show Page"
  end

3) Go to application_controller.rb:

  before_filter :set_title

  def set_title
    @page_title = "Devcamp Portfolio |  My Portfolio Website"
  end

4) Create a concern to export "set_title". Create a file called concerns/default_page_content.rb:

  module DefaultPageContent => must be camelcase match file name
    extend ActiveSupport::Concern

    included do
      before_filter :set_title
    do

    def set_title
      @page_title = "Devcamp Portfolio |  My Portfolio Website"
      @seo_keywords = "Steven Gangano portfolio website"
    end

  end

5) Go to controllers/application_controller.rb:

  class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include DeviseWhitelist
    include CurrentUserConcern
    include DefaultPageContent => Add this

  end

Imaging

1) Creating a background image in bootstrap 4.

CSS:
#background {
  position: fixed;
  top: 50%;
  left: 50%;
  min-width: 100%;
  min-height: 100%;
  width: auto;
  height: auto;
  z-index: -100;
  -webkit-transform: translateX(-50%) translateY(-50%);
  transform: translateX(-50%) translateY(-50%);
  background: image-url('home_bg.png') no-repeat;
  background-size: cover;
}

application.html.erb:

<div class="site-wrapper">
   <div class="site-wrapper-inner">
     <div class="cover-container">

       <div id="background"></div> => Add background here

       <%= render "shared/application_nav" %>

       <%= yield %>

       <%= render "shared/application_footer" %>

       <%= source_helper("application") %>

     </div>
   </div>
 </div>

 2) Creating a video background:

 <body>
  <div class="site-wrapper">
    <div class="site-wrapper-inner">
      <div class="cover-container">

        <%= video_tag(
            'HardDrivePhotojpeg.mp4',
            id: 'background',
            autoplay: true,
            loop: true,
            muted: true,
            poster: 'home_bg.png'
          )
          %>

        <%= render "shared/application_nav" %>

        <%= yield %>

        <%= render "shared/application_footer" %>

        <%= source_helper("application") %>

      </div>
    </div>
  </div>
</body>


Creating a layout aside from application.html.erb:

1) Create layouts/portfolio.html.erb and copy and paste from application.html.erb
2) Go to portfolioos_controller.rb and type:
3) #instead of application.html.erb, it uses portfolio.html.erb
  layout "portfolio"
4) Create a portfolios.scss
5) To link to layouts/portfolio.html.erb, type:

  <%= stylesheet_link_tag    'portfolios' ....

6) Add this to config/initializers/assets.rb and restart server:

  Type:

  Rails.application.config.assets.precompile += %w( portfolios.css )


Using helpers:

Example 1:

1) Go to helpers/application_helper.rb:

    module ApplicationHelper
      def sample_helper
        "<p> My Helper </p>".html_safe
      end
    end

2) Go to home/index.html.erb:

<%= sample_helper %


Example 2:

1) Go to helpers/application_helper.rb:

def login_helper
   if current_user.is_a?(User)
     link_to "Logout", destroy_user_session_path, method: :delete
   else
     (link_to "Register", new_user_registration_path) + "<br>".html_safe + (link_to "Login", new_user_session_path)
   end
end


2) Go to home/index.html.erb:

<%= login_helper % <br>


Note:

If mostly ruby code, use helper.
Partials usually if there is redundancy.

Content Helpers:

Example 1:

Writing in htm.erb:

<%= content_tag :h1, class: "my-special-class" do %>
  Hi, I'm in an h1 tag
<% end %>

Example 2:

1) Go to helpers/application_helper.rb:

  def sample_helper
    content_tag(:h3, "My H3 tag", class: "my-class")
  end


2) views/welcome/index.html.erb:

   <%= sample_helper %


Turning off whitelisting parameters (alternative not recommended):

   Go to config/locales/application.rb:

   module Portfolio
     class Application < Rails::Application
       config.action_controller.permit_all_parameters = true => Type this
     end
   end


   Go to controllers/portfolioos_controller.rb:

   private
   #method to add data to the database
     def portfolio_params
       params.require(:portfolioo) => remove '.permit(:title, :subtitle, :body)'
     end


    Note: This will allow title, subtitle, body to be passed in when creating new


View helpers:

Time:

<%= distance_of_time_in_words(blog.created_at, Time.now)  >% ago

Displays something like: 12 days ago

Currency:

<%= number_to_currency "150" %

Phone:

<%= number_to_phone "4155845318" %

Percentage:

<%= number_to_percentage "80.5" %

Adds commas (For example: 134,434,697,934,257):

<%= number_with_delimiter "134434697934257" %


Rendering in an html.erb file:

def index
  @books = ['ROR','React', 'Java']
end

1)

<% @books.each do |book| %>
  <p><%= book %> </p>
<%= end %>

2)
<%= @books %> => Displays whatever is sent from the controller as '@books'

3)
<% puts 'here there' %> => Shows in the console

Rendering collections:

  Index.html.erb => "collection: @portofolios" is from "def index" in controller
  "partial: portfolio" is from "_portfolio.html.erb

  <%= render partial: 'portfolio', collection: @portfolios %>


  porfolio in "portfolio.body" is singular from collection: @portfolio
  _portfolio.html.erb

  <div class="blog-post">
    <h2 class="blog-post-title"> </h2>
    <p class="blog-post-meta"> Created: <%= distance_of_time_in_words(portfolio.inspect, Time.now) %> ago </p>
    <p class="blog-post-meta">
      <td><%= link_to "Show", portfolio_show_path(portfolio) %></td> /
      <td><%= link_to "Edit", edit_portfolioo_path(portfolio) if logged_in?(:site_admin) %></td> /
      <td><%= link_to "Delete", portfolioo_path(portfolio), method: :delete, data: { confirm: 'Are you sure?' } if logged_in?(:site_admin) %></td>
    <p> <%= portfolio.body %> </p>
  </div>


Spacer template:

_blog_ruler.html.erb:
<hr>

index.html.erb:
<%= render partial: @blogs, spacer_template: 'blog_ruler'

Note:
Will not put an <hr> at the top and bottom. ONLY IN BETWEEN.


Wiring up bootstrap in application.html.erb:

<%= stylesheet_link_tag "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >%

Caching:
<% cache do %>
  <div>
    <% @books.each do |book| %>
      <p><%= book %> </p>
    <%= end %>
  </div>
<% end %

Note:

This will load faster but only want to add to areas that will not change

Petergate for authorization:

1) Methods needed for Petergate that come with devise:

user_signed_in?
current_user
after_sign_in_path_for(current_user)
authenticate_user!

2) Run the generators:

   Type: rails g petergate:install

   insert  app/models/user.rb => Some code was inserted
   create  db/migrate/20180327185835_add_roles_to_users.rb
   Type: rake

3) Type: rake db:migrate

   Adds column "roles" to "Users" table

4) Petergate can only work with regular models (ActiveRecord) so
   Guest User needs to have its own model:

   1) Create a controller called controllers/guest_user.rb:

      Type:
      #This inherts from the User model
      class GuestUser < User
       attr_accessor :name, :first_name, :last_name, :email
      end


   2) Go to controllers/application_controller.rb and type:

   def current_user
     super || guest_user
   end

   def guest_user
     guest = GuestUser.new
     guest.name = "Guest User"
     guest.first_name = "Guest"
     guest.last_name = "User"
     guest.email = "guest@example.com"
     guest
   end

  3) Go to application_helper.rb:

  module ApplicationHelper

    def sample_helper
      content_tag(:h3, "My H3 tag application helper", class: "my-class")
    end

    def login_helper
       #if current user is a guest user, show register and login links
       if current_user.is_a?(GuestUser)
        (link_to "Register", new_user_registration_path) + "<br>".html_safe + (link_to "Login", new_user_session_path)
       else
        link_to "Logout", destroy_user_session_path, method: :delete
       end
    end

  end

  Implementing authorization:

  1) Go rails console and type User.all:

    <User id: 1, email: "stevengangano@yahoo.com", name: "Steven Gangano", created_at: "2018-03-26 21:43:16", updated_at: "2018-03-27 19:31:47", roles: "user">

    Note: By default, the role given is "user"

  2) Go to models/user.rb and create a new "role" (site_admin):

    petergate(roles: [:site_admin], multiple: false)

  3) Go to portfolios_controller.rb:

     At the top, type:

     access all: [:show, :index], user: {except: [:destroy]}, site_admin: :all


     Note:

     Access all = All users (guest, logged in user, site admin)
     have access to the show and index methods

     user = has access to every action except destroy

     site_admin = has access to all actions in the controller

  4) Changing the role of "user" to "site_admin"

     Type:

     1) user = User.find(1)
     2) user.update!(roles: "site_admin")
     3) User.find(1)
     4) Check if role was changed to "site_admin"


  5) Giving authorization to edit and destroy links to "site_admin":

    <td><%= link_to "Edit", edit_portfolioo_path(portfolio_item) if logged_in?(:site_admin) %></td>
    <td><%= link_to "Delete", portfolioo_path(portfolio_item), method: :delete, data: { confirm: 'Are you sure?' } if logged_in?(:site_admin) %></td>


Styling with bootstrap 4:

1) gem 'bootstrap', '~> 4.0.0' => Bootstrap 4
2) Create scss stylesheets. Add app/assets/stylesheets/custom.css.scss

   Type:
   @import "bootstrap"; => only need this and gem bootstrap 4.0

Creating cover page with bootstrap 4:

1) Go to layouts/portfolio.html.erb:

   Type:

   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

2) Copy and paste bootstrap 4 cover.html into welcome/index.html.erb

3) Copy and paste bootstrap 4 cover.css into stylesheets/portfolio.scss

Linking helpers with html.erb:

application_helper.rb

def login_helper style = ''
   #if current user is a guest user, show register and login links
   if current_user.is_a?(GuestUser)
    (link_to "Register", new_user_registration_path, class: style) + " ".html_safe + (link_to "Login", new_user_session_path, class: style)
   else
    (link_to "Logout", destroy_user_session_path, method: :delete, class: style) + " ".html_safe + (link_to "Edit", edit_user_registration_path, class: style)
   end
end

welcome/index.html.erb:

<a href="#" class="nav-link">Home</a>
#'nav-link' is the class
<%= login_helper 'nav-link' >%

Styling scaffold submit buttons:

Must type
<div class="actions">
  <%= f.submit "Submit", class: 'btn btn-primary' %>
</div>


Styling with font-aweseome:

1) Go to rubygems.org
2) Type: font-awesome-rails and grab latest version => bundle install
3) @import "font-awesome" => top of scss file. must be above @import "bootstrap"
4) <li><a href="#"> <%= fa_icon "twitter" %> </a></li> => embedded ruby

Nav helpers (inserting nav links):

1) Go to application_helper.rb:

   Type:

   def nav_helper style, tag_type
 nav_links =< <NAV
 <#{tag_type}><a href="#{root_path}" class="#{style}">Home</a></#{tag_type}>
 <#{tag_type}><a href="#{portfolio_path}" class="#{style}">About me</a></#{tag_type}>
 NAV
     nav_links.html_safe
   end

2) Go to nav partial and insert:

  <ul class="navbar-nav">
    <li class="nav-item active">
      <div><%= link_to "Home", root_path, class:'nav-link'  %></div>
    </li>
    <li class="nav-item">
      <div><%= link_to "Blog", blogs_path, class:'nav-link' %></div>
    </li>
    <li class="nav-item">
      <div><%= link_to "Portfolio", portfolio_path, class:'nav-link' %></div>
    </li>
    <%= nav_helper 'nav-link', 'li' %> => Add class and tag
  </ul>

Checking if a page is active:

1) Go to application_helper.rb:

  def active? path
    "active" if current_page? path
  end

2) Insert inside ${active?} inside class

  Type:

  def nav_helper style, tag_type
  nav_links =< <NAV
  <#{tag_type}><a href="#{root_path}" class="#{style} #{active? root_path}">Home</a></#{tag_type}>
  <#{tag_type}><a href="#{portfolio_path}" class="#{style} #{active? portfolio_path}">About me</a></#{tag_type}>
  NAV
    nav_links.html_safe
  end

Better way of checking if page is active inside application_helper.rb:

def nav_items
   [
     {
       url: root_path,
       title: 'Home'
     },
     {
       url: about_me_path,
       title: 'About Me'
     },
     {
       url: contact_path,
       title: 'Contact'
     },
     {
       url: blogs_path,
       title: 'Blog'
     },
     {
       url: portfolios_path,
       title: 'Portfolio'
     },
   ]
 end

 def nav_helper style, tag_type
   nav_links = ''

   nav_items.each do |item|
     nav_links << "<#{tag_type}><a href='#{item[:url]}' class='#{style} #{active? item[:url]}'>#{item[:title]}</a></#{tag_type}>"
   end

   nav_links.html_safe
 end

 def active? path
   "active" if current_page? path
 end

 Authorization and classes:

 <div class="row <%= "sortable" if logged_in?(:site_admin) %>" >

 Note:

 The class "sortable" is only available to the :site_admin



Using Gritter(Displaying flash messages):

1) Type: gem 'gritter', '~> 1.2'
2) Type: rails g gritter:locale
3) Go to application.js and type:

    //= require gritter
4) Go to scss files and at the top, type:

  @import 'gritter';

5) Go to helpers/application.rb:

   Type:

   def alerts
     alert = (flash[:alert] || flash[:error] || flash[:notice])

     if alert
       alert_generator alert
     end
   end

   def alert_generator msg
     js add_gritter(msg, title: "Stebs Portfolio", sticky:false)
   end

6) Go to _form/html.erb and type:

  <% if @portfolio.errors.any? %>
    <% @portfolio.errors.full_messages.each do |error| %> => Loops through each error message
      <%= alert_generator error %>
    <% end %>
  <% end %>


7) Go to layouts/portfolio.rb and type:

   <%= alerts %>

Creating a form from scratch:

<form action-"/portfolio" method="post">
  <input type="hidden" value="<%= form_authenticity_token %>" name="form_authenticity_token">

 <div class="field">
   <label for="guide_title">Title</label>
   <input type="text" name"@portfolio[title]" id="guide_title">
 </div>


 <div class="field">
   <label for="guide_title">Subtitle</label>
   <textarea row="5" cols="60" name="@portfolio[subtitle]"></textarea>
 </div>

 <div class="field">
   <input type="submit">
 </div>

</form>


Using Lib and using twitter to fetch tweets:

1) Make lib directory available for portfolio:

   Go to config/locales/application.rb:

   Type:

   module Portfolio
     class Application < Rails::Application
       config.active_record.raise_in_transactional_callbacks = true
       config.action_controller.permit_all_parameters = true

       config.eager_load_paths << "#{Rails.root}/lib" => Add this
     end
   end

2) Create a file in lib/social_tool.rb and type:

    module SocialTool
      def self.twitter_search
      end
    end

3) Get twitter gem from rubygems.org:

   gem 'twitter', '~> 6.2'


4)  Go to https://apps.twitter.com and grab API KEYS

5) Go to lib/social_tool.rb and type:

module Social Tool
  def self.twitter_search
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_CONSUMER_SECRET")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
    end
  end
end

6) Create .env file and enter the keys:

  TWITTER_CONSUMER_KEY=see .env file
  TWITTER_CONSUMER_SECRET=see .env file
  TWITTER_ACCESS_TOKEN=see .env file
  TWITTER_ACCESS_SECRET=see .env file

7) Testing to see if API key is being fetched:

   Go rails consle and type:

   ENV.fetch("TWITTER_CONSUMER_KEY")


8) Add line to fetch data:

  module SocialTool
    def self.twitter_search
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch("TWITTER_CONSUMER_KEY")
        config.consumer_secret     = ENV.fetch("TWITTER_CONSUMER_SECRET")
        config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
        config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
      end

      #Add This. Grabs 6 of the most recent tweets with "#rails"
      client.search("type anything here", result_type: 'recent').take(6).collect do |tweet|
        "#{tweet.user.screen_name}: #{tweet.text}"
      end

    end
  end

9) Create a route to view tweets (config/routes.rb), type:

   get 'tech-news', to: 'home#tech_news'

10) Create action fom home_controller.rb:

    def tech_news
      @tweets = SocialTool.twitter_search
    end

11) Create file for view (home/tech_news.html.erb):

    <div class="inner cover">
      <h1 class="cover-heading">Rails News</h1>

      <div class="row">
        <% @tweets.each do |tweet| %>
          <div class="col-md-6">
            <div class="tech-news">
              <div class="card">
                <%= tweet %>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>

12) Create a helper (helpers/home_helper.rb) Taking a tweet and making the links
within the string clickable:

module HomeHelper
  def twitter_parser tweet
    #For practice purposes in rails console
    tweet = "ReactDOM: Learn Ruby on Rails: How to easily build high tech web apps #rubyonrails #ror #ruby #rails #rails5 #sql #mysql… https://t.co/NRiJ1zKSB5"

    #regex needed to look for a link and make it clickable within a string
    regex = %r{
      \b
      (
        (?: [a-z][\w-]+:
         (?: /{1,3} | [a-z0-9%] ) |
          www\d{0,3}[.] |
          [a-z0-9.\-]+[.][a-z]{2,4}/
        )
        (?:
         [^\s()<>]+ | \(([^\s()<>]+|(\([^\s()<>]+\)))*\)
        )+
        (?:
          \(([^\s()<>]+|(\([^\s()<>]+\)))*\) |
          [^\s`!()\[\]{};:'".,<>?«»“”‘’]
        )
      )
    }ix

    #method used to find url in string surround it within an a tag
    tweet.gsub(regex) do |url|
      "<a href=#{url} target='_blank'>#{url}</a>"
    end.html_safe

  end

end

13) Testing in rails console:

    1) Type: tweet = "ReactDOM: Learn Ruby on Rails: How to easily build high tech web apps #rubyonrails #ror #ruby #rails #rails5 #sql #mysql… https://t.co/NRiJ1zKSB5"
    2) Type: regular expression above
    3) type: tweet.gsub(regex) { |url| "<a href=#{url} target='_blank'>#{url}</a>" }
    4) Should return a string => "ReactDOM: Learn Ruby on Rails: How to easily build high tech web apps #rubyonrails #ror #ruby #rails #rails5 #sql #mysql… <a href=https://t.co/NRiJ1zKSB5 target='_blank'>https://t.co/NRiJ1zKSB5</a>"


14) Go to home/tech_news.html.erb and type:

<div class="inner cover">
  <h1 class="cover-heading">Rails News</h1>

  <div class="row">
    <% @tweets.each do |tweet| %>
      <div class="col-md-6">
        <div class="tech-news">
          <div class="card">
            <%= twitter_parser tweet %> => Add method from helper here
          </div>
        </div>
      </div>
    <% end %>
  </div>
</div>


Ruby Gems:

Bootstrap:

1) Go rubygems.org to get bootstrap ruby gem => bundle install
2) Gemfilelock shows all your dependencies for your Gemfile
3) Check if sprockets-rails in Gemfilelock is at least v2.3.2
3) Change application.css to application.scss
4) Type: @import 'bootstrap'; at the top of all .scss files
5) Go to application.js and include bootstrap-sprockets:

  //= require jquery
  //= require jquery_ujs
  //= require bootstrap-sprockets => Add this

Debugging:

For example:

When to use 'def self.any_method':

1) When your calling it from within the same controller:

  @portfolio = Portfolioo.two_portfolios => same as Portfolioo.limit(2) => only shows 2 blogs

2) Go to models/portfolio.rb:

  def self.two_portfolios
    limit(2)
  end

3) Debugging "@portfolio" with puts:

  @portfolio = Portfolioo.two_portfolios
  puts "*" * 500
  puts @portfolio.inspect
  puts "*" * 500

4) Using byebug:

  @portfolio = Portfolioo.two_portfolios
  byebug

  Note: Go to terminal and it shows the application stopped at this point.
  Anything declared prior to the byebug will work. Anything after will be
  "nil". To exit, type "continue" in the terminal.

  Also type, "params" in the terminal. It will show controller, action name (
  for example: index create, show, destroy, etc), where the page is calling from.

5) Using pry-byebug:

   Example 1:

   1) Go to gemfile and type: gem 'pry-byebug' => run "bundle"
   2) For example, forgot to add ':show' in the before action in portfolios
      controller:

      before_action :set_portfolio_item, only: [:edit, :update, :destroy]

   3) Go to portfolio.show page and and at the top type:

      <% binding.pry % => embedded ruby for html.erb files

      Note:

      Type: params => will show which controller, action

    4) Go to the action and at the top type:

       <% binding.pry %

    5) Then type what variable is suppose to go in there:

       For example, type: @portfolio

    6) If "nil", that means it is missing.


   Example 2:

   1) For example, type:

     def index
       binding.pry
       @portfolio = Portfolioo.all
       # @portfolio = Portfolioo.paginate(page: params[:page], per_page: 5)
       @page_title = "Portfolio | Home"
     end

   2) Go to terminal

   3) Type: @portfolio => displays nil

   4) Step over to the next line, type: "next" or "continue"

   5) Type: @portfolio => displays portfolio variable

   6) To exit, type: "exit"


Creating a method example:

Application controller:

class Application Controller < ActionController::Base

2)

before_action :set_copyright

3)

def set_copyright
    @copyright = DevcampViewTool::Renderer.copyright 'Steven', 'All Rights Reserved'
  end

end

1)

module DevcampViewTool
    class Renderer
      def self.copyright name, msg
        "&copy; #{Time.now year} | <b>#{name}<b> #{msg}.html_safe"
      end
    end
  end

4) Layouts/application.html.erb:

   <%= @copyright %


Creating a method so blogs are in order by time:

1) Go to models/portfolio.rb:

   def self.recent
     order("created_at DESC")
   end

2) Go to controller/portfoioos_controller.rb:


  def index
    @portfolio = Portfolioo.recent.all
    #or
    @portfolio = Portfolioo.recent.paginate(page: params[:page], per_page: 5)
  end

  Creating a category topics for blogs:

  1) Type: rails g model Topic title:string

    Note:
    Creates a migration File with table of "topics" and column of "title"
    Creates a model File (models/topic.rb)


  2) Type: rake db: migrate

  3) Create a migration file:

    Type: rails g migration add_topic_reference_to_blogs topic:references

    Go to migration file and check if:

    :blogs, :topic, foreign_key: true

  4) If so, rake db:migrate. Should add topic_id to "blogs" table

  5) Go to models/blog.rb

    Type: belongs_to :topic

  6) Go to models/topic.rb:

    Type: has_many :blogs


  7) Go to blog_controller.rb:

    Add ":topic_id" to "def blog_params"


  8) Create form dropdown to select topic:

      <div class="form-group">
      <%= f.label :topic_id %><br>
      <%= f.collection_select(:topic_id, Topic.all, :id, :title, => :title (topic name)
                              {
                                selected: @blog.topic_id, => add topic ID to the blog
                                include_blank: true
                              },
                              class: 'form-control'
                              )
      %>
    </div>


  9) Display topic name in blog/show.html.erb:

  <p>
    <strong>Title:</strong>
    <%= @blog.title %>
  </p>

  <p> <%= @blog.topic.title %> </p> => Add this


  <p>
    <strong>Body:</strong>
    <%= @blog.body %>
  </p>


  10) Creating topics from the console:

      Topic.create!(title: "Rails")


  11) Create index page and show page for topics:

      Type: rails g controller Topics index show

      Creates: index.html.erb, show.html.erb, index and show routes
      in routes.rb

      Note: Index page displays the list of topics to choose from
      Show page displays blogs associated with that topic.

  12) Refactor index and show routes in routes.rb:

      Change: get 'topics/index', get 'topics/show' to

      resources :topics, only: [:index, :show]

      Note:

      Type: rake routes to see if '/topics' and '/topics/:id' is shown

  13) Go to topics_controller.rb and type:

      class TopicsController < ApplicationController
        layout 'portfolio'
        def index
          @topics = Topic.all
        end

        def show
          @topic = Topic.find(params[:id])
        end

      end

  14) Test in index.html.erb:

      <% @topics.each do |topic| %>
        <h1><%= topic. title %></h1>
      <% end %>

  15) Test in show.html.erb:

      <h1><%= @topic.title %> </h1>


  16) Associate each topic with blog in topics_controller.rb:


      class TopicsController < ApplicationController
        layout 'portfolio'
        def index
          @topics = Topic.all
        end

        def show
          @topic = Topic.find(params[:id])
          @blogs = @topic.blogs.all #can add pagination and recent
        end

      end

  17) Go to topics/show.html.erb:

      <h1><%= @topic.title %> </h1>

      <%= render @blogs %> => Add this. Renders blogs under the same topic


  18) Render topics on topics/index.html.erb:

      <h1> Topics </h1>

      <%= render @topics %

  19) Create partial for the collection @topics (topics/_topic.html.erb):


      <div>
        <%= link_to topic.title, topic_path(topic) %>
      </div>


      Note:

      This creates links to blogs only associated
      with the topic assigned to it


  20) Showing topic links that ONLY have blogs:

      Go to models/topic.rb and type:

      def self.with_blogs
        includes[:blogs].where.not(blogs: { id: nil })
      end


  21) Go to topics_controller.rb:

  class TopicsController < ApplicationController
    before_action :set_sidebar_topics, only: [:index] => Add this
    layout 'portfolio'

    def index
      @topics = Topic.all
    end

    def show
      @topic = Topic.find(params[:id])
      #passed to show page
      @blogs = @topic.blogs.all #can use paginate and recent
    end

    #ADD THIS
    private
    def set_sidebar_topics
      @side_bar_topics = Topic.with_blogs
    end

  end

  22) Go to topics/_topic.html.erb and type:

      <% @side_bar_topics.each do |topic| %>
        <%= link_to topic.title, topic_path(topic) %>
      <% end %>


Dropping a table:
1) rails generate migration DropInstalls

2)
class DropInstalls < ActiveRecord::Migration
  def change
    drop_table :installs
  end
end





















Uploading an image:
1)
gem 'carrierwave'
gem 'carrierwave-aws', '~> 1.0', '>= 1.0.2'
gem 'mini_magick'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.2'
gem 'fog' => dont neeeded this

2) Type: rails generate uploader Portfolio

   creates a file called uploaders/uploader.rb

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

4) Go to models/image.rb.

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

5) Customize form in images/_form.html.erb:

Line 1:
<%= form_for @image, :html => { multipart: true, :class => "form-horizontal image" } do |f| %>

<div class="form-group">
  <%= f.label :name, :class => 'control-label col-lg-2' %>
  <div class="col-lg-10">
    <%= f.text_field :name, :class => 'form-control' %>
  </div>
  <%=f.error_span(:name) %>
</div>

<div class="form-group">
  <%= f.label :picture, :class => 'control-label col-lg-2' %>
  <div class="col-lg-10">

Line 2:
    #ADD THIS LINE
    <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png' %>
  </div>
  <%=f.error_span(:picture) %>
</div>

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

6) Go to views/images/show.html.erb:

  <dl class="dl-horizontal">
    <dt><strong><%= model_class.human_attribute_name(:name) %>:</strong></dt>
    <dd><%= @image.name %></dd>
    <dt><strong><%= model_class.human_attribute_name(:picture) %>:</strong></dt>
    #Displaying image on show page. Type @image.s
    <dd><%= image_tag(@image.picture.url, class: 'img-thumbnail', size: "250x150") if @image.picture? %></dd>
    <dt><strong><%= model_class.human_attribute_name(:user_id) %>:</strong></dt>
    <dd><%= @image.user_id %></dd>
  </dl>

7) When an image is uploaded, it goes to:

  public/uploads/image/picture

  Note: This is from uploaders/uploader.rb:

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

Storing images on AWS:

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

4) Create a bucket name on AWS by going to S3
5) Click on bucket name and go to properties
6) At the top, look for region in the URL:

region=us-east-1

7) Enter region and and bucket name in ".env" file

    S3_BUCKET_NAME=stebz-photo-app
    AWS_ACCESS_KEY_ID=
    AWS_SECRET_ACCESS_KEY=
    AWS_REGION=us-east-1

8) Go to config/application.rb and type:

   require "dotenv-rails" => So you can access S3 BUCKET IN CONSOLE

9) Go to rails console and type:

   ENV.fetch('S3_BUCKET_NAME') => shows "stebz-photo-app"

10) Grab Access key ID and secret access key from AWS and put into .env file:

    Go to name at the top > My security credentials

11) Go to rails console and type:

    ENV.fetch('AWS_ACCESS_KEY_ID') => shows ""
    ENV.fetch('AWS_SECRET_ACCESS_KEY') => shows ""
    ENV.fetch('AWS_REGION') => shows "us-east-1"

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
