class AuthController < ApplicationController
  
  def login
    user = User.find_by(email: login_params[:email])
    if user && user.authenticate(login_params[:password])
      token = JWT.encode({user_id: user.id}, 'secret', 'HS256')
      
      render json: {
        user: user,
        token: token,
        message: "Logged in successfully"
      }
    else
      render json:{ message: "Invalid email or password" }
    end
  end

  private

    def login_params
      params.permit(:email, :password)
    end
end
