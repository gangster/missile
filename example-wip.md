Say the task at hand is implementing user registration.   The requirements are presently fairly simple.

- Display the registration form with e-mail, password and password confirmation fields
- E-mails must be unique
- Password and password confirmation values must match
- Send the user a welcome email

Doing this this typical Rails way, we usually end up with a Model and Controller that looks something like:

Model
```ruby
class User < ActiveRecord::Base

  validates :email, uniqueness: true
  validates :password, confirmation: true
  after_create :send_welcome_email

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
```

Controller
```ruby
class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      redirect_to edit_user_url(@user)
    else
      render :new
    end
  end

  def registration_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```

That was easy and at this point, the code is simple, readable and sure, not
very object-oriented or flexible, but so what?  According to the infinite wisdom
of the product roadmap, no new features around user registration are on the
horizon so...wait, what?  We need to add the ability to
