Gem::Specification.new do |gem|
  gem.add_dependency 'activesupport'

  gem.name    = 'xml-object'
  gem.version = '0.9.5'
  gem.date    = '2008-10-15'

  gem.author   = 'Jordi Bunster'
  gem.email    = 'jordi@bunster.org'
  gem.homepage = 'http://github.com/jordi/xml-object'

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
    lib/xml-object/adapters/rexml.rb
    lib/xml-object/array_notation.rb
    lib/xml-object/blankish_slate.rb
    lib/xml-object/collection_proxy.rb
    lib/xml-object/default_adapter.rb
    lib/xml-object/method_missing_dispatchers.rb
    lib/xml-object/string.rb
    lib/xml-object.rb
    xml-object.gemspec
  ]

  gem.has_rdoc     = true
  gem.rdoc_options = [ '--inline-source', '--main README.rdoc',
    '--title "XMLObject"', 'README.rdoc', 'lib/xml-object.rb',
    'lib/xml-object/*.rb', 'lib/xml-object/adapters/*.rb' ]
end