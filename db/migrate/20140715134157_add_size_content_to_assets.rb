class AddSizeContentToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :file_size, :string
    add_column :assets, :content_type, :string
  end
end
