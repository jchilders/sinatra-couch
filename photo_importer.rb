require 'couch_server'
require 'json'

class PhotoImporter

  @@App = Couch::Server.new('localhost', '4567')

  def create_photos_db
    @@App.put('/new_db/photos', '')
  end

  def delete_photos_db
    @@App.delete('/del_db/photos')
  end

  def import_photos
    File.open('photos.json', 'r') do |f|
      while line = f.gets
        photo = JSON(line) # JSON constructor returns a hash. Makes total sense.

        # Couch expects an '_id' parameter rather than 'uuid'
        uuid = photo['uuid']
        photo.delete('uuid')
        photo['_id'] = uuid.gsub!(/-/, '')

        # @@App.put("/photos/#{uuid}", photo.to_json) # Direct to Couch
        @@App.put("/media/photos/#{uuid}", photo.to_json) # Via Sinatra
      end
    end
  end
end
