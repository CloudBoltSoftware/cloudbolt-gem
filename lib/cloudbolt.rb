require 'rubygems'
require 'httparty'
require 'json'

class Cloudbolt
  include HTTParty

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

  def get_order(order_id)
    # Get the order from the order id
    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/orders/#{order_id}/"
    headers = {"Content-Type" => "application/json"}
    headers["Authorization"] = "Bearer " + @token
    response = HTTParty.get(url, :verify => @ssl_verify, :headers => headers)
    return response
  end

  def wait_for_complete(url, headers, order, wait_time=5)
    # Wait until the order submit completes
    order_id = order["_links"]["self"]["title"][/\d+/].to_i
    completed = ['SUCCESS', 'WARNING', 'FAILURE']
    status = nil
    print "Waiting for Order #{order_id} to complete: "
    until completed.include? status
      order = get_order(order_id)
      status = order["status"]
      print "."
      sleep(wait_time)
    end
    puts " Order Complete!"
  end

  def get_server(server_id)
    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/servers/#{server_id}/"
    headers = {"Content-Type" => "application/json"}
    headers["Authorization"] = "Bearer " + @token
    response = HTTParty.get(url, :verify => @ssl_verify, :headers => headers)
    return response
  end

  def get_server_from_order(order_id)
    server = {}
    hostname = nil
    until hostname
      order = get_order(order_id)
      jobs = order["_links"]["jobs"]
      for job in jobs do
        job_url = job["href"]
        response = HTTParty.get(job_url, :verify => @ssl_verify, :headers => headers)
        if response["type"] == "Provision Server"
          hostname = response["_links"]["servers"]["title"]
          id = response["_links"]["servers"]["href"].split('/').last
        end
      end
      sleep(5)
    end
    server["hostname"] = hostname
    server["id"] = id
    return server
  end

  def order_blueprint(group_id, deploy_items, wait, wait_time=5)
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
      wait_for_complete(url, headers, prov, wait_time)
    end

    return prov
  end

  def decom_blueprint(group_id, decom_items, wait, wait_time=5)
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
      wait_for_complete(url, headers, decom, wait_time)
    end

    return decom
  end

end
