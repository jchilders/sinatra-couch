#!/usr/bin/env ruby

require 'photo_importer'

pi = PhotoImporter.new
5.times do |run|
  t1 = Time.now
  pi.delete_photos_db
  pi.create_photos_db
  pi.import_photos
  t2 = Time.now
  puts "Run #{run} took #{t2 - t1}s"
end

