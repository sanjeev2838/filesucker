class Folder < ActiveRecord::Base
  acts_as_tree

  has_many :assets, :dependent => :destroy
  belongs_to :user
end
