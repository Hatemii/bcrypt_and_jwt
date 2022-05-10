class AuthController < ApplicationController
  def login
    user = User.find_by(email: login_params[:email]).try(:authenticate, login_params[:password])

    if user
      token = JWT.encode({ user_id: user.id, exp: 10.minutes.from_now.to_i }, 'secret', 'HS256')
      session[:user_id] = user.id

      render json: {
        user: user,
        token: token,
        message: 'Logged in successfully'
      }
    else
      render json: { message: 'Invalid email or password' }
    end
  end

  def logged_in
    if current_user
      render json: { logged_in: true, user: current_user }
    else
      render json: { logged_in: false }
    end
  end

  def logout
    if session[:user_id]
      reset_session
      render json: {
        status: 200,
        logged_out: true,
        session: session[:user_id],
        message: 'Successfully logged Out!'
      }
    else
      render json: { message: 'Already logged out' }
    end
  end

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def login_params
    reset_session
    params.permit(:email, :password)
  end
end
