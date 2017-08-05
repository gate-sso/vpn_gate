require "socket"
require "vici"
require "erb"
class VpnController < ApplicationController
    def index
        @template = File.read('app/views/vpn/index.html.erb')
        ERB.new(@template).result(binding)
    end
    def test
        v = Vici::Connection.new(UNIXSocket.new("/var/run/charon.vici"))
        datas = []
        v.list_sas do |sa|
            sa.each do |key, value|
                data = "#{value['remote-xauth-id']} (#{value['remote-host']} - #{value['remote-vips'][0]}) : #{key}, #{value['established']}s"
                datas.append(data)
            end
        end
        @datas = datas
        @template = File.read('app/views/vpn/test.html.erb')
        render :layout => false
        ERB.new(@template).result(binding)
    end
    def history
        @datas = Connection.find(params[:username])
        @template = File.read('app/views/vpn/history.html.erb')
        render :layout => false
        ERB.new(@template).result(binding)
    end
end

