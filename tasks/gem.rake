require 'rake/gempackagetask'

namespace :gem do
  gemspec_file = File.open("#{PROJECT_DIR}/xml-object.gemspec")

  Rake::GemPackageTask.new(eval(gemspec_file.read)) do
  end
end