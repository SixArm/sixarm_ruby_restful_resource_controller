# -*- coding: utf-8 -*-

Gem::Specification.new do |s|

  s.name              = "sixarm_ruby_restful_resource_controller"
  s.summary           = "SixArm Ruby Gem: RESTful resource controller for Ruby On Rails applications"
  s.version           = "1.0.4"
  s.author            = "SixArm"
  s.email             = "sixarm@sixarm.com"
  s.homepage          = "http://sixarm.com/"
  s.signing_key       = '/opt/keys/sixarm/sixarm-rsa-4096-x509-20145314-private.pem'
  s.cert_chain        = ['/opt/keys/sixarm/sixarm-rsa-4096-x509-20150314-public.pem']

  s.platform          = Gem::Platform::RUBY
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.files             = ['README.md','LICENSE.txt','lib/sixarm_ruby_restful_resource_controller.rb']
  s.test_files        = ['test/sixarm_ruby_restful_resource_controller_test.rb']

  s.add_dependency('actionpack', '>=2.2.2')

end
