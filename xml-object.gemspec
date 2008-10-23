Gem::Specification.new do |gem|
  gem.rubyforge_project = 'xml-object'

  gem.name     = 'xml-object'
  gem.homepage = 'http://github.com/jordi/xml-object'

  gem.version, gem.date = '0.9.8', '2008-10-23'
  gem.author, gem.email = 'Jordi Bunster', 'jordi@bunster.org'

  gem.summary     = "The Rubyista's way to do quick XML sit-ups"
  gem.description = %{ XMLObject is a library for reading (not writing) XML.
    It is particularly suited for cases where one is dealing with small
    documents of a known structure. While not devoid of caveats, it does
    have a very pleasant, idiomatic Ruby syntax. }.strip!.gsub! /\s+/, ' '

  gem.files = %w[
    MIT-LICENSE
    README.rdoc
    TODO
    WHATSNEW
    lib
    lib/jordi-xml-object.rb
    lib/xml-object
    lib/xml-object/adapters
    lib/xml-object/adapters/hpricot.rb
    lib/xml-object/adapters/libxml.rb
    lib/xml-object/adapters/rexml.rb
    lib/xml-object/adapters.rb
    lib/xml-object/array_notation.rb
    lib/xml-object/collection_proxy.rb
    lib/xml-object/element.rb
    lib/xml-object/method_missing_dispatchers.rb
    lib/xml-object.rb
    xml-object.gemspec
  ]

  gem.has_rdoc = !!(gem.extra_rdoc_files = %w[ README.rdoc ])
  gem.rdoc_options << '--title' << 'XMLObject'   <<
                      '--main'  << 'README.rdoc' <<
                      '--inline-source'
end