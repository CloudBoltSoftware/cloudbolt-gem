require 'rubygems'
require 'httparty'
require 'json'

class Cloudbolt
  include HTTParty

  # Can possibly clean this up using accessors
  # http://stackoverflow.com/questions/1251352/ruby-inherit-code-that-works-with-class-variables
  def initialize(proto, host, port, user, pass, ssl_verify=false)
    @proto = proto
    @host = host
    @port = port
    @user = user
    @pass = pass
    @ssl_verify = ssl_verify
    @token = get_token()
  end

  def get_token()
    body = {:username => @user, :password => @pass}
    headers = {"Content-Type" => "application/json"}
    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/api-token-auth/"
    response = HTTParty.post(url, :verify => @ssl_verify, :headers => headers, :body => body.to_json)
    return response['token']
  end

  def get_order_status(url, headers, order_id)
    # Get the order status from the order id
    response = HTTParty.get(url, :verify => @ssl_verify, :headers => headers)
    status = response['status']
    return status
  end

  def wait_for_complete(url, headers, order)
    # Wait until the order submit completes
    order_id = order["_links"]["self"]["title"][/\d+/].to_i
    completed = ['SUCCESS', 'WARNING', 'FAILURE']
    status = nil
    order_url = url + order_id.to_s + '/'
    print "Waiting for Order #{order_id} to complete: "
    until completed.include? status
      status = get_order_status(order_url, headers, order_id)
      print "."
      sleep(5)
    end
    puts " Order Complete!"
  end

  def order_blueprint(group_id, deploy_items, wait)
    # Build order Hash
    order = {"group" => "/api/v2/groups/#{group_id}"}
    order["items"] = {"deploy-items" => deploy_items}
    order["submit-now"] = "true"

    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/orders/"
    headers = {"Content-Type" => "application/json"}
    headers["Authorization"] = "Bearer " + @token
    response = HTTParty.post(url, :verify => @ssl_verify, :headers => headers, :body => order.to_json)
    prov = JSON.parse(response.body)

    if wait
      wait_for_complete(url, headers, prov)
    end

    return prov
  end

  def decom_blueprint(group_id, decom_items, wait)
    # Build order Hash
    order = {"group" => "/api/v2/groups/#{group_id}"}
    order["items"] = {"decom-items" => decom_items}
    order["submit-now"] = "true"

    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/orders/"
    headers = {"Content-Type" => "application/json"}
    headers["Authorization"] = "Bearer " + @token
    response = HTTParty.post(url, :verify => @ssl_verify, :headers => headers, :body => order.to_json)
    decom = JSON.parse(response.body)

    if wait
      wait_for_complete(url, headers, decom)
    end

    return decom
  end

end
