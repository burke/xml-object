desc 'Publish xml-object.rubyforge.org'
task :web => [ :'www:index', :'www:docs', :'www:coverage' ]

namespace :www do
  task :index do

    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object'
    index  = File.join(PROJECT_DIR, 'www', 'index.html')

    system(%[ scp #{index} #{host}:#{remote}/index.html ])
  end

  task :docs => :rdoc do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/doc/'
    local  = File.join(PROJECT_DIR, 'doc').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end

  task :coverage => :rcov do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/rcov/'
    local  = File.join(PROJECT_DIR, 'coverage').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end
end
