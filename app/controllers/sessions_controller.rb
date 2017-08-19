require 'rpam'

class SessionsController < ApplicationController
  def new
    if logged_in?
       redirect_to '/connection'
    end 
  end
  def create
    username = params[:session][:username]
    password = params[:session][:password]
    if (username == ENV['ADMIN_USERNAME'] and password == ENV['ADMIN_PASSWORD']) then
      log_in username
      redirect_to '/connection'
      return
    elsif Rpam.auth(username, password, :service => 'common-auth') == true then
      if ENV['USER_GROUPS'] then
        user_groups = ENV['USER_GROUPS'].split(';')
        user_groups.each do |group|
          group = group.strip()
          if (`id -G #{username}`.include? group or `groups #{username}`.include? group) then
            log_in username
            redirect_to '/connection'
            return
          end
        end
      end
    end
    redirect_to '/'
  end
  def destroy
    log_out
    redirect_to root_url
  end
  def admin
  end
end
