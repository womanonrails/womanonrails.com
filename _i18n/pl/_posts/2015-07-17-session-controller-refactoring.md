---
layout: post
title: Refaktoryzacja w SessionsController
description: Jak można poprawić swój kod?
headline: My code is getting worse, please send more chocolate
categories: [refactoring, Ruby, Ruby on Rails]
tags: [refactoring, Ruby, Ruby on Rails]
comments: true
---

Kilka tygodni temu pracowałam z następującym kodem:

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

Kiedy patrzy się na ten kod pierwszy raz prawdopodobnie myśli się że jest OK. Klasa nie jest za długa. Ma tylko 25 linii. Metody są krótkie. Około 5 – 6 linii. Jest tylko jedna publiczna metoda. Wszystko wygląda dobrze, prawda?

Okazuje się jednak, że kod ten ma błąd. Gdy użytkownik chce się zalogować i poda poprawny email ale błędne hasło, metoda zwróci status `:created`. Oznacza to, że użytkownik poprawnie się zalogował, co nie jest prawdą. Sesja nie nie została dla niego utworzona.

Jak poradzimy sobie z tym błędem? Wpierw napiszemy test, który wykryje nasz błąd.

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

Test nie przechodzi. Możemy zacząć działać. Przyjrzyjmy się bliżej naszej klasie.

```ruby
respond_to { |format| format.json { render_user } }
```

Coś dziwnego dzieje się w tym kodzie. Wywołujemy metodę `respond_to`, w której wywołujemy `render`. Nie widać tego na pierwszy rzut oka ponieważ `render` ukryty jest w metodzie `render_user`.

Postanowiłam, że usunę tą metodę i przeniosę `render` do metody `create` w naszym kontrolerze. Dodatkowo stworzyłam tymczasowo metodę `user` by poprawnie był ustawiany użytkownik.

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

Błąd naprawiony. Test przychodzi. Wszystko jest dobrze. Możemy ruszać dalej po nowe wyzwania, prawda?

Pomyślmy przez chwilę czy możemy możemy zostawić ten kod w tej postaci? Co się dalej stanie?

1. Nasz kod jest tak dobry, że nikt nie będzie musiał do niego wracać (mało prawdopodobne).
2. Nasz kod nie jest tak dobry jak myślimy i prędzej czy później ktoś będzie musiał tu coś zmienić lub naprawić.

Dlaczego my nie możemy poprawić tego kodu już teraz? Dlaczego nie zastosować się do zasady zostaw fragment kodu który modyfikujesz lepszym niż go zastałeś.

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

Testy dalej przechodzą. Myślę, że ten kod jest lepszy niż poprzednia wersja ale są rzeczy, które da się jeszcze poprawić. Możemy się zastanowić na przykład nad zmienną `@user`. Raz jest ona obiektem typu `User` a raz `nil` (wynika to z używania metody `find_by`). Nie używamy tutaj ani `find` ani `find_by!` ponieważ status naszej odpowiedzi byłby inny niż oczekujemy. Wyjątek `ActiveRecord::RecordNotFound` zwróci nam status `:not_found` a my chcielibśmy `:unprocessable_entity`.

Natępnie możemy zastanowić się nad warunkiem:

```ruby
@user && @user.authenticate(user_params[:password])
```

Jeżeli nie widzieliście prezentacji **Sandi Metz** na temat **Null Object Pattern** to polecam ([RailsConf 2015 – Nothing is Something](https://www.youtube.com/watch?v=29MAL8pJImQ)). Możemy stworzyć klasę `TrustedUser` i używać wszędzie tego obiektu bez sprawdzania czy mamy przyjemność z `nil`. Dalej możemy przenieść z powrotem metodę `render` i ustawiania tokenu do metody `create`. Zobaczmy jak nasz kod wygląda po zmianach:

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

Teraz moglibyśmy przystąpić do kolejnej zmiany. Przykładowo przenieść ustawianie tokenu do modelu. Ja na tym poprzestanę. Jeżeli macie ochotę sami możecie spróbować to zmienić. Najtrudniejszą rzeczą w tym zadaniu jest próba odpowiedzenia sobie na pytanie: Czy warto robić takie zmiany? Czy daje nam to jakąś wartość? Odpowiedź zależy od Was.

Mam nadzieję, że Wam się podobał artykuł. Jeżeli macie sugestie co można jeszcze tutaj zmienić – zostawcie swój komentarz. Do zobaczenia następnym razem.
