require "mysql2"
require "socket"
require "vici"

def create_closed_connection_query(conn, time)
    query = "INSERT INTO vpn_sessions (username, source_ip, virtual_ip, protocol, connection_started_time, connection_ended_time, created_at, updated_at) VALUES ('#{conn['username']}','#{conn['source_ip']}','#{conn['virtual_ip'][0]}','#{conn['protocol']}',NOW() - INTERVAL #{time} SECOND,NOW(),NOW(),NOW());"
    puts query
    return query
end

# Open connections for vici (strongSwan) and db (SQLite3)
v = Vici::Connection.new(UNIXSocket.new("/var/run/charon.vici"))
print "Host: "
host = gets.chomp
print "Username: "
username = gets.chomp
print "Password: "
password = gets.chomp
db = Mysql2::Client.new(:host => host, :username => username, :password => password)
db.select_db('vpn_gate_dev')

active_connections = []
past_connections = []
past_times = []

while true 
    # Get current connections
    active_connections = []
    active_times = []
    v.list_sas do |sa|
        sa.each do |key, value|
            connection = {}
            connection['username'] = value['remote-xauth-id']
            connection['source_ip'] = value['remote-host']
            connection['virtual_ip'] = value['remote-vips']
            connection['protocol'] = key
            if connection['username'] != nil 
                active_connections.push(connection)
                active_times.push(value['established'])
            end
        end
    end

    # Get updates on connections
    past_connections.zip(past_times).each do |connection, time|
        if not active_connections.include? connection
            query = create_closed_connection_query(connection, time)
            db.query(query)
            puts db.query("SELECT * FROM vpn_sessions")
        end
    end
    past_connections = active_connections
    past_times = active_times
    sleep(1)
end
db.close

