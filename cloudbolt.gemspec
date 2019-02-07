Gem::Specification.new do |s|
  s.name        = 'cloudbolt'
  s.version     = '0.0.4'
  s.date        = '2019-01-31'
  s.summary     = 'CloudBolt Ruby Library'
  s.description = 'A gem to interface with the CloudBolt REST API'
  s.authors     = 'Adam Kinney'
  s.email       = 'akinney@cloudbolt.io'
  s.files       = [
    'lib/cloudbolt.rb',
  ]
  s.executables = [
    'cb_order_blueprint',
    'cb_decom_blueprint',
  ]
  s.add_dependency 'json',     '~> 2.0'
  s.add_dependency 'httparty', '~> 0.13'
  s.homepage    = 'http://cloudbolt.io'
  s.license     = 'MIT'
end
