require 'rubygems'
require 'httparty'
require 'json'

class Cloudbolt
  include HTTParty

  # Can possibly clean this up using accessors
  # http://stackoverflow.com/questions/1251352/ruby-inherit-code-that-works-with-class-variables
  def initialize(proto, host, port, user, pass)
    @proto = proto
    @host = host
    @port = port
    @user = user
    @pass = pass
  end

  def get_order_status(url, headers, auth, order_id)
    # Get the order status from the order id
    response = HTTParty.get(url, :verify => false, :headers => headers, :basic_auth => auth)
    status = response['status']
    return status
  end

  def wait_for_complete(url, headers, auth, order)
    # Wait until the order submit completes
    order_id = order["_links"]["self"]["title"][/\d+/].to_i
    completed = ['SUCCESS', 'WARNING', 'FAILURE']
    status = nil
    order_url = url + order_id.to_s + '/'
    print "Waiting for Order #{order_id} to complete: "
    until completed.include? status
      status = get_order_status(order_url, headers, auth, order_id)
      print "."
      sleep(5)
    end
    puts " Order Complete!"
  end

  def argopts_to_hash(arg_array)
    # Convert ["name1=val1", "name2=val2"] to {'name1': 'val1', 'name2': 'val2'}
    arg_hash = Hash.new
    arg_array.each {|x|
      key, value = x.split "="
      arg_hash[key] = value
    }
    return arg_hash
  end

  def cb_prov(group_id, env_id, owner_id, osbuild_id, app_ids, params, hostname, preconfigs, wait)
    # Build prov_item Hash
    prov_item = {"environment" => "/api/v2/environments/#{env_id}"}
    if hostname
      prov_item["attributes"] = {"hostname" => hostname}
    end
    if osbuild_id
      prov_item["os-build"] = "/api/v2/os-builds/#{osbuild_id}"
    end
    if params
      params_hash = argopts_to_hash(params)
      prov_item["parameters"] = params_hash
    end
    if preconfigs
      preconfigs_hash = argopts_to_hash(preconfigs)
      prov_item["preconfigurations"] = preconfigs_hash
    end
    if app_ids
      apps_array = Array.new
      app_ids.each {|id|
        api_path = "/api/v2/applications/" + id.to_s
        apps_array.push(api_path)
      }
      prov_item["applications"] = apps_array
    end
    # Build order Hash
    order = {"group" => "/api/v2/groups/#{group_id}"}
    if owner_id
      order["owner"] = "/api/v2/users/#{owner_id}"
    end
    order["items"] = {"prov-items" => [prov_item]}
    order["submit-now"] = "true"

    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/orders/"
    auth = {:username => @user, :password => @pass}
    headers = {"Content-Type" => "application/json"}
    response = HTTParty.post(url, :verify => false, :headers => headers, :basic_auth => auth, :body => order.to_json)
    prov = JSON.parse(response.body)

    if wait
      wait_for_complete(url, headers, auth, prov)
    else
      puts prov["_links"]["self"]["title"][/\d+/].to_i
    end
  end

  def cb_decom(group_id, env_id, server_ids, wait)
    # Build decom_item Hash
    decom_item = {"environment" => "/api/v2/environments/#{env_id}"}
    servers_array = Array.new
    server_ids.each {|id|
      api_path = "/api/v2/servers/" + id.to_s
      servers_array.push(api_path)
    }
    decom_item["servers"] = servers_array
    # Build order Hash
    order = {"group" => "/api/v2/groups/#{group_id}"}
    order["items"] = {"decom-items" => [decom_item]}
    order["submit-now"] = "true"
    url = @proto + "://" + @host.to_s + ":" + @port + "/api/v2/orders/"
    auth = {:username => @user, :password => @pass}
    headers = {"Content-Type" => "application/json"}
    response = HTTParty.post(url, :verify => false, :headers => headers, :basic_auth => auth, :body => order.to_json)
    decom = JSON.parse(response.body)
    puts decom
    if wait
      wait_for_complete(url, headers, auth, decom)
    else
      puts decom["_links"]["self"]["title"][/\d+/].to_i
    end
  end

end
