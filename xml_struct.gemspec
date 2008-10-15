Gem::Specification.new do |s|
  s.name        = 'xml_struct'
  s.version     = '0.9.0'
  s.date        = '2008-10-13'

  s.author      = 'Jordi Bunster'
  s.email       = 'jordi@bunster.org'
  s.homepage    = 'http://github.com/jordi/xml_struct'

  s.add_dependency 'activesupport'

  s.summary     = "The Rubyista's way to do quick XML sit-ups"
  s.description = %{ This is a library for reading (not writing) XML. It is
                     particularly suited for cases where one is dealing with
                     small documents of a known structure.

                     It is slow and not devoid of caveats, but has a very
                     pleasant, Ruby-like syntax. }.strip!.gsub! /\s+/, ' '

  s.files = %w[ MIT-LICENSE
                README.rdoc
                TODO
                WHATSNEW
                lib
                lib/jordi-xml_struct.rb
                lib/xml_struct
                lib/xml_struct/adapters
                lib/xml_struct/adapters/hpricot.rb
                lib/xml_struct/adapters/rexml.rb
                lib/xml_struct/array_notation.rb
                lib/xml_struct/blankish_slate.rb
                lib/xml_struct/collection_proxy.rb
                lib/xml_struct/default_adapter.rb
                lib/xml_struct/method_missing_dispatchers.rb
                lib/xml_struct/string.rb
                lib/xml_struct.rb
                xml_struct.gemspec ]
end