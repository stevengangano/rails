Associations: 

When an article is created by a user, the database saves the user's ID for that particular article.

******Test App******

1) Create User scaffold

   Type:

   rails generate scaffold User username:string email:string 

   Note: This creates a table file with user and email inside db/migrate.
   Also this creates model/user.rb, users_controllers.rb with CRUD routes. Scaffold creates CRUD routes.


2) Type: rake db:migrate => This creates a schema.rb file

3) Destroying scaffold: rails destroy scaffold User

4) Creating a user in the console:

  Type: rails console
  Type: User => Displays what key:values will be created for each User
  Type: user = User.create(username: "Jack", email: "Jack@example.com") => Creates username


1) Create Comment scaffold

  rails generate scaffold Comment description:text user:references

  Note: "user: references" stores a foreign_Key. foreign_key is the key created
  when a user creates a particular article.

2) Type: db:migrate => Updates the schema.rb file
  
3) Building the association between User and Comment

  Go to models/comment.rb:

  class Comment < ActiveRecord::Base
    belongs_to :user => This shows here because we created "user: references"
  end


  Go to model/user.rb and type:

  class User < ActiveRecord::Base
   has_many :comments => This allows associations between user and comment
  end

4) Creating a comment in the console:

   Type: user = User.first => This grabs the user created 
   Type: user.comments => This shows comments created by the user
   Type: comment = Comment.new(description: "This is a new comment", User: user)

   Note: "user" in User: user" adds the user id for that comment

   Type: comment.save => This saves the comment to the database
   Type: user = User.first => This reloads the user 
   Type: user.comments => Displays the newly created comment

*****Blog App*****

1) Go back to blog app. Leave master branch and create a new branch.
  
   Type: git checkout -b create-users => Creates a branch called "create-users". This creates a copy of the master branch.
   Type: git branch => Displays all branches available to me
   Type: git checkout create-users => Switches to "create-users" branch
   Type: rails generate migration create_users => Creates a table in db/migrate

   Go to Create_Users migration file and type:

    class CreateUsers < ActiveRecord::Migration
    def change
      create_table :users do |t|
        t.string :username => Creates username
        t.string :email => Creates email
        t.timestamps => Creates time 
      end
    end
  end

  Type: rake db: migrate => updates the schema.rb file

2) Create models/user.rb file

   Type:

   class User < ActiveRecord::Base
   end

3) Go to rails console and check if User database was created:

   Type: User.all => Check to see if User database was created
   Type: User => displays table created for each user created
   
4) Creating a user from the console:

   Type: user = User.create(username: "Stebs", email: "stebs@example.com")
  
5) Updating the email:

   Type: Users.all => Displays all users  
   Type: user = User.find(1) => This grabs the user with an ID of 1
   Type: user => Displays which user you are working on
   Type: user.email = "steboogie@gmail.com" 
   Type: user.save => Saves new email to database

6) Destroying the user:

   Type: user = User.find(1)
   Type: user.destroy
   Type: User.all => check if user was deleted

7) Pushing create-user branch to github and merging with master:

   Type: git add .
   Type: git commit -m "create user migration file and user model file"
   Type: git checkout master => migration file and model file are not there
   Type: git merge create-users => migrations file and model file are now on master branch

8) Since create-users branch is now merged with master, we can delete create-users brnach

   Type: git branch => shows available branches
   Type: git branch -d create-users => "-d" will work because we merge create-users with master. If not we would need to use "-D"

9) Push changes to github

   Type: git push

  
1) Creating user validations => models/user.rb

  Type: git checkout -b user-validations => creates a new branch
  
2) Go to models/user.rb

   Go to guides.rubyonrails.org/active_record_validations.html => shows list of validation helpers on right side
  
   Type:

   class User < ActiveRecord::Base
    validates :username, presence: true, uniqueness: { case_sensitive: false },  length: { minimum: 3, maximum: 25 } => presence ensures name is present. "case_sensitive: false" ensures same username such "Stebs" and "stebs" cannot be added
   end


   Type: rails console  
   Type: reload!
    
3) Create a user through console:

   Type: user = User.new(username: "steven", email: "steven@yahoo.com")
   Type: user.save

4) Checking for error messages and correcting, for example:

   Type: user2 = User.new(username: "s", email: "steven@yahoo.com")
   Type: user2.save => Will not allow b/c it "username" is less than 3 characters
   Type: user2.errors.full_messages => shows error messages
   Type: user2 => shows user you are working on
   Type: user2.username = "stebooogie"
   Type: user2.valid? => checks with model/user.rb if valid
   Type: user2.save
   Type. User.all

5) Creating email validations. Go views/user.rb
    
   class User < ActiveRecord::Base
    validates :username, presence: true, 
              uniqueness: { case_sensitive: false },  
              length: { minimum: 3, maximum: 25 } 

    NOTE: presence ensures name is present. "case_sensitive: false" ensures same username such "Stebs" and "stebs" cannot be added
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, 
              length: { maximum: 105 },
              uniqueness: { case_sensitive: false },
              format: { with: VALID_EMAIL_REGEX } => checks if email valid
  end


   Type: user3 = User.new(username: "Steboogie", email: "steven@.com")
   Type: user3.save => Will not allow b/c email is invalid
   Type: user3.errors.full_messages => shows error messages
   Type: user3 => shows user you are working on
   Type: user3.email = "stebooogie@yahoo.com"
   Type: user3.valid? => checks with model/user.rb if valid. If true, user3.save.
   Type: user3.save
   Type. User.all

6) Merge user-validations branch with master branch

   Type: git add .
   Type: git commit -m ""
   Type: git checkout master => Added validations to models/user.rb are now gone
   Type: git merge user-validations => Check if it was merged
   Type: git push
   Type: git branch -d user-validations => Deletes branch
   Type: git branch => checks if branch was deleted



1) Creating associations between users and articles

  Type: git checkout -b userarticle-associations => creates a new branch

2) Create a migration file
  
  Type: rails generate migration add_user_id_to_articles => Creates a table in migrate/db
  

3) Go to newly created migration file:

  class AddUserIdToArticles < ActiveRecord::Migration
    def change
      add_column :articles(table name), :user_id (1st column), :integer(type) => Note needs to be integer for foreign key
    end
  end

Note: This adds :user_id to the articles table. See schema.rb.


4) Type rake db:migrate => creates the column user_id. Look at "articles" table in schema.rb

5) Go to rails console

   Type: Article.all => check to see if "user_id" was added to articles


6) Go to models/user.rb. Create association with articles. Make sure email is lowercase when user enters it.
    
  class User < ActiveRecord::Base

  has_many :articles => Add this. Creates association with articles table in schema.rb. (plural b/c "class User" is the one side of the one too many association)
  before_save { self.email = email.downcase } => Add this. Before email is sent to database, it will make sure it is lowercase
  
  validates :username, presence:true, 
            uniqueness: { case_sensitive:false }, 
            length: { minimum: 3, maximum: 25 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
            length: { maximum: 105 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  end

7) Go to models/article.rb

  class Article < ActiveRecord::Base

    belongs_to :user => Add this. Creates association with user. (singluar b/c "class Article" is the many side of the one to many association)
    
    validates :title, presence: true, length: { minimum: 3, maximum: 50 }
    validates :description, presence: true, length: { minimum: 3, maximum: 50 }

  end

8) Add user_id validation to models/article.rb


    class Article < ActiveRecord::Base

    belongs_to :user 
    
    validates :title, presence: true, length: { minimum: 3, maximum: 50 }
    validates :description, presence: true, length: { minimum: 3, maximum: 50 }
    validates :user_id, presence: true => Ensures anytime an article is being created, there is an article present

  end


9) Create new article in console:

   Type: article = Article.new(title: "This is some article", description: "New article")
   Type: article.save
   Type: article.errors.full_messages => shows error messages

10) Create new article with user id in console:

    Type: article = Article.new(title: "This is some article", description: "New article" user: User.first or user_id: 2)
    Type: article.valid?
    Type: article.save  
    Type: Article.all => shows newly created with user ID

11) Check to see if an article can be created from the UI

    A validation error will show up b/c there must be a user associated with creating
    an article.


12) Go to an article with a user_id and then go to rails console:

    Type:

    article.user => Display User ID, username, email, created at, updated at

    Note: This is possible because of the association we created between 
    models/article.rb and models/user.rb.

13) Finding the articles a user has posted:

    Type: user = User.find(2)
    Type: user => Displays user
    Type: user.articles => List the articles the user has posted (user.articles b/c one to many association)
    
14)  Adding an article from UI. Go to articles_controller.rb and go to create action

    #Posts an article from (articles/new)

    def create
    @article = Article.new(article_params)

    @article.user = User.first => This adds a user when an article is created
    
    if @article.save 
        flash[:success] = "Article was successfully created" 
        redirect_to article_path(@article)
    else
      render :new 
    end
  end

15) Create a new article from the UI

16) Check database to see if article was added

    Type: Article.last => shows article id, title, description, etc of the last article created
    
17) Debugging

    -Remove from def create: @article.user = User.first 
    -Go to Gemfile: Look for "gem byebug'
    -Go to def create:
      
     def create
      debugger => Add this
      @article = Article.new(article_params)

      if @article.save 
          flash[:success] = "Article was successfully created" 
          redirect_to article_path(@article)
      else
        render :new 
      end
    end

18) Go to server terminal:

    -Shows where code stop executing
    -Type: article_params => Shows the title and description that tried to get passed through
    -Type: ctrl + d => exit out of debugger

19) Debugging part 2

    -Now add back: def create: @article.user = User.first
    -Do not remove debugger
    -Enter a new article from the UI
    -Type: article_params
    -Type: n => Skips to: @article.user = User.first
    -Type: n => Skips to: if @article.save. Go back to UI and now the code is executed so article is now added to database.
    -Type: @article.user => grabs the User
    -Type: @article.user.username => grabs username. For example: "Steven"
      
20) Debugging part 3. Got application.html.erb and type:

    <!-- Displays controller, action, and user_id of user who posted it   -->
    <%= debug(params) if Rails.env.development? %>  


1) Showing User Info in Articles (index.html.erb)

    Under article description, type:

    <div class="article-meta-details"> => Style in custom.css.scss  
      <small>
         Created by: <%= article.user.username if article.user %> => show the articles username if there is a user
         <%= time_ago_in_words(article.created_at) %> ago,
         Last updated: <%= time_ago_in_words(article.updated_at) %> ago
         </small>
    </div>
  
    Note: time_ago_in_words() is a ruby method to format time
   
      
      
      





  


   



