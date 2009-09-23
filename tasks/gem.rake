gemspec  = XMLObject::Helper.dir.join('xml-object.gemspec')
gem_obj  = eval(File.open(gemspec).read)
gem_file = "#{gem_obj.rubyforge_project}-#{gem_obj.version}.gem"

desc "Builds #{gem_file}"
task :gem do
  rm_f gem_file
  system "gem build #{gemspec}"
end