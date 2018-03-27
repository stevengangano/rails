create scaffold or resource generator for Blog or Portfolio

To create sample data, go to db/seeds.rb, then type rake: db:setup
(erases old data replaces it with new data):

10.times do |blog|
  Blog.create!(
    title: "My blog post #{blog}",
    body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  )
end

10.times do |portfolio_item|
  Portfolioo.create!(
    title: "Portfolio title: #{portfolio_item}" ,
    subtitle: "My great service",
    body: "Lorem ipsum",
    main_image: "http://placehold.it/600x400",
    thumb_image: "http://placehold.it/350x200"
  )
end
