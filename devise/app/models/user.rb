class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #name must always be entered on the form
  validates_presence_of :name

  def first_name
    #Takes the first and last name, splits the them, and then grabs 1st element
    #in the array.
    #For example:
    #Go to rails conole => type User.all => User.last => user = User.last =>
    # => user.first_name => "John"
    self.name.split.first
  end

  def last_name
    self.name.split.last
  end

end
