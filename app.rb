require 'sinatra'
require 'faye'
require 'mail'

PhotoList = []

configure do
  mailoptions = { :address              => "smtp.gmail.com",
                  :port                 => 587,
                  :domain               => 'wl.k12.in.us',
                  :user_name            => '',
                  :password             => '',
                  :authentication       => 'plain',
                  :enable_starttls_auto => true  }
  Mail.defaults do
    delivery_method :smtp, mailoptions
  end
  Dir['./public/drop/*.jpg'].each do |f|
    PhotoList << f.split('/').last
  end
  set :faye, Faye::Client.new('http://localhost:9292/faye')
  set :secret, File.read('.secret')
end

get '/' do
  erb "Hello, world!"
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

post '/sendto' do
  if params['addr'].match(/@/) && File.exist?('./public/' + params['src'])
    mail = Mail.new do
      from 'noreply@wl.k12.in.us'
      subject 'Photobooth'
      body "Here's your picture!"
    end
    mail.to params['addr']
    mail.add_file './public/' + params['src']

    mail.deliver!
  end
end
