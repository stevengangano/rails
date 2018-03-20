*****Test App******

Checking if the route exists:

rake routes

Creating a route:

Go to app/config/routes.rb

welcome# = controller, home = 'def home' in the controller

root 'welcome#home'
get 'welcome/about', to: 'welcome#about'


Creating a controller:

Go to app/controllers/welcome_controller.rb

class WelcomeController < ApplicationController
  
  def home
    
  end
  
  def about
  
  end

end


Go to views:

Create a welcome folder (views/welcome). Since there is a 
welcome_controller.rb, it will look for the welcome folder in views.
    
Inside welcome folder, create a file called home.html.erb. (welcome/home.
html.erb)
  
Inside this html.erb file, you can write HTML5.
    
  
Writing Ruby in a .html.erb:
  
<% %> = Ruby syntax

<%= %> = Displays onto the screen

****Blog******
  
Creating a new rails app:
  
rails _4.2.5_ new blog
  
or
  
rails new blog
  
Creating images/links:
  
#LINKS  
<%= link_to 'Link to the about page', pages_about_path %>

pages_about_path = pages/about

#Images
<%= image_tag 'fb.jpg' %>

#Images with link
<%= link_to image_tag('fb.jpg'), 'www.stebz.com' %>




