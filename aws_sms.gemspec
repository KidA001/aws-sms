# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_sms"
  spec.version       = AwsSms::VERSION
  spec.authors       = ["Brian Vogelgesang"]
  spec.email         = ["KidA001@gmail.com"]

  spec.summary       = "A simple wrapper for sending SMS via AWS SNS"
  spec.description   = ""
  spec.homepage      = "https://github.com/KidA001/aws-sms"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
