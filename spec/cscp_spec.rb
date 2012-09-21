
require 'spec_helper'
require 'cscp'

describe CSCP::Application do
  before :each do
    $stdout.stub!(:write)
    @cli = CSCP::CLI.new
  end

  describe "#run" do
    it "should print the help message and quit on no args" do
      -> {
        CSCP::Application.run([ ]).should eql cli.help_message
      }.should raise_error SystemExit
    end

    it "should print the help message and quit on bad args" do
      -> {
        cli = CSCP::CLI.new
        CSCP::Application.run([ "--bad" ]).should eql cli.help_message
      }.should raise_error SystemExit
    end

    it "should query the user for credential" do
      # FIXME
    end
  end
end
