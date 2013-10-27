class HelloApp < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :threaded, false
  end

  get '/' do
    erb "Welcome !<br><a href='/event'>Send event</a>" 
  end

  get '/event' do
    $spawned_process.notify "website"
    redirect to('/')
  end
end
