# top-level shortcuts

desc '=> test:run'
task :default => :'test:XMLObject'

task :bench   => :'perf:benchmark'

task :doc     => :'rdoc:generate'
task :rdoc    => :'rdoc:generate'

task :test    => :'test:XMLObject'
task :spec    => :'test:XMLObject'

task :rcov    => :'test:rcov'

