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

Portfolio:
World Series topic_id: 1
Superbowl topic_id: 2
Spring Training topic_id: 1

Topics:
1 baseball
2 football

For example:
2) Type: rails g model Topic title:string
3) rake db:migration
4) In models/topic.rb

  Type: validates_presence_of :title, :percent_utilized, :main_image
