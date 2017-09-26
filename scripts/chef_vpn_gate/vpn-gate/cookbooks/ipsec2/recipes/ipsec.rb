ipsec2_setup_ipsec "ipsec" do
  app_name "ipsec"
end

execute "Setup IP forwarding" do
  command "echo 1 > /proc/sys/net/ipv4/ip_forward"
end


