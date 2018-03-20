Create a login form (/login)

1) Go to config/routes.rb

  #login form
  get 'login', to: 'sessions#new'
  
  #def create => login
  post 'login', to: 'sessions#create'
  
  #def destroy => logout
  delete 'logout', to: 'sessions#destroy'


2) Create sessions_controller.rb:

  class SessionsController < ApplicationController
    #shows login form
    def new 
      
    end

    #login
    def create

    end

    #logout
    def destroy

    end  
  end

3) Type: rake routes => to check if routes were added

4) Create views/sessions/new.html.erb ('/login')

5) Copy and paste users/_form.html.erb into new.html.erb:

   Note: 
   Change label and placeholders
   Remove extra password field
   Make the following changes for the first line:
   Before:
   <%= form_for(@user, :html => {class: "form-horizontal", role: "form"}) do |f| %>

   <%= form_for(:session, :html => {class: "form-horizontal", role: "form"}, url: login_path) do |f| %>
        <div class="form-group">
          <div class="control-label col-sm-2">
              <!--Displays "Email" -->
              <%= f.label :email %> 
          </div>
          <div class="col-sm-8">
              <%= f.email_field :email, class: "form-control", placeholder: "Enter Email", autofocus: true %>    
          </div>
       </div>

       <div class="form-group">
          <div class="control-label col-sm-2">
              <!--Displays "Password" -->
              <%= f.label :password %> 
         </div>
          <div class="col-sm-8">
              <!--Displays input box -->
              <%= f.password_field :password, class:"form-control", autocomplete: "off" %> 
         </div>
      </div>


      <div class="form-group">
        <div class="col-sm-10 col-xs-offset-2">
            <!--Creates a submit button -->
            <%= f.submit "Login", class:"btn btn-primary btn-lg" %> 
        </div>
      </div>

    <div class="col-xs-4 col-xs-offset-4 text-center">
      [ <%= link_to "All Articles", articles_path %> ]
   </div> 

   <% end %>


5) Debugging to find email and password: Go to sessions_controller.rb

   1)

   Type:

   def create
      debugger => add this
   end
    
   2) 

   Go to /login and enter an email address/password and then submit

  
  3) Go to server and look at debugger

    Type: params 
    Type: params[:session] => shows value for email and password
    Type: params[:session][:email] => shows value for email
    Type: params[:session][:password] => shows value for password


6) Build "def create" action from sessions_controller.rb (POST):
      
   def create
     user = User.find_by(email: params[:session][:email].downcase) => looks for user by email
     if user && user.authenticate(params[:session][:password]) => if user (if email was found) & users password matches
       session[:user_id] = user.id => this saves the users ID in the session, so you can only go to pages where you are logged in
       flash[:success] = "You have successfully logged in"
       redirect_to user_path(user) = "(user)" = :id
     else
       flash.now[:danger] = "There was something wrong with your login information" => use flash.now if you are NOT redireting to a new page
       render :new
     end
   end

7) Destroying a session. Go to "def destroy" action from sessions_controller.rb
      
   def destroy
    session[:user_id] = nil => This destroys the session so there is no user ID in the session
    flash[:success] = "You have logged out"
    redirect_to root_path
   end
      
8) Go to layouts/_navigation.html.erb and create a logout link:
      
   <li><%= link_to 'Logout', logout_path, method: :delete %></a></li>

Restrict Actions from UI
        
9) Go to application_controller.rb and create "helper methods" => These are not available to views by default but they are available to the other controllers
        
   helper_method :current_user, :logged_in? => These methods will be used in our views
        
   def current_user
     @current_user ||= User.find(session[:user_id]) if session[:user_id] => Return current user ID if they are already logged in IF NOT Return User ID if there is a user logged in. @current_user is to ensure it does not keep looking for User in the database.
   end
        
   def logged_in?
     !!current_user => Checks to see if a user is logged. will either return "true" or "false" is there is a current user logged in
   end
   
	 #Check to see if a user is logged in. Insert into articles_controller.rb. For example: Prevents user to go /articles/7/edit
   def require_user
     if !logged_in? => If not logged in
     flash[:danger] = "You must be logged in to perform that action"
     redirect_to root_path
     end
   end
       
10) Go to _navigation.html.erb and create login, logout, sign up paths:
     
      <ul class="nav navbar-nav navbar-right">
        
        <!--Link to articles path -->
        <li><%= link_to "Articles", articles_path %></li>
        
        <%if logged_in? %> => IF USER IS LOGGED IN
          <li><%= link_to 'Log out', logout_path, method: :delete %></a></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Actions <span class="caret"></span></a>
            <ul class="dropdown-menu">

              <li><%= link_to "New Articles", new_article_path %></li>
              <li><%= link_to "Edit your profile", edit_user_path(current_user) %> </li>
              <li><%= link_to "View your profile", user_path(current_user) %> </li>
							
            </ul>
          </li>
        <% else %> => IF USER IS NOT LOGGED IN
          <li><%= link_to 'Login', login_path %></a></li>
          <li><%= link_to 'Sign up', signup_path %></a></li>
        <% end %>

      </ul>

11) To prevent redundancy in users_controller.rb
    
    Type:
              
   	before_action :set_user, only: [:edit, :update, :show] => inserts "set_user" action into edit, update and show actions

    Type:
      
		private
   	def set_user
		  @user = User.find(params[:id])	
	  end          

    Delete: @user = User.find(params[:id]) from edit, update and show actions

12) Add edit your profile, view your profile links, Users
              
      <ul class="nav navbar-nav navbar-right">
        
        <!--Link to articles path -->
        <li><%= link_to "Articles", articles_path %></li>
        
        <%if logged_in? %> => IF USER IS LOGGED IN
          <li><%= link_to 'Log out', logout_path, method: :delete %></a></li>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Actions <span class="caret"></span></a>
            <ul class="dropdown-menu">

              <li> <%= link_to "Users", users_path %> </li> => Add this
              <li><%= link_to "New Article", new_article_path %></li> => Add this
              <li><%= link_to "Edit your profile", edit_user_path(current_user) %> </li> => Add this
              <li><%= link_to "View your profile", user_path(current_user) %> </li> => Add this
              
            </ul>
          </li>
        <% else %> => IF USER IS NOT LOGGED IN
          <li><%= link_to 'Login', login_path %></a></li>
          <li><%= link_to 'Sign up', signup_path %></a></li>
        <% end %>

      </ul>           

14) Go to pages_controller.rb:
							
	class PagesController < ApplicationController
		
  def home
		#if logged in go to /articles, do not enable to go "/"
    redirect_to articles_path if logged_in?
  end
  
  def about
  
  end

end
							
15) Go to articles/_article.html.erb:
						
		#if user is logged in and current user = article user, then enable edit, delete and show
		<% if logged_in? && current_user == article.user %>
     <div class="article-actions">
      <%= link_to 'Edit', edit_article_path(article), class: "btn btn-xs btn-primary" %> 
      <%= link_to 'Delete', article_path(article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %>   
      <%= link_to 'Show', article_path(article), class: "btn btn-xs btn-success" %>
     </div>
    <% end %>

16) Go to articles/show.html.erb:

  <div class ="article-actions">
	 #if user is logged in and current user = article user, then enable edit, delete and show
   <% if logged_in? && current_user == @article.user %>
    <%= link_to 'Edit', edit_article_path(@article), class: "btn btn-xs btn-primary" %> 
    <%= link_to 'Delete', article_path(@article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %>
   <% end %>
    <%= link_to 'All articles', articles_path, class: "btn btn-xs btn-success" %>  
  </div>
				
17) Go to articles/controller.rb:
						
	#includes 'require_user' method in the following routes
  before_action :require_user, except: [:index, :show] => User must be logged in for all the routes in this controller except index and show
		
18) Go to articles/controller.rb:
  	
		Type at the bottom:
						
		#This method only allows the owner to edit, update, and destroy
		def require_same_user
      if current_user != @article.user
      flash[:danger] = "You can only edit or delete your own articles"
      redirect_to root_path
      end
    end
		
		Type at the top:
						
		before_action :require_same_user, only: [:edit, :update, :destroy]
						

19) Do the same for users. Go users_controller.rb:
		
		Type at bottom:
	
		#If current user does not equal user, unable edit and update path and display "You can only edit your own account"
		def require_same_user	
			if current_user != @user	
				flash[:danger] = "You can only edit your own account"
				redirect_to root_path
			end
		end
	
		Type at top:
	
		before_action :require_same_user, only: [:edit, :update]
	
		
20) Go to articles_controller.rb:
				
	#Posts an article from (articles/new)
  def create
    #render plain: params[:article].inspect 
    @article = Article.new(article_params)
    @article.user = current_user => Change from 'User.first' to 'current_user'. This displays the current users info when an article is created.
    if @article.save 
        flash[:success] = "Article was successfully created" 
        redirect_to article_path(@article)
    else
      render :new 
    end
  end


21) Fixing signup to enable user is logged in after signing up:
	
	Go to users_controller.rb:
		
	 #POST /users
   def create
     @user = User.new(user_params) 
     if @user.save 
			session[:user_id] = @user.id => ADD THIS. This signs the user in. 
      flash[:success] = "Welcome to the alpha blog #{@user.username}" 
      redirect_to user_path(@user) => CHANGE THIS. Redirect to user/:id
     else
      render 'new' 
     end
   end