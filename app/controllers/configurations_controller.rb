class ConfigurationsController < ApplicationController
    def show
        if not admin?
            redirect_to '/'
            return
        end
        @gate_url = 'https://localhost'
        @gate_token = 'default_token'
        @min_user_id = '5000'
        @user_groups = ''
        @conns = get_conns
        if ENV['USER_GROUPS']
            @user_groups = ENV['USER_GROUPS']
        end
        pam_config = File.read('/etc/pam.d/gate-sso')
        pam_config.split(' ').each do |data|
            if data.include? 'url='
                @gate_url = data[4..-1]
            elsif data.include? 'token='
                @gate_token = data[6..-1]
            elsif data.include? 'min_user_id='
                @min_user_id = data[12..-1]
            end
        end
    end
    def update
        if not admin?
            redirect_to '/'
            return
        end
        @gate_url = 'https://localhost'
        @gate_token = 'default_token'
        @min_user_id = '5000'

        if params[:configuration][:gate_url]
            @gate_url = params[:configuration][:gate_url]
        end
        if params[:configuration][:gate_token]
           @gate_token = params[:configuration][:gate_token]
        end
        if params[:configuration][:min_user_id]
            @min_user_id = params[:configuration][:min_user_id]
        end
        if params[:configuration][:pre_shared_key]
            @pre_shared_key = params[:configuration][:pre_shared_key]
        end
        if params[:configuration][:user_groups]
            ENV['USER_GROUPS'] = params[:configuration][:user_groups]
        end
        gate_sso = ERB.new(File.read('app/views/configurations/gate-sso.erb'))
        File.write('/etc/pam.d/gate-sso', gate_sso.result(binding))

        redirect_to '/configuration'
    end
end
