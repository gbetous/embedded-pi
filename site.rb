class HelloApp < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :threaded, false
  end

  get '/' do
    erb "Welcome !<br><a href='/event'>Send event</a>(event number : <%=$count_event%>)" 
  end

  get '/event' do
    Event_proc.notify "website"
    redirect to('/')
  end
end
