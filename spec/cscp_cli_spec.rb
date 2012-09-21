
require 'spec_helper'
require 'cscp/cli'
require 'optparse'

describe CSCP::CLI do

  before :each do
    @cli = CSCP::CLI.new
    $stdout.stub!(:write)
  end

  describe "#help_message" do
    it "should return @parser.to_s" do
      @cli.help_message.should eql @cli.parser.to_s
    end
  end

  describe "#options" do
    it "should be an OpenStruct" do
      @cli.options.should be_an_instance_of OpenStruct
    end
  end

  describe "#build_parser" do
    it "should build the opt parser" do
      @cli.parser.should be_an_instance_of OptionParser
    end
  end

  describe "#get_credentials" do
    it "should query the user for their username and password" do
      $stdin = StringIO.new "testpass\n"
      $stdin.rewind
      $terminal = HighLine.new $stdin, $stdout
      @cli.stub!(:echo)

      @cli.get_credentials
      @cli.options.password.should eql "testpass"
    end
  end

  describe "#parse" do
    it "should should throw OptionParser::InvalidArgument on no args" do
        -> {
          @cli.parse []
        }.should raise_error OptionParser::InvalidArgument
    end
    it "should should throw OptionParser::InvalidOption on bad args" do
      -> {
        @cli.parse [ "--bad" ]
      }.should raise_error OptionParser::InvalidOption
    end

    describe "#command" do
      it "should be an optional flag with a required argument" do
        @cli.parse [ "--command=PUSH", "s", "d" ]
      end
      it "should only accept PULL or PUSH for its arguments" do
        -> {
          @cli.parse [ "--command=FOO", "s", "d" ]
        }.should raise_error OptionParser::InvalidArgument
        -> {
          @cli.parse [ "-c", "F", "s", "d" ]
        }.should raise_error OptionParser::InvalidArgument
      end
      it "should default to PULL" do
        @cli.parse [ "s", "d" ]
        @cli.options.command.should eql "PULL"
      end
      it "should have an alias of '-c'" do
        @cli.parse ["-c", "PUSH", "s", "d" ]
        @cli.options.command.should eql "PUSH"
      end
    end

    describe "#hostlist" do
      it "should be an optional flag with a required argument" do
        @cli.parse [ "--hostlist=HOST1,HOST2", "s", "d" ]
      end
      it "should default to []" do
        @cli.parse [ "s", "d" ]
        @cli.options.hosts.should eql []
      end
      it "should parse its argument into option.hostname as an array" do
        @cli.parse [ "--hostlist=HOST1,HOST2", "s", "d" ]
        @cli.options.hosts.should eql [ "HOST1", "HOST2" ]
      end
      it "should have an alias of '-l'" do
        @cli.parse [ "-l" "HOST1,HOST2", "s", "d" ]
        @cli.options.hosts.should eql [ "HOST1", "HOST2" ]
      end
    end

    describe "#format" do
      it "should be an optional flag with a required argument" do
        @cli.parse ["--format=FORMAT_STRING", "s", "d" ]
      end
      it "should have an alias of -f" do
        @cli.parse ["-f", "FORMAT_STRING", "s", "d" ]
        @cli.options.formatter.should eql "FORMAT_STRING"
      end
      it "should set the value of @options.format_string" do
        @cli.parse ["--format=FORMAT", "s", "d" ]
        @cli.options.formatter.should eql "FORMAT"
        @cli.parse ["-f", "STRING", "s", "d"]
        @cli.options.formatter.should eql "STRING"
      end
    end

    describe "#user" do
      it "should be a valid flag with a required argument" do
        @cli.parse [ "--user=USERNAME", "s", "d" ]
      end
      it "should have an alias of '-u'" do
        @cli.parse [ "-u" "USERNAME", "s", "d" ]
        @cli.options.username.should eql "USERNAME"
      end
      it "should set the value of @options.username to its argument" do
        @cli.parse [ "--user=USERNAME001", "s", "d" ]
        @cli.options.username.should eql "USERNAME001"
        @cli.parse [ "-u" "USERNAME002", "s", "d" ]
        @cli.options.username.should eql "USERNAME002"
      end
    end

    describe "#help" do
      it "should be a valid falg" do
        -> { @cli.parse [ "--help" ] }.should raise_error SystemExit
      end
      it "should have an alias of '-h'" do
        -> { @cli.parse [ "-h" ] }.should raise_error SystemExit
      end
      it "should return a useful help message" do
        # FIXME
      end
    end

    describe "#version" do
      it "should be a valid flag" do
        -> { @cli.parse [ "--version" ] }.should raise_error SystemExit
      end
      it "should return the current version of the program" do
        -> {
          @cli.parse [ "--version" ]
          v_file = File.join(File.dirname(__FILE__), '..', 'VERSION')
          @cli.options.version.should eql File.exists?(v_file) ? File.read(v_file) : ""
        }.should raise_error SystemExit
      end
    end

    it "should return the sorurce and destination vars" do
      @cli.parse [ "-c", "PUSH", "-l", "HOST", "-f", "STR", "src", "dst" ]
      @cli.options.source.should eql "src"
      @cli.options.target.should eql "dst"
    end

    it "should throw OptionParser::InvalidArgument on lack of src and dst" do
      -> {
        @cli.parse [ "-c", "PUSH", "-l", "HOST", "-f", "STR", "src" ]
      }.should raise_error OptionParser::InvalidArgument
    end
  end
end
