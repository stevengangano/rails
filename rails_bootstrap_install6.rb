Wiring framing tools(design tool):

Go to balsamiq.com => 30 day trial


1) Installing bootstrap
  
  Copy:

  gem 'bootstrap', '~> 4.0.0' => Bootstrap 4

  or 

  gem 'bootstrap-sass', '~> 3.3.5'

2) Paste into Gemfile, like so:

   # Use SCSS for stylesheets
   gem 'bootstrap-sass', '~> 3.3.5'
   gem 'sass-rails', '~> 5.0'

   Then cmnd + s to save

3) If server is running, shutdown.

4) In terminal, type:

   bundle install --without production

5) Create scss stylesheets. Add app/assets/stylesheets/custom.css.scss

   Type:

   @import "bootstrap-sprockets";
   @import "bootstrap";

6) Go to app/assets/javascripts/application.js

   Type:

    //= require jquery
    //= require jquery_ujs
    //= require bootstrap-sprockets => Add this here
    //= require turbolinks
    //= require_tree .


  
  
  

  

  
  


