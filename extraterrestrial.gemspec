require File.join(
  [File.dirname(__FILE__), "lib", "extraterrestrial", "version.rb"])
Gem::Specification.new do |s|
  s.name = "extraterrestrial"
  s.version = Extraterrestrial::VERSION
  s.author = "Adam Sheehan"
  s.email = "adam.sheehan@launchacademy.com"
  s.homepage = "http://www.launchacademy.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "Command-line interface for the event horizon."
  s.description = <<-DESC
Users can download challenges and submit their solutions via the command-line
interface.
DESC

  s.files = `git ls-files`.split("\n")
  s.require_paths << "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "extraterrestrial.rdoc"]
  s.rdoc_options << "--title" << "extraterrestrial" <<
    "--main" << "README.rdoc" << "-ri"
  s.bindir = "bin"
  s.executables << "et"
  s.license = "MIT"
  s.add_development_dependency("rake", "~> 10.3")
  s.add_development_dependency("rdoc", "~> 4.1")
  s.add_runtime_dependency("gli", "2.11.0")
end
