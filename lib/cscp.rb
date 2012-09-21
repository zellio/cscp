

require 'cscp/cli'
require 'cscp/cluster'

module CSCP
  class Application
    def self.run *args
      cli = CSCP::CLI.new

      begin
        cli.parse args
      rescue
        puts cli.help_message
        exit
      end

      cli.get_credentials
      opts = cli.options

      cluster =
        CSCP::Cluster.new( opts.hosts, opts.source, opts.target,
                           opts.formatter, opts.username, opts.password )

      cluster.generate_server_connections

      ({ "PUSH" => -> { cluster.push },
         "PULL" => -> { cluster.pull }}[opts.command]).call()
    end
  end
end
