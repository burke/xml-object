XMLOBJECT_GEMSPEC = Gem::Specification.new do |gem|
  gem.name     = gem.rubyforge_project = 'xml-object'
  gem.homepage = 'http://xml-object.rubyforge.org'

  gem.version, gem.date  = '0.9.91', '2009-06-23'
  gem.author,  gem.email = 'Jordi Bunster', 'jordi@bunster.org'

  gem.summary     = "The Rubyista's way to do quick XML sit-ups"
  gem.description = %{ XMLObject is a library for reading (not writing) XML.
    It is particularly suited for cases where one is dealing with small
    documents of a known structure. While not devoid of caveats, it does
    have a very pleasant, idiomatic Ruby syntax. }.strip!.gsub! /\s+/, ' '

  gem.has_rdoc = !!(gem.extra_rdoc_files = %w[
    README.rdoc MIT-LICENSE WHATSNEW ])

  gem.rdoc_options += %w[
    --title XMLObject --main README.rdoc --inline-source ]

  gem.files = %w[
    MIT-LICENSE
    README.rdoc
    TODO
    WHATSNEW
    lib
    lib/xml-object
    lib/xml-object/adapters
    lib/xml-object/adapters/libxml.rb
    lib/xml-object/adapters/rexml.rb
    lib/xml-object/adapters.rb
    lib/xml-object/collection_proxy.rb
    lib/xml-object/element.rb
    lib/xml-object/properties.rb
    lib/xml-object.rb
    xml-object.gemspec
  ]
end