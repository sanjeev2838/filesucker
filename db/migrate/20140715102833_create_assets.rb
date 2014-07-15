class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :uploaded_file
      t.references :user

      t.timestamps
    end
  end
end
