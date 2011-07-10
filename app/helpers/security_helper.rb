
module SecurityHelper

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id].nil?
      raise SecurityError, "current user can not be called without first having the user sign in"
    end

    if @current_user.nil?
      User.find(session[:user_id])
    else
      @current_user
    end
  end

  def user_authenticated?
    not session[:user_id].nil?
  end

end
