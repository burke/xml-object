# top-level shortcuts

desc '=> test:run'
task :default => :'test:run'

task :bench   => :'perf:benchmark'

task :doc     => :'rdoc:generate'
task :rdoc    => :'rdoc:generate'

task :test    => :'test:run'
task :spec    => :'test:run'

task :rcov    => :'test:rcov'

