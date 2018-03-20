CRUD

1) Create
2) Read
3) Update
4) Delete

This creates the article model automatically, type:

rails generate scaffold Article title:string description:text

Creates the following files:

db/migrate/20180307213950_create_articles.rb => creates the table

app/models/article.rb => creates a models

app/controllers/articles_controller.rb => creates a controller

app/views/article/index.html.erb => Creates CRUD route views
app/views/article/show.html.erb
app/views/article/edit.html.erb
app/views/article/new.html.erb

To run migration file, type:

Type: rake db:migrate => for Rails 4 or lower
      rails db:migrate => for rails 5

This creates:

(test_app/db/migrate/2397234_create_articles.rb)


(test_app/db/schema.rb) => shows table with title, description


(test_app/db/development.sqlite3) => sql lite database for the application


(test_app/db/models/articles.rb) => gives app ability to talk to the database

(test_app/routes.rb) => creates "resources :articles". This adds routes
to our app. If you go to "/articles".

Type "rake routes | grep articles". This will pull up all the articles
routes. Prefix is the path: Ex: new_article_path. This path were created
in articles_controller.rb

       Prefix Verb   URI Pattern                  Controller#Action
     articles GET    /articles(.:format)          articles#index
              POST   /articles(.:format)          articles#create
  new_article GET    /articles/new(.:format)      articles#new
 edit_article GET    /articles/:id/edit(.:format) articles#edit
      article GET    /articles/:id(.:format)      articles#show
              PATCH  /articles/:id(.:format)      articles#update
              PUT    /articles/:id(.:format)      articles#update
              DELETE /articles/:id(.:format)      articles#destroy
 welcome_home GET    /welcome/home(.:format)      welcome#home
welcome_about GET    /welcome/about(.:format)     welcome#about


Go to schema.rb to see if body and title were added => never edit this file
Delete scaffolds.scss => premade styling for scaffold
