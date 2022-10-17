require_relative 'lib/ones/version'

Gem::Specification.new do |s|
  s.name        = "ones-sdk"
  s.version     = Ones::VERSION
  s.authors     = ["Dingn Nan"]
  s.email       = "cod7ce@gmail.com"

  s.summary       = %q{Ones Open API SDKs for ruby}
  s.description   = %q{Ones Open API SDKs for ruby https://docs.partner.ones.cn/zh-CN/}

  s.files       = ["lib/ones.rb"]
  s.homepage    =
    "https://github.com/mycolorway/ones-ruby-sdk"
  s.license       = "MIT"
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'http', '>= 2.2'
  s.add_dependency 'activesupport', '>= 5.0'
  s.add_dependency 'redis'
  s.add_dependency 'retries'

  s.add_development_dependency "bundler", ">= 1.13"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.10"
end
