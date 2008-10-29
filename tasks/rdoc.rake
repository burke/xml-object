desc 'Generate documentation using RDoc'
task :rdoc do
  hanna = File.join(PROJECT_DIR, 'vendor', 'hanna', 'bin', 'hanna')

  options = %{ --inline-source
               --main=README.rdoc
               --title="XMLObject"
               README.rdoc
               lib/xml-object.rb
               lib/xml-object/*.rb
               lib/xml-object/adapters/*.rb }.strip!.gsub! /\s+/, ' '

  rm_rf File.join(PROJECT_DIR, 'doc')
  system "#{hanna} #{options}"
end
