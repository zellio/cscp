

require 'etc'

require 'net/ssh'
require 'net/scp'

module CSCP

  class ServerConnection

    attr_reader :hostname, :port, :username, :password, :conn, :scp

    def initialize hostname="localhost", port=22, username="", password=""
      @hostname = hostname
      @port     = port
      @username = username.empty? ? Etc.getlogin : username
      @password = password
    end

    def connect
      begin
        @conn = Net::SSH.start( @hostname, @username,
                                { :password => @password,
                                  :port     => @port } )
      rescue Exception => e
        $stderr.puts e.message
        exit 1
      end
      @scp = @conn.scp
    end

    def disconnect
      @conn.close
      @scp = nil
    end

    def pull source, target
      raise Exception, "Not Connected" unless @conn
      @scp.download!( source, target ) do |ch, name, received, total|
        percent = format("%.2f", received.to_f / total.to_f * 100) + "%"
        print "\rpull: #{@hostname}:#{source} > #{target} - #{received}/#{total} (#{percent})"
        $stdout.flush
      end
      puts ""
    end

    def push source, target
      raise Exception, "Not Connected" unless @conn
      @scp.upload!( source, target ) do |ch, name, received, total|
        percent = format("%.2f", received.to_f / total.to_f * 100) + "%"
        print "\rpush: #{@hostname}:#{target} < #{source}  - #{received}/#{total} (#{percent})"
        $stdout.flush
      end
      puts ""
    end
  end
end
