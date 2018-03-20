Devise and Bootstrap

Creating authentication with Devise

1) Add gem 'devise' => bundle install --without production

2) Type: rails generate devise:install => Installs devise

3) Type: rails generate devise User

  Created:

  db/migration/234l234j234l_devise_createusers.rb
  app/models/user.rb
  creates CRUD routes for user

4) Type:rails db:migrate => creates Users table into schema.rb

5) Go to controllers/application_controller.#!/usr/bin/env ruby -wKU

   Type:

   class ApplicationController < ActionController::Base
     protect_from_forgery with: :exception
     before_action :authenticate_user! => user must be logged into
   end

6) Create logout link in welcome/index.html.erb:

    Type: rake routes | grep user => shows routes for User

    <%= link_to "logout", destroy_user_session_path, method: :delete %>

7) Go to "users/sign_up"

   A login page is already created

8) Add gems:

  gem 'twitter-bootstrap-rails'
  gem 'jquery-rails' => Include if using rails 5

  Run bundle install --without production

9) Type: rails generate bootstrap:install static

10) Type: rails g bootstrap:layout application => this updates views/layouts/application.html.erb with bootstrap
   Type: Y

11) Add gem:

   gem 'devise-bootstrap-views' => bundle install --without production

12) Go to assets/stylesheets/application.css:

    *= require devise_bootstrap_views => Add this
    *= require_tree .
    *= require_self

13) Updates all views with bootstrap:

    Type: rails g devise:views:locale en
    Type: rails g devise:views:bootstrap_templates

    Note: Go to views/devise

14) Go to config/routes.rb:

    devise_for :users

15) If u get an apple error, go to views/layouts/application.html.erb:

    Remove lines 14-30

16) Remove sidebar links in views/layouts/application.html.erb

17) Remove(or code out) the following code for forgot your password link from the _links.html.erb partial under the app/views/devise/shared folder:

<%- if devise_mapping.recoverable? && controller_name != 'passwords' %>

<%= link_to t(".forgot_your_password", :default => "Forgot your password?"), new_password_path(resource_name)

%><br />

<% end -%

Working on the stock model:

1) Short cut to generating model

   Type:

   rails g model Stock ticker:string name:string last_price:decimal

   Note: This creates a migration file/schema.rb table for the 3 columns:

   ticker, name, and last_price

2) Type: rails db:migrate

3) Add Gem:

  gem 'stock_quote'

4) Looking up a stock, go to rails console and '

  Type: Stockquote::Stock.quote('GOOG')

  Type: Stockquote::Stock.quote('GOOG').previous_close

  Type: Stockquote::Stock.quote('GOOG').open

5) Go to routes.rb.

   Type:

   get 'my_portfolio', to: "users#my_portfolio"


6) Build form to search for stocks in views/users/my_portfolio.html.therubyracer

  <div id="stock-lookup">
   <%= form_tag "#", method: :get, id: "stock-lookup-form" do %>
     <div class="form-group row no-padding text-center col-md-12">
       <div class="col-md-10">
         <%= text_field_tag :stock, params[:stock], placeholder: "Stock ticker symbol", autofocus: true,
         class: "form-control search-box input-lg" %>
       </div>
       <div class="col-md-2">
          <%= button_tag(type: :submit, class: "btn btn-lg btn-success") do %>
            Look up a stock
          <% end %>
       </div>
     </div>
   <% end %>
  </div>

  Note: params[:stock] => grabs the value of whatever is typed into the form

7) When the stock form is submitted we need a:

    -Route (after the form has been submitted) => Controller (stocks_controller.rb) => action "search_stocks"

8) Go to config/routes/rb and create route for search stocks:

   get 'search_stocks', to: 'stocks#search'


9) Create controllers/stocks_controller.rb:

    class StocksController < ApplicationController

      def search

      end

    end

10) Go back to form and enter the route for from to POST to:

    Note:

    Type: rails routes => Looks for the paths
    Type: "search_stocks" in the form

    <div id="stock-lookup">
     <%= form_tag "search_stocks", method: :get, id: "stock-lookup-form" do %>
       <div class="form-group row no-padding text-center col-md-12">
         <div class="col-md-10">
           <%= text_field_tag :stock, params[:stock], placeholder: "Stock ticker symbol", autofocus: true,
           class: "form-control search-box input-lg" %>
         </div>
         <div class="col-md-2">
            <%= button_tag(type: :submit, class: "btn btn-lg btn-success") do %>
              Look up a stock
            <% end %>
         </div>
       </div>
     <% end %>
    </div>

11) Create view:

    Create folder: views/stocks
    Create file: views/stocks/search.html.erb

12) Go to models/stock.rb:

class Stock < ActiveRecord::Base

  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    new(name: looked_up_stock.name, ticker: looked_up_stock.symbol, last_price: looked_up_stock.l) => Creates a new object and sends it back to whoever is calling it
  end
end

Note: ticker_symbol = For example: "GOOG"
Note: In rails console:

StockQuote::Stock.quote("GOOG").symbol = Gives the symbol ("GOOG")
StockQuote::Stock.quote("GOOG").name = Gives the name ("Alphabet Inc")
StockQuote::Stock.quote("GOOG").l = "1,035.96"


13) Got stocks_controller.rb:

    class StocksController < ApplicationController

      def search
        Stock.new_from_lookup(params[:stock])
        render json: @stock
      end

    end

"Stock" references the class from models/stock.rb
"new_from_lookup" references from the method defined in models/stock.#!/usr/bin/env ruby -wKU
"params[:stock]" grabs whatever is typed into the search form
