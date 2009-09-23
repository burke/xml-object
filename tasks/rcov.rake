desc 'Measure test coverage using rcov'
task :rcov do
  output_path = XMLObject::Helper.dir.join('coverage')
  excludes    = %w[ /Library/Ruby project_helper.rb ].join(',')
  includes    = XMLObject::Helper.dir.join

  rm_rf output_path

  rcov       = "rcov -o #{output_path} -x #{excludes} -I #{includes}"
  test_glob  = XMLObject::Helper.dir.join('test', '*_test.rb')
  test_files = Dir[test_glob].join(' ')

  system "#{rcov} -T #{test_files}"
end