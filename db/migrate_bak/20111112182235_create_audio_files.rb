class CreateAudioFiles < ActiveRecord::Migration
  def change
    create_table :audio_files do |t|
      t.integer :call_detail_id
      t.string :audio_file_name
      t.string :audio_content_type
      t.integer :audio_file_size
      t.datetime :audio_updated_at

      t.timestamps
    end
  end
end
