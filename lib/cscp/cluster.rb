

require 'cscp/server_connection'

module CSCP

  class Cluster

    attr_reader :hosts, :hostnames, :source, :target
    attr_reader :formatter, :username, :password

    def initialize hostnames, source, target, formatter, username, password
      @hostnames = hostnames
      @source    = source
      @target    = target
      @formatter = formatter
      @username  = username
      @password  = password
    end

    def generate_server_connections
      @hosts = []
      @hostnames.each do |hostname|
        host = "@" + hostname unless hostname["@"]
        username, host, port = host.split /:|@/
        username = @username if username.empty?
        @hosts << CSCP::ServerConnection.new( host, port, username, @password )
      end
    end

    def push
      hosts.each { |host, index| host.connect and host.push @source, @target }
    end

    def pull
      hosts.each_with_index do |host, index|
        host.connect and host.pull source, (@formatter % {
          :source   => @source,
          :target   => @target,
          :index    => index,
          :hostname => host.hostname
        })
      end
    end
  end
end
