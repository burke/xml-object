desc 'Measure test coverage using rcov'
task :rcov do
  output_path = "#{PROJECT_DIR}/test/coverage"
  excludes    = [ '/Library/Ruby' ].join(' ')
  includes    = [ "#{PROJECT_DIR}/lib" ].join(' ')

  rm_rf output_path

  rcov = "rcov -o #{output_path} -I #{includes} -x #{excludes}"
  sh "#{rcov} -T #{Dir["#{PROJECT_DIR}/test/*_test.rb"].join(' ')}"
end