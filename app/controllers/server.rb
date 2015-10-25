module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    get '/sources' do
      erb :index
    end

    get '/sources/error' do
      @user    = User.find_by({identifier: params["user"]})
      @payload = Payload.find_by({user_id: params["user"]})
      @events  = Payload.where(eventName: params["payload"])
      @url     = params['path']
      erb :error
    end

    get '/sources/:identifier' do |identifier|
      @user = User.find_by(identifier: identifier)
      @payload = Payload.find_by(user_id: identifier)
      if @user.nil?
        redirect "/sources/error"
      else
        erb :user
      end
    end

    get '/sources/:identifier/data' do |identifier|
      @user = User.find_by(identifier: identifier)
      erb :data
    end

    get '/sources/:identifier/urls' do |identifier|
      @user = User.find_by(identifier: identifier)
        erb :urls
    end

    get '/sources/:identifier/urls/:path' do |identifier, path|
      @user = User.find_by(identifier: identifier)
      @payload = Payload.find_by(user_id: identifier)
      passed_path = Payload.make_link(@user.identifier, path)
      if Payload.where(url: passed_path) != []
        erb :urls_rp
      else
        redirect "/sources/error?user=#{identifier}&path=#{path}"
      end
    end

    get '/sources/:identifier/events' do |identifier|
      @user = User.find_by(identifier: identifier)
      @payload = Payload.find_by(user_id: identifier)
      if @payload.eventName.nil?
        redirect "/sources/error?user=#{identifier}"
      else
        erb :events
      end
    end

    get '/sources/:identifier/events/:eventname' do |identifier, eventname|
      @user = User.find_by(identifier: identifier)
      @events = Payload.where(eventName: eventname)
      if @events.empty?
        redirect "/sources/error?payload=#{eventname}&user=#{identifier}"
      else
        erb :event_name
      end
    end

    not_found do
      erb :error
    end

    post '/sources' do
      response = Payload.sources_status(params)
      status response[:status]
      body response[:body]
    end

    post '/sources/:identifier/data'  do |identifier|
      response = Payload.data_status(identifier, params)
      status response[:status]
      body response[:body]
    end
  end
end
