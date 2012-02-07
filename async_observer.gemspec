$:.push File.dirname(__FILE__) + '/lib'
require 'async_observer/version'

Gem::Specification.new do |gem|
  gem.name = %q{async_observer}
  gem.authors = ["Keith Rarick", "rewritten"]
  gem.description = %q{A Rails plugin that provides deep integration with Beanstalk.}
  gem.summary = %q{Rails queue client for beanstalkd}
  gem.email = ['kr@xph.us', 'saverio@ftopia.com']
  gem.homepage = 'https://github.com/rewritten/async_observer'
  
  gem.add_runtime_dependency 'rails', '~> 2.3.5'
  gem.add_runtime_dependency 'beanstalk-client','~> 1.1.1'
  gem.add_development_dependency 'beanstalk-client','~> 1.1.1'
  gem.add_development_dependency 'rails', '~> 2.3.5'
  gem.add_development_dependency 'rspec-rails', '~> 1.3'
  gem.add_development_dependency 'sqlite3'

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.version = AsyncObserver::VERSION

end
