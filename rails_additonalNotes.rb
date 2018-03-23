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
2)Creates views for each method
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
