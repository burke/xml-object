namespace :www do

  desc 'Copy www/index.html to Rubyforge'
  task :copy_index do

    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object'
    index  = File.join(PROJECT_DIR, 'www', 'index.html')

    system(%[ scp #{index} #{host}:#{remote}/index.html ])
  end
end

desc 'Publish the complete website to RubyForge'
task :'www:publish' =>
  [ :'www:copy_index', :'test:publish', :'rdoc:publish' ]
