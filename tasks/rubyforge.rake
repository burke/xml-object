require 'rubyforge'
require 'rake/contrib/sshpublisher'

namespace :rubyforge do
  desc 'Upload to RubyForge'
  task :release do |t|
    gemspec = eval(File.open("#{PROJECT_DIR}/xml-object.gemspec").read)
    gemfile = "#{gemspec.rubyforge_project}-#{gemspec.version}.gem"

    unless File.exist?("#{PROJECT_DIR}/pkg/#{gemfile}")
      puts "File #{gemfile} not there. Build package first"
      exit(1)
    end

    rf = RubyForge.new
    rf.configure rescue nil
    puts 'Logging in'
    rf.login

    c = rf.userconfig
    c['release_notes'] = gemspec.description
    c['preformatted']  = true

    puts "Releasing #{gemspec.rubyforge_project} v.#{gemspec.version}"
    rf.add_release(
      gemspec.rubyforge_project, gemspec.name, gemspec.version, gemfile)
  end
end
