---
layout: post
title: SessionsController refactoring
description: How improve your code?
headline: My code is getting worse, please send more chocolate
categories: [refactoring, ruby, ruby on rails]
tags: [refactoring, ruby, ruby on rails]
comments: true
---

A few weeks ago I worked on code like this:

```ruby
class SessionsController < ApplicationController
  respond_to :json, only: [:create]

  def create
    @user = User.find_by(email: user_params[:email])
    if @user && @user.authenticate(user_params[:password])
      @user.token = Session.create(user: @user).token
    end
    respond_to { |format| format.json { render_user } }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def render_user
    if @user
      render json: @user, status: :created
    else
      render json: { errors: 'Email or password was invalid' }, status: :unprocessable_entity
    end
  end
end
```

When you look on this code at first time, you probably think that this is not too bad. Class isn’t to long. It have about 25 lines. Methods are short. Maybe 5 – 6 lines. Is only one public method. Everything looks OK, so what do we do here?

In this code is bug. When user want to login and send correct email but wrong password, method returns status `:created`. This mean that user is correctly login. But this is not true, because `Session` for user wasn’t created.

So, how we can deal with this bug? First we create a test, which show us this bug.

```ruby
require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:password) { rand_text(5) }
    let(:user) { create(:user, password: password) }

    it 'for wrong password return status :unprocessable_entity' do
      post :create, user: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    ...
  end
end
```

Test failed. Now we can closely look to this code.

```ruby
respond_to { |format| format.json { render_user } }
```

Something strange happened in this line. We call method `respond_t`o and in this method we call `render`. On first look we don’t see this because `render` is hidden in `render_user` method. So, I decide to remove this method and move `render` to `create` method in our controller. For now I create method `user` where I set correctly user.

```ruby
class SessionsController < ApplicationController
  respond_to :json, only: [:create]

  def create
    if user
      render json: @user, status: :created
    else
      render json: { errors: 'Email or password was invalid' }, status: :unprocessable_entity
    end
  end

  private

  def authenticated?
    @user && @user.authenticate(user_params[:password])
  end

  def user
    @user = User.find_by(email: user_params[:email])
    return nil unless authenticated?
    @user.token = Session.create(user: @user).token
    @user
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
```

Now bug is fixed. Test passed. Everything is OK, right? We can stop at this point and go to another challenge.

Let’s think. When we leave code at this moment, what can happen?

1. Code is great and no one come back here (It is small chance for this).
2. Code is not so good and someone will back here to do refactoring.

Why we cannot do this refactoring? We can try leave this code better then we found.

```ruby
class SessionsController < ApplicationController
  before_action :set_user, only: [:create]

  def create
    if @user && @user.authenticate(user_params[:password])
      render_user_with_token
    else
      render json: { errors: t('errors.invalid') }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(email: user_params[:email])
  end

  def render_user_with_token
    @user.token = Session.create(user: @user).token
    render json: @user, status: :created
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
```

Tests are still passing. I think this code is better than before but it is not perfect. We can think why we let `@user` to be `nil` (when we use `find_by` method)? I leave here `find_by` not `find` or `find_by!` because this two methods give me exception which I don’t want. `ActiveRecord::RecordNotFound` exception give me status `:not_found` but I want `:unprocessable_entity` status.

Next we can think about

```ruby
@user && @user.authenticate(user_params[:password])
```

If you not seen I recommend to look on **Sandi Metz** presentation about **Null Object Pattern** ([RailsConf 2015 – Nothing is Something](https://www.youtube.com/watch?v=29MAL8pJImQ)). We can here create something like `TrustedUser` and use everywhere objects without checking `nil`. Then we can come back to simply `render` and set token in `create` method. Let’s we see how this can look.

```ruby
class SessionsController < ApplicationController
  before_action :set_user, only: [:create]

  def create
    if @user.authenticate(user_params[:password])
      @user.token = Session.create(user: self).token
      render json: @user, status: :created
    else
      render json: { errors: t('errors.invalid') }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = TrustedUser.find_by(email: user_params[:email])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

# app/models/trusted_user.rb
class TrustedUser
  def self.find_by(params)
    User.find_by(params) || MissingUser.new
  end
end

# app/models/missing_user.rb
class MissingUser
  def authenticate(password)
    false
  end
end
```

We can now think about moving token setting to model but I stop my refactoring here. You can do this if you want. But I think the hardest thing about this is question: Have this change value for me? Answer depends on you.

If you have any suggestion what can we change here. Please leave me a comment down below. I hope this was useful. Bye and see you next time.

