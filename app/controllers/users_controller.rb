class UsersController < ApplicationController
  # before_action :authenticate_user! 

  def index
    users = User.all.order("created_at desc")
    render json: users
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def create
    user = User.create!(user_params)
    if user.valid?
      token = JWT.encode({user_id: user.id, exp: 10.minutes.from_now.to_i}, 'secret', 'HS256')

      render json: {
        user: user, 
        token: token,
        message:"created successfully"
      }
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
  end

  private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
