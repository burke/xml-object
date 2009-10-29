namespace :rdoc do
  begin
    begin
      require 'sdoc'
    rescue LoadError
      nil
    ensure
      require 'rake'
      require 'rake/rdoctask'
    end
  rescue LoadError
    desc '(Not installed!)'
    task :build do
      puts "Install 'rdoc' to generate documentation."
    end
  else
    Rake::RDocTask.new(:build) do |rdoc|
      rdoc.rdoc_files.include(
        'README.rdoc', 'MIT-LICENSE', 'WHATSNEW', 'lib/**/*.rb')

      rdoc.main     = 'README.rdoc'
      rdoc.title    = 'XMLObject'
      rdoc.rdoc_dir = 'doc'
    end
  end
end

task :rdoc => :'rdoc:build'