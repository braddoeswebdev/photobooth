require 'sinatra'
require 'faye'

PhotoList = {}

configure do
  set :faye, Faye::Client.new('http://localhost:9292/faye')
end

get '/' do
  "Hello, world!"
end

put '/:filename' do
  settings.faye.publish('/new', 'name' => params['filename'])
end

get '/list' do
  erb :list
end
