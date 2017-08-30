class UsersController < ApplicationController
  def index
    # Мы создаем массив из двух болванок пользователей. Для создания фейковой
    # модели мы просто вызываем метод User.new, который создает модель, не
    # записывая её в базу.
    @users = [
      User.new(
        id: 1,
        name: 'Stas',
        username: 's_vorozhba',
        avatar_url: 'http://rebot.me/assets/images/mini-avatars/523830.jpg?r=1483259163'
      ),
      User.new(id: 2, name: 'Misha', username: 'aristofun')
    ]
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
      name: 'Stas',
      username: 's_vorozhba',
      avatar_url: 'http://rebot.me/assets/images/mini-avatars/523830.jpg?r=1483259163'
    )

    @questions = [
      Question.new(text: 'Как настроение?', created_at: Date.parse('30.08.2017')),
      Question.new(text: 'Почему ежик колючий?', created_at: Date.parse('30.08.2017'))
    ]

    @new_question = Question.new
  end
end
