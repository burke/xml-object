desc 'Release to RubyForge'
task :release => :gem do |t|
  require 'rubyforge'
  require 'rake/contrib/sshpublisher'

  gemspec = XMLObject::Helper.dir.join('xml-object.gemspec')
  gemspec = eval(File.open(gemspec).read)

  gemfile = "#{gemspec.rubyforge_project}-#{gemspec.version}.gem"
  gemfile = XMLObject::Helper.dir.join(gemfile)

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