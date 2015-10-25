module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end


    get '/sources/error' do
      @user    = User.find_by({identifier: params["user"]})
      @payload = Payload.find_by({user_id: params["user"]})
      erb :error
    end

    get '/sources' do
      erb :index
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
      # given_path  = Payload.strip_link(@user.identifier, @payload.url)
      if Payload.where(url: passed_path) != []
        erb :urls_rp
      else
        redirect '/sources/error'
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
      if Payload.select(:eventName).empty?
        redirect '/sources/error'
      else
        erb :event_name
      end
    end


    #
    # not_found do
    #   erb :error
    # end

    post '/sources' do
      user = User.new(params)
      if User.all.include?(User.find_by(params))
        status 403
        body "User already exists 403 - Bad Request"
      elsif user.save
        status 200
        body "Success - 200 OK"
      else
        status 400
        body user.errors.full_messages.join(", ")
      end
    end

    post '/sources/:identifier/data'  do |identifier|
      if params["payload"].nil?
        status 400
        body "400 Bad Request - Payload Missing"
      else
        data = ParsePayload.parse(params)
        data["sha"] = Digest::SHA2.hexdigest(params.to_s)
        data["user_id"] = params["identifier"]
        data.delete("parameters")
        payload = Payload.new(data)
        if Payload.all.include?(Payload.find_by("sha" => Digest::SHA2.hexdigest(params.to_s)))
          status 403
          body "403 Forbidden - Duplicate Payload"
        elsif User.find_by(identifier: identifier).nil?
          status 403
          body "403 Forbidden - User Does Not Exist"
        else
          payload.save
          status 200
          body "Success"
        end
      end
    end
  end
end
