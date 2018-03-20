*****Blog******

Creating tables

1) Type: rails generate migration create_articles => This create migration file in db folder

2) Create what you want to insert into your table in the migration file.

  For example: t.string :title

3) Type: rake db: migrate

4) This creates a schema.rb file (db/schema.rb) => This will
   be added to the table

5) Create the other columns in a different migration file
   by creating a new migration file

   Type: generate migration add_description_to_articles


6) In the migration file add_description_to_articles:

  class AddDescriptionToArticles < ActiveRecord::Migration
  def change
    add_column :articles (table name), :description(attribute name), :text(type of attribute name)
    add_column :articles, :created_at, :datetime
    add_column :articles, :updated_at, :datetime
  end
end

7) Type: rake db:migrate => This updates the schema with
  title, descrition, created at, updated at

8) Create models/article.rb

  class Article < ActiveRecord::Base

  end

9) Type: rails console

10) Type: Article.all => Displays all articles in database. "Article" comes from the model.

11) To create a new article from console:

    Type: Article.create(title: "This is my first article", description: "My Third Article")
    Type: Article.all => displays all articles

12) Delete an article

    Type: article = Article.find(id)
    Type: article => check if you are on that article
    Type: article.destroy
    Type: Article.all => check if it was deleted

13) Edit the article

    Type: article = Article.find(id)
    Type: article => check if you are on the article
    Type: article.title = "This is an edited title" =>
    This edits the title
    Type: article => to see the update

14) A title and description must be added or you cant add
    to the database

  class Article < ActiveRecord::Base
    validates :title, presence: true, length: { minimum: 3, maximum: 50 }
    validates :description, presence: true, length: { minimum: 3, maximum: 50 }
  end
