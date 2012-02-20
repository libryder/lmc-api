class CreateCallDetails < ActiveRecord::Migration
  def change
    create_table :call_details do |t|

      t.timestamps
    end
  end
end
