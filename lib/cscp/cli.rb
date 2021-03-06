
require 'etc'
require 'optparse'
require 'ostruct'

require 'highline/import'

module CSCP

  class CLI

    attr_reader :options, :parser

    def initialize *args
      @options = OpenStruct.new
      build_parser
    end

    def build_parser
      @parser = OptionParser.new do |o|
        o.banner = "cscp - cluster secure copy (remote file copy program)."
        o.separator ""
        o.separator "Usage: cscp [OPTION]... SOURCE DEST"
        o.separator ""
        o.separator "Specific options:"

        o.on "-c", "--command=(PUSH|PULL)", ["PUSH", "PULL", "push", "pull"],
        "Direction of file transfer" do |c|
          @options.command = c
        end
        o.on "-l", "--hostlist=HOST1[,HOST2...]", Array,
        "List of foriegn hosts" do |h|
          @options.hosts = h
        end
        o.on "-f", "--format=STRING", "Format string for local filenames" do |f|
          @options.formatter = f
        end
        o.on "-u", "--user=USERNAME", "Set the global login name." do |u|
          @options.username = u
        end

        o.separator ""
        o.separator "General options:"
        o.on "-h", "--help", "Display this help message." do
          puts help_message
          exit
        end
        o.on "--version", "Display the version number" do
          v_file = File.join(File.dirname(__FILE__), '../..', 'VERSION')
          @options.version = File.exists?(v_file) ? File.read(v_file) : ""
          puts @options.version
          exit
        end

        o.separator ""
      end
    end

    def get_credentials
      @options.password = ask( "Password: " ) { |q| q.echo = "*" }
    end

    def parse args
      @options.command = "PULL"
      @options.hosts = [];
      @options.formatter = "%{source}.%{hostname}"
      @options.username = Etc.getlogin
      @options.source, @options.target = @parser.parse! args
      raise OptionParser::InvalidArgument.new unless
        @options.source and @options.target
    end

    def help_message
      @parser.to_s
    end
  end
end
