class CreateOrganizationalUnits < ActiveRecord::Migration
  def change
    create_table :organizational_units do |t|

      t.timestamps
    end
  end
end
