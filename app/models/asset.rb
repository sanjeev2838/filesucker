class Asset < ActiveRecord::Base
  belongs_to :user

  mount_uploader :uploaded_file, UploadedFileUploader
end
