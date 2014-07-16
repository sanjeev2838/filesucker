class Asset < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder

  mount_uploader :uploaded_file, UploadedFileUploader
end
