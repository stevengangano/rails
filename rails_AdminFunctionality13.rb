Creating admin functionality

1) Create migration file:

   Type: rails generate migration add_admin_to_users

2) Go to migration file and type:

   class AddAdminToUsers < ActiveRecord::Migration
    def change
      add_column :users, :admin, :boolean, default: false => Creates a new column in users table. See schema.rb
    end
   end

3) Type: rake db:migrate => To update schema.rb

4) Go rails console.

    Type: User.all => Displays all users in database. New column has been added to all users
    and are set to false as default.and

5) Checking if a user is an admin

   Type: user = User.last => grabs last user in the table
   Type: user.admin? => displays either true or false if admin

6) Setting a user to an admin through console

  Type: user.toggle!(:admin)
  Type: user.admin? => Displays true
  Type: user = User.last => Check if column was change to true


7) Give admin all access to edit/delete articles, delete users

   Go to articles_controller.rb and update 'require_same_user' action

     def require_same_user
      if current_user != @article.user and !current_user.admin? => Update.Checks if current user is not article creator & if current user is not admin. If current_user is admin, it will allow authority.
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to root_path
      end
    end

8) Go to articles/_article.html.erb:

    #If logged and current user = article creator or current user is admin, allow edit, delete, and show
    <% if logged_in? && (current_user == article.user || current_user.admin?) %>
     <div class="article-actions">
      <%= link_to 'Edit', edit_article_path(article), class: "btn btn-xs btn-primary" %>
      <%= link_to 'Delete', article_path(article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %>
      <%= link_to 'Show', article_path(article), class: "btn btn-xs btn-success" %>
     </div>
    <% end %>


9) Go articles/show.html.erb:

  <div class ="article-actions">
    #If logged and current user = article creator or current user is admin, allow edit, delete, and show
   <% if logged_in? && (current_user == @article.user || current_user.admin?) %>
    <%= link_to 'Edit', edit_article_path(@article), class: "btn btn-xs btn-primary" %>
    <%= link_to 'Delete', article_path(@article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %>
   <% end %>
    <%= link_to 'All articles', articles_path, class: "btn btn-xs btn-success" %>
  </div>

GIVING ADMIN ABILITY TO DELETE USERS

1) Go users_controller.rb:

class UsersController < ApplicationController

	before_action :set_user, only: [:edit, :update, :show]

	before_action :require_same_user, only: [:edit, :update, :destroy] => add "destroy" action

	before_action :require_admin, only: [:destroy]

	#/users
	def index
		@users = User.all
	end

	#/signup
	def new
		@user = User.new
	end

	 #POST   /users
   def create
     @user = User.new(user_params)
     if @user.save
			session[:user_id] = @user.id
      flash[:success] = "Welcome to the alpha blog #{@user.username}"
      redirect_to user_path(@user)
     else
      render 'new'
     end
   end

	 #/users/:id/edit
   def edit
#     @user = User.find(params[:id])
   end

	 #/users/:id/
   def update
#    	@user = User.find(params[:id])
   	if @user.update(user_params)
   	 flash[:success] = "Your account was updated successfully"
   	 redirect_to articles_path
   	else
   		render :edit
   	end
   end

	#/users/:id
	def show
# 		@user = User.find(params[:id])
	end

  CREATE DESTROY ACTION
	def destroy
		  @user = User.find(param[:id])
			@user.destroy
			flash[:danger] = "User and all articles have been deleted"
			redirect_to users_path
	end

	private
   def set_user
	 	@user = User.find(params[:id])
	 end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  IF CURRENT USER IS NOT THE USER AND USER IS NOT THE ADMIN, SHOW ERROR MESSAGE
	def require_same_user
	  if current_user != @user and !current_user.admin?
			flash[:danger] = "You can only edit your own account"
			redirect_to root_path
		end
	end

  CHECK IF CURRENT USER IS LOGGED IN AND IS NOT ADMIN, SHOW ERROR
  def require_admin
		if logged_in? and !current_user.admin?
			flash[:danger] = "Only admin users can perform that action"
			redirect_to root_path
		end
	end

end

2) Go to models/user.rb:

    class User < ActiveRecord::Base
      has_many :articles, dependent: :destroy => add "dependent: :destroy" => This destroys all articles associated with the user
      before_save { self.email = email.downcase }
      validates :username, presence:true,
                uniqueness: { case_sensitive:false },
                length: { minimum: 3, maximum: 25 }

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true,
                length: { maximum: 105 },
                uniqueness: { case_sensitive: false },
                format: { with: VALID_EMAIL_REGEX }
      has_secure_password
    end

3) Go to view/users/index.html.erb and create button to delete User:

   <h1 class="text-center"> All Bloggers </h1>

<% @users.each do |user| %>

  <ul class="listing">
    <div class="row">
      <div class="well col-md-4 col-md-offset-4">
        <li><%= link_to gravatar_for(user), user_path(user) %></li>
        <li class="article-title"> <%= link_to user.username, user_path(user) %></li>
        <li><small><%= pluralize(user.articles.count, "article") if user.articles %> </small></li>
        #If user is logged and user is admin, show this button
        <% if logged_in? and current_user.admin? %>
          <li> <%= link_to "Delete this user", user_path(user), method: :delete,
               data: { confirm: "Are you sure you want to delete user and all their articles?"} %> </li>
        <% end %>
      </div>
    </div>
  </ul>

<% end %>

4) Set admin from heroku

  Type: heroku run rails console
  Type: User.all => shows all users
  Type: user = User.find(1) => Find user with ID "1"
  Type: user.admin? => Checks if admin. true or false.
  Type: user.toggle!(:admin) => Sets admin to true
  
















