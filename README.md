# Missile

## Getting Started
In your Gemfile...

```ruby
gem 'missile', '~> 0.1.0'
```

## What is a Missile?

A Missile is a single purpose object for encapsulating domain logic in your Ruby applications.  It represents a *single* concept/behavior in your domain.   It is a Command/Interactor hybrid with friendly and flexible APIs.   It succeeds in simplifying both model and controller code while eliminating callbacks in the former, and conditionals in the latter.  It is a service object replacement.

## Examples

Model
```ruby
class User < ActiveRecord::Base
  # I'm just a dumb data object.
end
```

Entity (Wepo)
```ruby
class UserEntity < Wepo::Entity
  property :email
  property :password
  property :confirmation_code
  property :confirmed
end
```
Controller
```ruby
class RegistrationsController < ApplicationController
  def new
    User::BeginRegistration.new
      .on(:success, &method(:render_form))
      .run
  end

  def create
    Users::Create.new(params)
      .on(:success, &method(:send_welcome_email))
      .on(:failure, &method(:rerender))
      .run
  end

  private

  def render_form(form)
    @form = form
  end

  def send_welcome_email(user)
    Users::SendWelcomeEmail.new(user: user)
      .on(:success, &method(:redirect_to_user))
      .on(:failure, &method(:report_and_redirect))
  end

  def redirect_to_user(user)
    redirect_to user_url(user)
  end

  def report_and_redirect(user)
    # Notify bugsnag, entry, etc.
    redirect_to_user(user)
  end

  def rerender(form, errors)
    @form = form
    @errors = errors
    render :new
  end
end
```

Create user
```ruby
module Users
  class Create < Missile::Command
    include Missile::Validateable
    include Missile::Persistable::Wepo

    attr_reader :user

    contract do
      property :email
      property :password
      property :password_confirmation

      validates :email, uniqueness: true
      validates :password, presence: true, confirmation: true      
    end

    repo do
      model User
      entity UserEntity
      adapter Wepo::Adapters::ActiveRecord
    end

    def run
      validate(params, UserEntity) do |user|
        user.confirmation_code = SecureRandom.hex
        save entity
        @user = entity
        success! @user
      end
      self
    end
  end
end
```

Welcome e-mail command
```ruby
module Users
  class SendWelcomeEmail < Missile::Command
    def run
      UserMailer.welcome_email(user).deliver_later
      success!
    end
  end
end
```

Confirm User command
```ruby
module Users
  class Confirm < Missile::Command
    include Missile::Persistable::Wepo

    attr_reader :user
    def run
      user = find_by(confirmation_code: params[:confirmation_code])
      if user
        user.confirmed = true
        save user
        success!(user)
      else
        fail!
      self
    end
  end
end
```
