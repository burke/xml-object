desc 'Release to RubyForge'
task :release => :gem do |t|
  require 'rubyforge'
  require 'rake/contrib/sshpublisher'

  gemspec = eval(File.open("#{PROJECT_DIR}/xml-object.gemspec").read)
  gemfile = "#{gemspec.rubyforge_project}-#{gemspec.version}.gem"
  gemfile = "#{PROJECT_DIR}/#{gemfile}"

  rf = RubyForge.new
  rf.configure rescue nil
  puts 'Logging in...'
  rf.login

  c = rf.userconfig
  c['release_notes'] = gemspec.description
  c['preformatted']  = true

  puts "Releasing #{gemspec.rubyforge_project} #{gemspec.version}"
  rf.add_release(
    gemspec.rubyforge_project, gemspec.name, gemspec.version, gemfile)
end
