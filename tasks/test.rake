require 'rake/testtask'

namespace :test do
  Rake::TestTask.new('XMLObject') do |t|
    t.libs << 'test'
    t.options    = '--runner=specdox'
    t.test_files = FileList["#{PROJECT_DIR}/test/*_test.rb"]
    t.verbose    = true
  end

  desc 'Reports test coverage'
  task :rcov do
    output_path = "#{PROJECT_DIR}/test/coverage"
    excludes    = [ '/Library/Ruby' ].join(' ')
    includes    = [ "#{PROJECT_DIR}/lib" ].join(' ')

    rm_rf output_path

    rcov = "rcov -o #{output_path} -I #{includes} -x #{excludes}"
    sh "#{rcov} -T #{Dir["#{PROJECT_DIR}/test/*_test.rb"].join(' ')}"
  end

  desc 'Publish test coverage to RubyForge'
  task :publish => :rcov do
    host   = 'jordi@xml-object.rubyforge.org'
    remote = '/var/www/gforge-projects/xml-object/rcov/'
    local  = File.join(PROJECT_DIR, 'test', 'coverage').chomp('/') + '/*'

    system(%[ rsync -e 'ssh' -r --delete #{local} #{host}:#{remote}])
  end
end
