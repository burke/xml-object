Gem::Specification.new do |s|
  s.name        = 'xml_struct'
  s.version     = '0.1.2'
  s.date        = '2008-10-09'

  s.author      = 'Jordi Bunster'
  s.email       = 'jordi@bunster.org'
  s.homepage    = 'http://github.com/jordi/xml_struct'

  s.add_dependency 'activesupport', '>= 2.1.1'

  s.summary     = "The Rubyista's way to do quick XML sit-ups"
  s.description = %{ This is a library for reading (not writing) XML. It is
                     particularly suited for cases where one is dealing with
                     small documents of a known structure.

                     It is slow and not devoid of caveats, but has a very
                     pleasant, Ruby-like syntax. }.strip!.gsub! /\s+/, ' '

  s.test_files  = %w[ test
                      test/samples
                      test/samples/lorem.xml
                      test/test_helper.rb
                      test/xml_struct_test.rb ]

  s.files       = %w[ MIT-LICENSE
                      README.markdown
                      Rakefile
                      WHATSNEW
                      TODO
                      lib
                      lib/jordi-xml_struct.rb
                      lib/xml_struct.rb
                      xml_struct.gemspec ]

  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.markdown        ]
  s.rdoc_options     = %w[ --main README.markdown ]
end