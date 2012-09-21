
require 'spec_helper'
require 'cscp/cluster'

describe CSCP::Cluster do

  before :each do
    @cluster = CSCP::Cluster.new( ["host1", "host2"], "source", "target",
                                  "\#{source}\#{host}", "zellio", "" )
  end

  describe "#hostnames" do
    it "should be read only" do
      -> { @cluster.hostnames = nil }.should raise_error NoMethodError
    end
    it "should be set by initialize" do
      @cluster.hostnames.should eql ["host1", "host2"]
    end
  end

  describe "#source" do
    it "should be read only" do
      -> { @cluster.source = nil }.should raise_error NoMethodError
    end
    it "should be a string" do
      # FIXME
    end
    it "should be set by initialize" do
      @cluster.source.should eql "source"
    end
  end

  describe "#target" do
    it "should be read only" do
      -> { @cluster.target = nil }.should raise_error NoMethodError
    end
    it "should be a string" do
      # FIXME
    end
    it "should be set by initialize" do
      @cluster.target.should eql "target"
    end
  end

  describe "#formatter" do
    it "should be read only" do
      -> { @cluster.formatter = nil }.should raise_error NoMethodError
    end
    it "should be a string" do
      # FIXME
    end
    it "should be set by initialize" do
      @cluster.formatter.should eql "\#{source}\#{host}"
    end
   end

  describe "#username" do
    it "should be read only" do
      -> { @cluster.username = nil }.should raise_error NoMethodError
    end
    it "should be a string" do
      # FIXME
    end
    it "should be set by initialize" do
       @cluster.username.should eql "zellio"
   end
  end

  describe "#password" do
    it "should be read only" do
      -> { @cluster.password = nil }.should raise_error NoMethodError
    end
    it "should be a string" do
      # FIXME
    end
    it "should be set by initialize" do
      @cluster.password.should eql ""
    end
  end

  describe "#pull" do
    it "should actually have tests" do
      # FIXME
    end
  end

  describe "#push" do
    it "should actually have tests" do
      # FIXME
    end
  end

end
