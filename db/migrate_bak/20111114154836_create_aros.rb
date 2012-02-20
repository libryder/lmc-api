class CreateAros < ActiveRecord::Migration
  def change
    create_table :aros do |t|

      t.timestamps
    end
  end
end
