
require 'spec_helper'
require 'cscp/server_connection'

require 'etc'

require 'net/ssh'

describe CSCP::ServerConnection do
  let (:ssh_connection) { mock("SSH Connection") }
  let (:scp_connection) { mock("SCP Connection") }

  before :each do
    Net::SSH.stub!(:start) { ssh_connection }
    ssh_connection.stub!(:scp) { scp_connection }
    scp_connection.stub!(:download) { }

    @sc = CSCP::ServerConnection.new
  end

  describe "#attribute" do
    describe "@hostname" do
      it "should be readonly" do
        -> { @sc.hostname = "bar" }.should raise_error NoMethodError
      end
      it "should default to localhost" do
        @sc.hostname.should eql "localhost"
      end
    end
    describe "@port" do
      it "should be readonly" do
        -> { @sc.port = 10 }.should raise_error NoMethodError
      end
      it "should default to 22" do
        @sc.port.should eql 22
      end
    end
    describe "@username" do
      it "should be readonly" do
        -> { @sc.username = "foo" }.should raise_error NoMethodError
      end
      it "should default to local user name" do
        @sc.username.should eql Etc.getlogin
      end
    end
    describe "@password" do
      it "should be readonly" do
        -> { @sc.password = "foo" }.should raise_error NoMethodError
      end
      it "should default to \"\"" do
        @sc.password.should eql ""
      end
    end
  end

  describe "#connect" do
    it "should connect to @hostname on @port using @password and @username" do
      Net::SSH.should_receive(:start).with("localhost", "zellio",
                                           :password => "", :port => 22)
      ssh_connection.should_receive(:scp)
      @sc.connect
    end
  end

  describe "#disconnect" do
    before :each do
      Net::SSH.should_receive(:start).with("localhost", "zellio",
                                           :password => "", :port => 22)
      ssh_connection.should_receive(:scp)
      @sc.connect
    end
    it "should close an open connection" do
      ssh_connection.should_receive(:close)
      @sc.disconnect
      @sc.scp.should eql nil
    end
  end

  describe "#pull" do
    it "should throw a CSCP::ServerConnection::Exception if not connected" do
      # FIXME
    end
    it "should download source and write to target" do
      # FIXME
#      @sc.connect
#      @sc.pull "source", "target"
    end
  end

  describe "#push" do
    it "should throw a CSCP::ServerConnection::Exception if not connected" do
      # FIXME
    end
    it "sould upload source to target" do
      # FIXME
    end
  end
end
