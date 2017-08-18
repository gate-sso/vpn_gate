require 'erb'
require 'socket'
require 'vici'
require 'json'

class ConnectionsController < ApplicationController
    def show
        if not logged_in?
            redirect_to '/'
            return
        end
    end
    def get_sas
        if not logged_in?
            redirect_to '/'
            return
        end
        v = Vici::Connection.new(UNIXSocket.new("/var/run/charon.vici"))
        conns = []
        v.list_sas do |sa|
            sa.each do |key, value|
                conn = {}
                conn['username'] = value['remote-xauth-id']
                conn['source_ip'] = value['remote-host']
                conn['virtual_ip'] = value['remote-vips'][0]
                conn['protocol'] = key
                conn['established'] = value['established']
                conns.append(conn)
            end
        end
        render :json => conns.to_json
    end
    def configure
        if not logged_in?
            redirect_to '/'
            return
        end
        if not params[:conn_name] then
            File.open('/etc/ipsec.conf').each do |line|
                if (line.include? 'conn') then
                    conn_name = line.strip().sub(/conn /, '')
                    configure_path = '/connection/configure/' + conn_name
                    redirect_to configure_path 
                    return
                end
            end
        end
        conn_name = params[:conn_name]
        conn_found = false
        @conns = []
        @conn_name = conn_name
        @left_subnet = nil
        @virtual_ip = nil
        @aggressive = false
        @pre_shared_key = ''
        File.open('/etc/ipsec.conf').each do |line|
            if (line.include? 'conn') then
                @conns.push(line.strip().sub(/conn /, ''))
            end
            if (conn_found and not (@left_subnet and @virtual_ip)) then
                if line.include? 'leftsubnet=' then
                    @left_subnet = line.strip().sub(/leftsubnet=/, '')
                elsif line.include? 'rightsourceip=' then
                    @virtual_ip = line.strip().sub(/rightsourceip=/, '')
                elsif line.include? 'aggressive=' then
                    if line.strip().sub(/aggressive=/, '') == 'yes' then
                        @aggressive = true
                    else
                        @aggressive = false
                    end
                end
            else
                if (line.strip() == "conn "+conn_name) then
                    conn_found = true
                end
            end
        end
        ipsec_secrets = File.read('/etc/ipsec.secrets')
        ipsec_secrets.split("\n").each do |line|
            if line.include? 'PSK' and line.split(" ")[0] == conn_name
                @pre_shared_key = line.split(' ')[-1]
            end
        end
        if (not conn_found) then
            redirect_to '/connection/configure'
            return
        end
    end
    def update
        if not logged_in?
            return
        end

        conn_name = params[:connection][:conn_name]
        conn_found = false
        processing_done = false
        ipsec_conf = ''

        leftsubnet = params[:connection][:left_subnet]
        rightsourceip = params[:connection][:virtual_ip]
        pre_shared_key = params[:connection][:pre_shared_key]
        if params[:connection][:aggressive] == '1' then
            aggressive = 'yes'
        else
            aggressive = 'no'
        end

        renderer = ERB.new(File.read('app/views/connections/conn.erb'))
        add_conn = renderer.result(binding)
        ipsec_secrets = ''

        File.open('/etc/ipsec.secrets').each do |line|
            if (line.split(' ')[0] == conn_name)
                ipsec_secrets += conn_name + " : PSK " + pre_shared_key + "\n"
            else
                ipsec_secrets += line
            end
        end
        File.open('/etc/ipsec.conf').each do |line|
            if (processing_done) then
                ipsec_conf += line
            elsif (conn_found and line.include? "conn") then
                processing_done = true
                ipsec_conf += add_conn
                ipsec_conf += line
            elsif (not conn_found) then
                if (line.include? "conn " + conn_name) then
                    conn_found = true
                elsif
                    ipsec_conf += line
                end
            end
        end

        if (not processing_done) then
            ipsec_conf += add_conn
        end

        File.write('/etc/ipsec.conf', ipsec_conf)
        File.write('/etc/ipsec.secrets', ipsec_secrets)
        `ipsec reload && ipsec rereadsecrets`

        conn_configuration_path = '/connection/configure/' + conn_name
        redirect_to conn_configuration_path
    end
    def shw
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

