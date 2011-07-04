Gem::Specification.new do |s|

  s.name              = "sixarm_ruby_restful_resource_controller"
  s.summary           = "SixArm Ruby Gem: RESTful resource controller for Ruby On Rails applications"
  s.version           = "1.0.4"
  s.author            = "SixArm"
  s.email             = "sixarm@sixarm.com"
  s.homepage          = "http://sixarm.com/"
  s.signing_key       = '/home/sixarm/keys/certs/sixarm-rsa1024-x509-private.pem'
  s.cert_chain        = ['/home/sixarm/keys/certs/sixarm-rsa1024-x509-public.pem']

  s.platform          = Gem::Platform::RUBY
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.files             = ['README.rdoc','LICENSE.txt','lib/sixarm_ruby_restful_resource_controller.rb']
  s.test_files        = ['test/sixarm_ruby_restful_resource_controller_test.rb']

  s.add_dependency('actionpack', '>=2.2.2')

end
