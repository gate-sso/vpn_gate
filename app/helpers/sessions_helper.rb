module SessionsHelper
  def log_in(user)
    session[:user_id] = user
  end
  def logged_in?
    !session[:user_id].nil?
  end
  def log_out
    session.delete(:user_id)
  end
end
