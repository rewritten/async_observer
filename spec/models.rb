class AsyncModel < ActiveRecord::Base

  def update_description(d)
    update_attributes :description => d
  end

end
