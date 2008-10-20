namespace :rdoc do
  desc 'Publish RDoc to RubyForge'
  task :publish => :generate do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/doc/'
    local  = File.join(PROJECT_DIR, 'doc').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end

  desc 'Generate RDoc'
  task :generate do
    hanna = File.join(PROJECT_DIR, 'test', 'vendor', 'hanna', 'bin', 'hanna')

    options = %{ --inline-source
                 --main=README.rdoc
                 --title="XMLObject"
                 README.rdoc
                 lib/xml-object.rb
                 lib/xml-object/*.rb
                 lib/xml-object/adapters/*.rb }.strip!.gsub! /\s+/, ' '

    system "#{hanna} #{options}"
  end

  desc 'Delete generated RDoc'
  task :destroy do
    rm_rf File.join(PROJECT_DIR, 'doc/')
  end
end
