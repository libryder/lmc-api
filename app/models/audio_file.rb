class AudioFile < ActiveRecord::Base
  establish_connection "audio_file"
  has_attached_file :wav,
                    :styles => {
                       :mp3 => {
                         :params => "-encode --vbr-new -V7",
                         :format => "mp3" }
                    },
                    :default_style => :normal,
                    :processors => [:wav_mp3],
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/call_recordings/:filename"

end
