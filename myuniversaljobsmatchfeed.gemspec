Gem::Specification.new do |s|
  s.name = 'myuniversaljobsmatchfeed'
  s.version = '0.1.0'
  s.summary = 'Generates an RSS feed for the search results from the myuniversaljobsmatch gem'
  s.authors = ['James Robertson']
  s.files = Dir['lib/myuniversaljobsmatchfeed.rb']
  s.add_runtime_dependency('myuniversaljobsmatch', '~> 0.1', '>=0.1.5')
  s.add_runtime_dependency('daily_notices', '~> 0.3', '>=0.3.0')  
  s.signing_key = '../privatekeys/myuniversaljobsmatchfeed.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/myuniversaljobsmatchfeed'
end
