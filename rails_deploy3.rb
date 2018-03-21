Deploying to heroku

1)  Go "Gemfile"
2)  Cut "sqlite3" from the top => b/c heroku does not support sqlite. It uses postgres
3)  Paste under:
    group :development, :test do
    gem 'sqlite3'
4)  At the very bottom, type:

    group :production do
      gem 'pg' => postgres
      gem 'rails_12factor'
    end
5) In the terminal type:

   bundle install --without production => Does not install 'pg' and 'rails_12factor' in local environment,
                                          but it will update Gemfile.lock file for heroku to use.



6) Install codeanywhere heroku toolbelt:

   wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

7) Type: heroku login

   stevengangano@yahoo.com/********88

8) Type: heroku create

   This creates an application. For example:

   https://boiling-island-86514.herokuapp.com/

9) Commit changes to git
  git init
  git add .
  git commit -m "Deploy the app"
  heroku keys:add => Type: Y

10) If you did not create a SSH key, you can generate
    in the terminal:

    Type: ssh-keygen -t rsa

11) Checking for heroku keys

    Type: heroku keys => Displays "found" keys

12) Removing keys

    Type:

    heroku keys:remove adam@workstation.local

13) git remote add origin "heroku link here"
14) Git push heroku master, heroku run db:migrate
