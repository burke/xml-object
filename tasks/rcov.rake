namespace :rcov do
  begin
    require 'rcov/rcovtask'
  rescue LoadError
    desc '(Not installed!)'
    task :build do
      puts "Install 'rcov' to get test coverage reports."
    end
  else
    Rcov::RcovTask.new(:build) do |t|
      t.test_files = %w[ test/*_test.rb ]
      t.output_dir = 'coverage'
      t.verbose    = true
      t.rcov_opts  << '-x /Library -x ~/.gem -x /usr --html'
    end
  end
end

task :rcov => :'rcov:build'