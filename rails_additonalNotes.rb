EXTRA NOTES:

Routing

routes.rb:

get 'query/:else/:another_one', to 'pages#something'

controller.rb:

#needs to be match routes
def something
  @else = params[:else]
  @another = params[:another_one]
end

views/something.html.erb:

<h1> <%= @else %> <h1>
<h1> <%= @another %> <h1>

Type in web brower: /query/test1/test2

Displays on screen: test1, test2


Additional Note:

jquery = default for js

Creating controller pages with generator:

Type: rails g controller Pages home about contact
