class AsyncModel < ActiveRecord::Base
  
  after_create do |am|
    am.update_attributes :created_by_pid => Process.pid
  end
  
  async_after_create do |am|
    am.update_attributes :async_created_by_pid => Process.pid
  end

  def update_description(d)
    update_attributes :description => d
  end

end
