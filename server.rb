require 'goliath'
require 'digest/sha1'
require 'pry'
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'json'

SETTINGS = {
    "params": {
        "appid": 157,
        "device_id": "2b6f0cc904d137be2e1730235f5664094b83",
        "locale": "de",
        "ip": "109.235.143.113",
        "offer_types": 112
    },
    "api_key": ENV['api_key'], 
    "endpoint": "http://api.sponsorpay.com/feed/v1/offers.json"
}

def hashkey(params, api_key=SETTINGS[:api_key])
  str = params.sort_by{|k,_| k}.map{|x| "#{x[0]}=#{URI::encode(x[1].to_s)}"}.join("&")
  signed_str = Digest::SHA1.hexdigest("#{str}&#{api_key}")
  return signed_str
end

class Hello < Goliath::API
  use ::Rack::Reloader, 0 if Goliath.env?('development')
  use Goliath::Rack::Params

  def response(env)
    if env['REQUEST_PATH'] != '/offers.json'
        response = File.open('./index.html', 'rb').read()
        return [200, {'Content-Type' => 'text/html; charset=UTF-8'}, response]
    end
    headers = {}
    headers.merge!(cors_headers)
    
    if env['REQUEST_METHOD'] == 'OPTIONS'
        return [200, cors_headers, 'ok']    
    end
    
    params = ['uid', 'pub0', 'page'].map{|p| {p.to_sym => env.params[p]} if env.params[p]}.flatten.compact.inject(:merge)
    if params.size != 3
        return [400, headers, 'some params not present']
    end
    params.merge!(SETTINGS[:params])
    params[:timestamp] = Time.now.utc.to_i
    params[:hashkey] = hashkey(params)
    url = "#{SETTINGS[:endpoint]}?#{parameterize(params)}"
    req = EM::HttpRequest.new(url).get
    if req.response_header.status != 200
        return [req.response_header.status, headers, req.response]
    end
    begin
        data = JSON.parse(req.response)
    rescue Exception => err
        return [500, headers, "failed #{err}"]
    end
    out = {status: data['code'] || 'failed', offers: data['offers'] || []}
    response = JSON.generate(out)
    if env.params['callback']
        headers['Content-Type'] = 'application/javascript; charset=utf-8'
        response = "#{env.params['callback']}(#{response});"
    end
    [200, headers, response]
  end

  private

  def parameterize(params)
    URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  end

  def cors_headers
    {
     "Access-Control-Allow-Origin": "*",
     "Access-Control-Request-Method": "POST, GET, OPTIONS",
     "Access-Control-Allow-Headers": "Content-type",
     "Access-Control-Max-Age": '1728000',
     "Content-Type": "application/json; charset=utf-8",
    }
  end

end
