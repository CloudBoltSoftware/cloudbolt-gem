Gem::Specification.new do |s|
  s.name        = 'cloudbolt'
  s.version     = '0.0.1'
  s.date        = '2016-06-10'
  s.summary     = "Rbuy CloudBolt's API"
  s.description = "A gem to interface with CloudBolt's API"
  s.authors     = "Adam Kinney"
  s.email       = 'akinney@cloudbolt.io'
  s.files       = [
    "lib/cloudbolt.rb",
  ]
  s.executables = [
    "cb_prov",
    "cb_decom",
  ]
  s.add_dependency 'json',     "~> 1.8"
  s.add_dependency 'httparty', ">= 0.13"
  s.homepage    = 'http://cloudbolt.io'
  s.license     = 'MIT'
end
