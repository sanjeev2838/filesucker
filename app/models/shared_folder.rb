class SharedFolder < ActiveRecord::Base
  belongs_to :user

  #this is for the user to whom the owner has shared folders to
  belongs_to :shared_user, :class_name => "User", :foreign_key => "shared_user_id"

  #for the folder being shared
  belongs_to :folder
end
