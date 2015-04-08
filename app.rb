require 'sinatra'
require 'faye'

PhotoList = []

configure do
  Dir['./public/drop/*.jpg'].each do |f|
    PhotoList << f.split('/').last
  end
  set :faye, Faye::Client.new('http://localhost:9292/faye')
  set :secret, File.read('.secret')
end

get '/' do
  erb "Hello, orld!"
end

put '/:filename' do
  if params[:secret] = settings.secret
    settings.faye.publish('/new', 'name' => params['filename'])
    PhotoList << params[:filename]
    [201, "OK"]
  end
end

get '/list' do
  erb :list
end

get '/slide' do
    erb :slide
end

get '/grid' do
    erb :grid
end
