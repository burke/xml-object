gemspec  = "#{PROJECT_DIR}/xml-object.gemspec"
gem      = eval(File.open(gemspec).read)
gem_file = "#{gem.rubyforge_project}-#{gem.version}.gem"

desc "Builds #{gem_file}"
task :gem do
  rm_f gem_file
  system "gem build #{gemspec}"
end
