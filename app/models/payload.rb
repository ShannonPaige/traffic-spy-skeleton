class Payload < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id

  def self.data_status(identifier, params)
    response = {}
    if params["payload"].nil?
      response[:status]  = 400
      response[:body]    = "400 Bad Request - Payload Missing"
    else
      data = ParsePayload.parse(params)
      payload = Payload.new(data)
      if Payload.all.include?(Payload.find_by("sha" => Digest::SHA2.hexdigest(params.to_s)))
        response[:status]  = 403
        response[:body]    = "403 Forbidden - Duplicate Payload"
      elsif User.find_by(identifier: identifier).nil?
        response[:status]  = 403
        response[:body]    = "403 Forbidden - User Does Not Exist"
      else
        payload.save
        response[:status]  = 200
        response[:body]    = "Success"
      end
    end
    response
  end

  def self.sources_status(params)
    user = User.new(params)
    response = {}
    if User.all.include?(User.find_by(params))
      response[:status]  = 403
      response[:body]    = "User already exists 403 - Bad Request"
    elsif user.save
      response[:status]  = 200
      response[:body]    =  "Success - 200 OK"
    else
      response[:status]  = 400
      response[:body]    =  user.errors.full_messages.join(", ")
    end
    response
  end

  def self.sort(hash)
    hash.sort_by { |key, count| key}.sort_by { |key, count| count }.reverse
  end

  def self.count_items(items)
    counted = items.group_by do |item|
      item
    end
    counted.map do |key, value|
      counted[key] = value.count
    end
    counted
  end

  def self.find_one(user_id, column_one)
    items= Payload.where(:user_id => user_id).pluck(column_one)
    counted = count_items(items)
    sort(counted)
  end

  def self.find_two(user_id, column_one, column_two)
    items= Payload.where(:user_id => user_id).pluck(column_one, column_two)
    counted = count_items(items)
    sort(counted)
  end

  def self.url_path(user_id, url)
    root = "http://" + user_id + ".com"
    path = url.gsub(root, "")
  end

  def self.url_link(user_id, url_count)
    path = Payload.url_path(user_id, url_count[0])
    full_url = "/sources/" + user_id + "/urls" + path
  end

  def self.make_link(user_id, path)
    full_url = "http://" + user_id + ".com/" + path
  end

  # def self.strip_link(user_id, full_path_url)
  #   root = "http://" + user_id + ".com/"
  #   path = full_path_url.gsub(root, "")
  # end

  def self.event_link(user_id, url_count)
    path = Payload.url_path(user_id, url_count[0])
    full_url = "/sources/" + user_id + "/events/" + path
  end

  def self.active_record_browser(user_id, user_agent)
    agent_data= Payload.where(:user_id => user_id).pluck(user_agent)
    browser = []
    agent_data.each do |string|
      hash = UserAgent.parse(string)
      browser << hash.browser
    end
    counted = count_items(browser)
    sort(counted)
  end

  def self.active_record_os(user_id, user_agent)
    agent_data= Payload.where(:user_id => user_id).pluck(user_agent)
    platform = []
    agent_data.each do |string|
      hash = UserAgent.parse(string)
      platform << hash.platform
    end
    counted = count_items(platform)
    sort(counted)
  end

  def self.hourly_breakdown(user_id)
    items= Payload.where(:user_id => user_id).pluck(:requestedAt)
    time_breakdown = {"12am - 1am" => 0,
                      "1am - 2am" => 0,
                      "2am - 3am" => 0,
                      "3am - 4am" => 0,
                      "4am - 5am" => 0,
                      "5am - 6am" => 0,
                      "6am - 7am" => 0,
                      "7am - 8am" => 0,
                      "8am - 9am" => 0,
                      "9am - 10am" => 0,
                      "10am - 11am" => 0,
                      "11am - 12pm" => 0,
                      "12pm to 1am" => 0,
                      "1pm - 2pm" => 0,
                      "2pm - 3pm" => 0,
                      "3pm - 4pm" => 0,
                      "4pm - 5pm" => 0,
                      "5pm - 6pm" => 0,
                      "6pm - 7pm" => 0,
                      "7pm - 8pm" => 0,
                      "8pm - 9pm" => 0,
                      "9pm - 10pm" => 0,
                      "10pm - 11pm" => 0,
                      "11pm - 12am" => 0}
    items.each do |time|
      if time.hour < 1
        time_breakdown["12am - 1am"] += 1
      elsif time.hour < 2
        time_breakdown["1am - 2am"] += 1
      elsif time.hour < 3
        time_breakdown["2am - 3am"] += 1
      elsif time.hour < 4
        time_breakdown["3am - 4am"] += 1
      elsif time.hour < 5
        time_breakdown["4am - 5am"] += 1
      elsif time.hour < 6
        time_breakdown["5am - 6am"] += 1
      elsif time.hour < 7
        time_breakdown["6am - 7am"] += 1
      elsif time.hour < 8
        time_breakdown["7am - 8am"] += 1
      elsif time.hour < 9
        time_breakdown["8am - 9am"] += 1
      elsif time.hour < 10
        time_breakdown["9am - 10am"] += 1
      elsif time.hour < 11
        time_breakdown["10am - 11am"] += 1
      elsif time.hour < 12
        time_breakdown["11am - 12pm"] += 1
      elsif time.hour < 13
        time_breakdown["12pm to 1pm"] += 1
      elsif time.hour < 14
        time_breakdown["1pm - 2pm"] += 1
      elsif time.hour < 15
        time_breakdown["2pm - 3pm"] += 1
      elsif time.hour < 16
        time_breakdown["3pm - 4pm"] += 1
      elsif time.hour < 17
        time_breakdown["4pm - 5pm"] += 1
      elsif time.hour < 18
        time_breakdown["5pm - 6pm"] += 1
      elsif time.hour < 19
        time_breakdown["6pm - 7pm"] += 1
      elsif time.hour < 20
        time_breakdown["7pm - 8pm"] += 1
      elsif time.hour < 21
        time_breakdown["8pm - 9pm"] += 1
      elsif time.hour < 22
        time_breakdown["9pm - 10pm"] += 1
      elsif time.hour < 23
        time_breakdown["10pm - 11pm"] += 1
      else
        time_breakdown["11pm - 12am"] += 1
      end
    end
    time_breakdown
  end
end
