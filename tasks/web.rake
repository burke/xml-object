desc 'Publish xml-object.rubyforge.org'
task :web => [ :'www:index', :'www:docs', :'www:coverage' ]

namespace :www do
  task :index do

    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object'
    index  = XMLObject::Helper.dir.join('www', 'index.html')

    system(%[ scp #{index} #{host}:#{remote}/index.html ])
  end

  task :docs => :rdoc do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/doc/'
    local  = XMLObject::Helper.dir.join('doc').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end

  task :coverage => :rcov do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/rcov/'
    local  = XMLObject::Helper.dir.join('coverage').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end
end