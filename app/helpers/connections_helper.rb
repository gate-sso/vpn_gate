module ConnectionsHelper
    def get_conns
        conns = []
        File.open('/etc/ipsec.conf').each do |line|
            if (line.include? 'conn') then
                conns.push(line.strip().sub(/conn /, ''))
            end
        end
        return conns
    end
end
