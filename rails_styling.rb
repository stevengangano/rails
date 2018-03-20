Styling

1) Go to app/views/layouts/application.html.erb 

  <%= yield %> => Displays all views

  At the top of body, type:

  <%= render 'layouts/navigation' %>    

2) Create file, views/layouts/_navigation.html.erb

  Copy and paste, bootstrap navbar code in this file => Navbar will display on every 
  page

3) To change color of navbar in scss, go custom.css.scss:

  $navbar-default-bg: black;

  @import "bootstrap-sprockets";
  @import "bootstrap";

  Regular css code goes here, for example:
  .jumbotron {
    color: black;
   }

4) Writing link in embedded ruby code in _navigation.html.erb:

  For example:

  <%= link_to "Alpha blog", root_path, class: "navbar-brand", id: "logo" %>
     
  <li> <%= link_to "Articles", articles_path %> </li>

5) Style home.html.erb:

  <div class="text-center jumbotron">

    <h1>Alpha Blog</h1>
    <p> <%= link_to 'Sign up now', '#', class: "btn btn-primary btn-xlarge", style: 'padding:25px;' %> </p>
    <p><%= link_to 'Blog', articles_path, class: "btn btn-success btn-xlarge" %></p>  

  </div> 
    
6) Style new.html.erb & edit.html.erb with bootstrap in views/articles/_form.html.erb:

   1) Go to bootstrap and look up horizontal forms (under CSS tab)

      Note: Look at bootstrap sample and include embedded ruby in the _form.html.rb file
     
    For:

    <%= form_for(@article, :html => {class: "form-horizontal", role: "form"}) do |f| %> => Make sure there are no spaces after "form_for"
      
7) Styling the "errors" from _form.html.erb using bootstrap:

        #If there are any errors adding "@article"
        <% if@article.errors.any? %>
        <div class="row">
            <div class="col-xs-8 col-xs-offset-2">
               <div class="panel panel-danger">
                   <div class="panel-heading">
                      <h2 class="panel-title">
                        <%= pluralize(@articles.errors.count, "error") %> => If there are multiple errors it will be plural
                        prohbited this article from being saved:
                     </h2>
                     <div class="panel-body">
                       <ul>
                          <% @article.errors.full_messages.each do |msg| %>
                          <li><%= msg %></li>
                          <% end %>
                       </ul>
                     </div>
                   </div>
                </div> 
              </div>       
          </div> 
        <% end %>

8) Create an errors partial by creating a folder/file shared/_errors.html.erb and copy paste the above

9) Go back to _form.html.erb and at the top of page type:

      <%= render 'shared/errors', obj: @article %> => obj = @article in _errors.html.erb => @article from "def create and edit"
        
      <%= form_for(@article, :html => {class: "form-horizontal", role: "form"}) do |f| %>
        <div class="form-group">
          <div class="control-label col-sm-2">
              <!--Displays "title" -->
              <%= f.label :title %> 
          </div>
          <div class="col-sm-8">
              <!--Displays input box, ":title" grabs from  -->
              <%= f.text_field :title, class: "form-control", placeholder: "Title of article", autofocus: true %>    
          </div>
       </div>
    
       <div class="form-group">
          <div class="control-label col-sm-2">
              <!--Displays "Description" -->
              <%= f.label :description %> 
         </div>
          <div class="col-sm-8">
              <!--Displays input box -->
              <%= f.text_area :description, rows: 10, class:"form-control", placeholder: "Body of article" %> 
         </div>
      </div>

      <div class="form-group">
        <div class="col-sm-10 col-xs-offset-2">
            <!--Creates a submit button -->
            <%= f.submit class:"btn btn-primary btn-lg" %> 
        </div>
      </div>
    
    <div class="col-xs-4 col-xs-offset-4 text-center">
      [ <%= link_to "All Articles", articles_path %> ]
   </div> 

        <% end %>

   </div>
</div>                        
  
           
10) Go to shared/_errors.html.erb. Change "@article" to "obj" so @article can be reused if injecting into another template
                     
        #If there are any errors adding an article
        <% if obj.errors.any? %>
        <div class="row">
            <div class="col-xs-8 col-xs-offset-2">
               <div class="panel panel-danger">
                   <div class="panel-heading">
                      <h2 class="panel-title">
                        <%= pluralize(obj.errors.count, "error") %> => If there are multiple errors it will be plural
                        prohbited this article from being saved:
                     </h2>
                     <div class="panel-body">
                       <ul>
                          <% obj.errors.full_messages.each do |msg| %>
                          <li><%= msg %></li>
                          <% end %>
                       </ul>
                     </div>
                   </div>
                </div> 
              </div>       
          </div> 
        <% end %>


11) Styling flash messages. layouts/_flashMessages.html.erb
                    

<div class="row">
  <div class="col-xs-10 col-xs-offset-1">

  <%= flash.each do |name, msg| %> =>
    <div class='alert alert-<%= "#{name}" %>'> => #{name} = error message key. can be ":success, :danger, etc." from articles_controller.rb
      <a href="#" class="close" data-dismiss="alert"> &#215; </a>  => button to close flash message 
      <%= content_tag :div, msg, :id => "flash_#{name}" if msg.is_a?(String) %> => This displays the message. 
                                                        content_tag :div = <div></div>. msg = error message value, :id => "flash_#{name}"
                                                        = ceated an id, for example: flash_success which can be used to style in CSS.
    </div>
    
    <% end %>
    
  </div>
</div>

For example, in articles_controller.rb:
      
  #Delete route (/articles/:id)
  def destroy
    #@article = Article.find(params[:id])
    @article.destroy
    flash[:danger] = "Article was successfully deleted" => :danger = "name" & "Article was successfully created" = "msg" in _flashMessages.html.erb
    redirect_to articles_path         
  end 
        
12) Styling the show page with bootstrap. Go to view/articles/show.html.erb
      
<h2 class="text-center"> Title: <%= @article.title %> </h2>


<div class="well col-xs-8 col-xs-offset-2">
  <h4 class="center description"> <strong>Description:</strong></h4>
  <hr>
  <%= simple_format(@article.description) %> => Turns text into HTML
    
  
  <div class ="article-actions">
    <%= link_to 'Edit', edit_article_path(@article), class: "btn btn-xs btn-primary" %> 
    <%= link_to 'Delete', article_path(@article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %> 
    <%= link_to 'All articles', articles_path, class: "btn btn-xs btn-success" %>  
  </div>
</div>

13) Styling the index page. Go to view/articles/index.html.erb:

<h1> Listing all article </h1>

<!-- Link to articles/new -->
<!-- new_article_path = new/article -->
<p>
  <%= link_to "Create new article", new_article_path %>  
</p>


<% @articles.each do |article| %> 
<div class="row">
 <div class="col-xs-8 col-xs-offset-2">
   <div class="well well-lg">
     
     <div class="article-title">
       <%= article.title %>
     </div>
     
     <div class="article-body">
      <%= truncate(article.description, length: 100) %> => takes description and only shows 100 max characters
     </div>
     
     <div class="article-actions">
      <%= link_to 'Edit', edit_article_path(article), class: "btn btn-xs btn-primary" %> 
      <%= link_to 'Delete', article_path(article), method: :delete, data: {confirm: "Are you sure?"}, class: "btn btn-xs btn-danger" %>   
      </div>
     
     </div>
   </div>
  </div>
</div>
<% end %>

  