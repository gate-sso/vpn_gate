require 'rpam'

class SessionsController < ApplicationController
  def new
  end
  def create
    username = params[:session][:username]
    password = params[:session][:password]
    if Rpam.auth(username, password, :service => 'common-auth') == true then
      log_in username
      redirect_to '/admin'
    else
      render 'new'
    end
  end
  def destroy
    log_out
    redirect_to root_url
  end
  def admin
  end
end
