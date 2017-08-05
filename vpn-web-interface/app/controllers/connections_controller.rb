class ConnectionsController < ApplicationController
    layout false
    def index
        @datas = Connection.all
    end
    def create
    end
    def new
    end
    def show
        if params[:username] != nil
            @title = params[:username]
            @datas = Connection.where(username: @title)
        elsif params[:source_ip] != nil
            @title = params[:source_ip]
            @datas = Connection.where(source_ip: @title)
        elsif params[:remote_ip] != nil
            @title = params[:remote_ip]
            @datas = Connection.where(remote_ip: @title)
        elsif params[:protocol] != nil
            @title = params[:protocol]
            @datas = Connection.where(protocol: @title)
        else
            @title = "Connections"
            @datas = Connection.all
        end
    end
end

