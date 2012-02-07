require File.expand_path('../../spec_helper', __FILE__)

describe AsyncModel do
  describe "enqueue and execute" do
    before(:each) do
      clean_database!
      @as = AsyncModel.create(:name => "Bob Jones")
    end

    it "should execute async populate the description field" do
      @as.async_send_opts(:update_description, {:pri => :direct}, @as.name)
      sleep(1)
      @as.reload
      @as.description.should == @as.name
    end
    
    it "should send an async library message (touch)" do
      old = @as.updated_at
      @as.async_send_opts(:touch, :pri => :direct)
      sleep(1)
      @as.reload
      @as.updated_at.should_not == old
    end
  end
end