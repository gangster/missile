# Missile

## Getting Started
In your Gemfile...

```ruby
gem 'missile', '~> 0.1.0'
```

## What is a Missile?

A Missile is a single purpose object for giving you a sane, object-oriented place to put domain logic in your Ruby applications.  It represents a *single* concept/behavior in your domain.   It is a Command/Interactor hybrid with friendly and flexible APIs.   It succeeds in simplifying both models and controllers by eliminating callbacks in the former, and conditionals in the latter.

## The Problem

#### tl;dr:  Rails is not object-oriented and MVC is not enough as applications grow

Rails and frameworks promote Model-View-Controller as an architectural design pattern for web applications.   MVC is great, because it
distinguishes our application into three easily understandable layers.  Models are data, Views are what users see, and Controllers sit in between and process requests, fetches/changes data, and then renders a view.   It's simple, it works, and easy enough to explain to newbies who are just getting started.   

Rails takes this MVC concept and doubles down on it.  It promotes the idea that all code should go in one of these 3 layers and goes out of its way to make it easy for developers to structure their programs in this way.  As such, most Rails applications are indeed structured this way.   So what's the problem with that?

According to Wikipedia, MVC it is [an architectural pattern for implementing *user interfaces*](https://en.wikipedia.org/wiki/Model–view–controller).   Let's break that down.   First, it's an architectural pattern.   By definition, architectural patterns are high-level, broad in scope and are merely a mental framework for thinking and communicating about a problem.   They have very little to say about application design, and nothing at all to say about the implementation details.  If I were to abuse a building construction metaphor, I'd say that architectural patterns are not blueprints, or even close.  They are simply having the shared idea that buildings should in most cases have a foundation, floor, walls, 

Our applications are more than user interfaces.  Our applications are a combination of user interfaces, domain logic, and data.  

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
