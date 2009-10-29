require 'lib/xml-object/version'

Gem::Specification.new do |gem|
  gem.name    = 'xml-object'
  gem.version = XMLObject::VERSION
  gem.date    = Date.today

  gem.author, gem.email = 'Jordi Bunster', 'jordi@bunster.org'

  gem.summary     = "The Rubyista's way to do quick XML sit-ups"
  gem.description = %{ XMLObject is a library for reading (not writing) XML.
    It is particularly suited for cases where one is dealing with small
    documents of a known structure. While not devoid of caveats, it does
    have a very pleasant, idiomatic Ruby syntax. }.strip!.gsub! /\s+/, ' '

  gem.has_rdoc         = true
  gem.extra_rdoc_files = %w[ README.rdoc MIT-LICENSE WHATSNEW ]

  gem.rdoc_options +=
    %w[ --title XMLObject --main README.rdoc --inline-source ]

  gem.test_files = Dir.glob('test/*.rb').collect { |p| p.to_s }
  gem.files      = %w[
    MIT-LICENSE
    README.rdoc
    TODO
    WHATSNEW
    lib
    lib/xml-object
    lib/xml-object/version.rb
    lib/xml-object/adapters
    lib/xml-object/adapters/libxml.rb
    lib/xml-object/adapters/rexml.rb
    lib/xml-object/adapters.rb
    lib/xml-object/collection_proxy.rb
    lib/xml-object/element.rb
    lib/xml-object/properties.rb
    lib/xml-object.rb
    xml-object.gemspec
  ] + gem.test_files
end