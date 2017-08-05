require "sqlite3"
require "socket"
require "vici"

def create_closed_connection_query(conn, time)
    query = "INSERT INTO connections (username, source_ip, remote_ip, protocol, connection_started_time, connection_ended_time, created_at, updated_at) VALUES ('#{conn['username']}','#{conn['source_ip']}','#{conn['remote_ip'][0]}','#{conn['protocol']}',DateTime('now', '-#{time} seconds','localtime'),DateTime('now','localtime'),DateTime('now','localtime'),DateTime('now','localtime'))"
    return query
end

# Open connections for vici (strongSwan) and db (SQLite3)
v = Vici::Connection.new(UNIXSocket.new("/var/run/charon.vici"))
db = SQLite3::Database.open "../../db/development.sqlite3"

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
            connection['remote_ip'] = value['remote-vips']
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
            db.execute query
        end
    end
    past_connections = active_connections
    past_times = active_times
    sleep(1)
end
puts db.execute "SELECT * FROM connections"
db.close

