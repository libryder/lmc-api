class CreateAudioFiles < ActiveRecord::Migration

  ActiveRecord::Base.establish_connection "audio_file"

  def change
  
    create_table :audio_files do |t|
      t.string :title
      t.string :wav_file_name
      t.string :wav_content_type
      t.integer :wav_file_size
      t.datetime :wav_uploaded_at

      t.timestamps
    end
  end
end
