#!/usr/bin/env ruby

require 'sinatra'
require 'couch_server'
require 'json'

def couch
  @@Couch ||= Couch::Server.new('localhost', '5984')
end

# Create a database
put '/new_db/:db' do
  couch.put("/#{params[:db]}", '')
end

# Delete a database
delete '/del_db/:db' do
  couch.delete("/#{params[:db]}")
end

# Create a new document for the given db
put '/media/:db/:id' do
  data = request.body.read
  couch.put("/#{params[:db]}/#{params[:id]}", data)
end

# Get all documents for the given database
get '/media/all/:db' do
  couch.get("/#{params[:db]}/_all_docs").body
end

# Get a specific document for the given database
get '/media/:db/:id' do
  couch.get("/#{params[:db]}/#{params[:id]}")
end

# Delete a document from the given database
delete '/delete/:db/:id' do
  # need to tell couch what revision to delete
  doc = couch.get("/#{params[:db]}/#{params[:id]}")
  doc_j = JSON(doc.body)
  couch.delete("/#{params[:db]}/#{params[:id]}?rev=#{doc_j['_rev']}")
end

