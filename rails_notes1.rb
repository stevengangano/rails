#Starting Server

rails s --binding=0.0.0.0
https://Ruby-on-Rails-stevengangano376808.codeanyapp.com

#Gems => These are like dependencies

Go to rubygems.org

For example if you want to install bootstrap:

Type: gem 'bootstrap-sass', '~> 3.3.5'
Type: gem 'sass-rails', '>= 3.2'

#ROR documentation
rubyonrails.org/documentation


MVC Model

User sends request => ruby router => controller
(ex: ctrlr.rb) => goes to: 

1) (View) home.html 

or 

2) page.rb => database => page.rb => 
ctrlr.rb => View (home.html)



test_app => app => images, javascript, stylesheets
test_app > app > helpers: extracts common logic for view
test_app > models: models are store here
test_app > views > layouts > index.html

config > database.yml
config > routes.rb

environments > development.rb
environments > production.rb
environments > test.rb

logs: displays logs from server output

test > for automated tests

Gemfile : shows all gems installed

ReadME.rdoc > shows in repository. Can put info there.
    
  


General flow of Rails application:

-> Request made at browser

-> Request received at router of rails application

-> Request routed to appropriate controller

-> Controller either renders a view template or communicates with model

-> Model communicates with database

-> Model sends back information to controller

-> Controller renders view
  
  
  
Installing Rails
  
Checking rvm version: rvm -v
Checking rails version: rails -v
Checking ruby version: ruby -v
Rubies versions installed: rvm list
To change ruby version, use: rvm use ruby-2.3.4
Installing ruby: rvm install ruby-2.3.4
Installing rails: gem install rails -v 4.2.5 --no-ri --no-rdoc
  
#Starting Server

rails s --binding=0.0.0.0
  
  
  
  
  
  
  