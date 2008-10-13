Gem::Specification.new do |s|
  s.name        = 'xml_struct'
  s.version     = '0.2.1'
  s.date        = '2008-10-13'

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
                      test/samples/recipe.xml
                      test/samples/weird_characters.xml
                      test/test_helper.rb
                      test/vendor
                      test/vendor/test-spec
                      test/vendor/test-spec/bin
                      test/vendor/test-spec/bin/specrb
                      test/vendor/test-spec/examples
                      test/vendor/test-spec/examples/stack.rb
                      test/vendor/test-spec/examples/stack_spec.rb
                      test/vendor/test-spec/lib
                      test/vendor/test-spec/lib/test
                      test/vendor/test-spec/lib/test/spec
                      test/vendor/test-spec/lib/test/spec/dox.rb
                      test/vendor/test-spec/lib/test/spec/rdox.rb
                      test/vendor/test-spec/lib/test/spec/should-output.rb
                      test/vendor/test-spec/lib/test/spec/version.rb
                      test/vendor/test-spec/lib/test/spec.rb
                      test/vendor/test-spec/Rakefile
                      test/vendor/test-spec/README
                      test/vendor/test-spec/ROADMAP
                      test/vendor/test-spec/SPECS
                      test/vendor/test-spec/test
                      test/vendor/test-spec/test/spec_dox.rb
                      test/vendor/test-spec/test/spec_flexmock.rb
                      test/vendor/test-spec/test/spec_mocha.rb
                      test/vendor/test-spec/test/spec_nestedcontexts.rb
                      test/vendor/test-spec/test/spec_new_style.rb
                      test/vendor/test-spec/test/spec_should-output.rb
                      test/vendor/test-spec/test/spec_testspec.rb
                      test/vendor/test-spec/test/spec_testspec_order.rb
                      test/vendor/test-spec/test/test_testunit.rb
                      test/vendor/test-spec/TODO
                      test/xml_struct_test.rb ]

  s.files = %w[ MIT-LICENSE
                README.markdown
                Rakefile
                TODO
                WHATSNEW
                lib
                lib/jordi-xml_struct.rb
                lib/xml_struct
                lib/xml_struct/blankish_slate.rb
                lib/xml_struct/collection_proxy.rb
                lib/xml_struct/common_behaviours.rb
                lib/xml_struct/string.rb
                lib/xml_struct.rb ]

  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README.markdown        ]
  s.rdoc_options     = %w[ --main README.markdown ]
end