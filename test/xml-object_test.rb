require File.dirname(__FILE__) + '/test_helper'

module XMLObjectAdapterBehavior
  def test_whitespace_stripping_of_attribute_values
    dude = XMLObject.new %'<dude name=" \n bob \t" />'
    assert_equal 'bob', dude.name
  end

  def test_for_invalid_keys_when_using_hash_on_array_notation
    assert_raise(NameError) do
      foo = XMLObject.new '<foo><bar /></foo>'
      foo[:not_a_valid_key => 'whatever']
    end
  end

  def test_object_without_attributes_text_or_cdata
    rock = XMLObject.new '<rock><color> </color> <mass /></rock>'
    assert_equal '', rock

    assert_raise(NameError) { rock.not_an_attribute_or_element    }
    assert_raise(NameError) { rock['not_an_attribute_or_element'] }
    assert_raise(NameError) { rock[:elem => 'not_an_element']     }
    assert_raise(NameError) { rock[:attr => 'not_an_attribute']   }
  end

  def test_object_with_child_element
    car = XMLObject.new '<car><wheels>4</wheels></car>'

    assert_equal '4', car.wheels
    assert_equal '4', car['wheels']
    assert_equal '4', car[:wheels]
    assert_equal '4', car[:elem  => 'wheels']
    assert_equal '4', car[:elem  => :wheels]
    assert_equal '4', car['elem' => 'wheels']
    assert_equal '4', car['elem' => :wheels]
  end

  def test_object_with_attribute
    student = XMLObject.new '<student name="Carla" />'

    assert_equal 'Carla', student.name
    assert_equal 'Carla', student['name']
    assert_equal 'Carla', student[:name]
    assert_equal 'Carla', student[:attr  => 'name']
    assert_equal 'Carla', student[:attr  => :name]
    assert_equal 'Carla', student['attr' => 'name']
    assert_equal 'Carla', student['attr' => :name]
  end

  def test_array_auto_folding
    herd = XMLObject.new('<herd><sheep></sheep><sheep></sheep></herd>')
    assert_instance_of Array, herd.sheep
  end

  def test_collection_proxy
    flock = XMLObject.new %| <flock>
                               <sheep number="0">?</sheep>
                               <sheep number="1">Dolly</sheep>
                             </flock> |

    # Empty elements with single array children act as proxies to the array
    assert_equal flock,       flock.sheep
    assert_equal flock.first, flock.sheep.first

    assert_equal '0', flock.first.number
    assert_equal '0', flock.sheep.first.number

    assert_equal 2, flock.size
    assert_equal 2, flock.sheep.size
  end

  def test_NOT_collection_proxy_due_to_text
    mob = XMLObject.new %| <mob>Some text about the mob
                             <sheep number="0">?</sheep>
                             <sheep number="1">Dolly</sheep>
                           </mob> |

    assert_instance_of String, mob
    assert_equal 'Some text about the mob', mob.strip

    assert_instance_of Array, mob.sheep
  end

  def test_NOT_collection_proxy_due_to_CDATA
    drove = XMLObject.new %| <drove><![CDATA[Sheep groups have many names]]>
                               <sheep number="0">?</sheep>
                               <sheep number="1">Dolly</sheep>
                             </drove> |

    assert_instance_of String, drove
    assert_equal 'Sheep groups have many names', drove

    assert_instance_of Array, drove.sheep
  end

  def test_NOT_collection_proxy_due_to_non_array_single_child
    trip = XMLObject.new '<trip><sheep number="1">Dolly</sheep></trip>'
    assert_not_equal trip, trip.sheep
  end

  def test_boolean_like_attributes
    house = XMLObject.new %| <house tall="Yes"   short="no"
                                    cubeish="y"  roundish="N"
                                    heavy="T"    light="f"
                                    house="tRUE" ball="fAlSE"
                                    hypercube="What?" /> |

    assert house.tall?
    assert house.cubeish?
    assert house.heavy?
    assert house.house?

    assert !house.short?
    assert !house.roundish?
    assert !house.light?
    assert !house.ball?

    assert_raise(NameError) { house.hypercube? }
  end

  def test_boolean_like_elements
    house = XMLObject.new %| <house>
                               <tall>yEs</tall>     <short>nO</short>
                               <cubeish>Y</cubeish> <roundish>n</roundish>
                               <heavy>t</heavy>     <light>F</light>
                               <house>tRue</house>  <ball>FalsE</ball>

                               <hypercube>the hell?</hypercube>
                             </house> |

    assert house.tall?
    assert house.cubeish?
    assert house.heavy?
    assert house.house?

    assert !house.short?
    assert !house.roundish?
    assert !house.light?
    assert !house.ball?

    assert_raise(NameError) { house.hypercube? }
  end

  def test_multiple_CDATA_blocks
    lots_of_data = XMLObject.new %| <lots_of_data>
                                      <![CDATA[Lots of CDA]]>
                                      <![CDATA[TA! here, man]]>
                                    </lots_of_data> |

    assert_equal 'Lots of CDATA! here, man', lots_of_data
  end

  def test_CDATA_without_text
    no_text = XMLObject.new '<no_text><![CDATA[Not Text, CDATA]]></no_text>'
    assert_equal 'Not Text, CDATA', no_text
  end

  def test_both_CDATA_and_text
    two_face = XMLObject.new '<two_face>Text<![CDATA[Not Text]]></two_face>'
    assert_equal 'Text', two_face
  end

  def test_whitespace_text_only
    not_much = XMLObject.new "<not_much>\t \n </not_much>"
    assert_equal '', not_much
  end

  def test_whitespace_and_non_whitespace_text
    sloppy = XMLObject.new "<sloppy>\t a \n</sloppy>"
    assert_equal "\t a \n", sloppy
  end

  def test_whitespace_CDATA_only
    not_much = XMLObject.new "<not_much><![CDATA[\t \n]]></not_much>"
    assert_equal "\t \n", not_much
  end

  def test_whitespace_and_non_whitespace_CDATA
    sloppy = XMLObject.new "<x><![CDATA[\t a \n]]></x>"
    assert_equal "\t a \n", sloppy
  end

  def test_ambiguity_of_element_and_attribute_name
    toy = XMLObject.new %'<toy name="name attribute value">
                            <name>name as element text</name>
                          </toy>'

    assert_equal 'name as element text', toy.name
    assert_equal 'name as element text', toy['name']

    assert_equal 'name as element text', toy[:elem => 'name']
    assert_equal 'name attribute value', toy[:attr => 'name']
  end

  def test_ambiguity_of_s_pluralized_array_and_element_name
    kennel = XMLObject.new %| <kennel>
                                <dogs>Bruce, Muni, Charlie</dogs>
                                <dog>Rex</dog>
                                <dog>Roxy</dog>
                              </kennel> |

    assert_equal 'Bruce, Muni, Charlie', kennel['dogs']
    assert_equal 'Bruce, Muni, Charlie', kennel[:elem => 'dogs']
    assert_equal 'Bruce, Muni, Charlie', kennel.dogs

    # We still maintain access to the array by its original name:
    assert_equal 'Rex & Roxy', kennel.dog.join(' & ')
    assert_equal 'Rex & Roxy', kennel['dog'].join(' & ')
    assert_equal 'Rex & Roxy', kennel[:elem => 'dog'].join(' & ')
  end

  def test_ambiguity_of_inflector_pluralized_array_and_element_name
    aquarium = XMLObject.new %| <aquarium>
                                  <octopi>Mean, Ugly, Scary</octopi>
                                  <octopus>Tasty</octopus>
                                  <octopus>Chewy</octopus>
                                </aquarium> |

    assert_equal 'Mean, Ugly, Scary', aquarium['octopi']
    assert_equal 'Mean, Ugly, Scary', aquarium[:elem => 'octopi']
    assert_equal 'Mean, Ugly, Scary', aquarium.octopi

    # We still maintain access to the array by its original name:
    assert_equal 'Tasty & Chewy', aquarium.octopus.join(' & ')
    assert_equal 'Tasty & Chewy', aquarium['octopus'].join(' & ')
    assert_equal 'Tasty & Chewy', aquarium[:elem => 'octopus'].join(' & ')
  end

  def test_ambiguity_of_s_pluralized_array_and_attribute_name
    book = XMLObject.new %|
      <book chapters="2">
        <chapter>Introduction</chapter>
        <chapter>Some stuff</chapter>
        <chapter>More stuff</chapter>
      </book> |

    assert_equal '2', book.chapters
    assert_equal '2', book['chapters']
    assert_equal '2', book[:attr => 'chapters']

    assert_instance_of Array, book.chapter
    assert_instance_of Array, book['chapter']
    assert_instance_of Array, book[:elem => 'chapter']
  end

  def test_ambiguity_of_inflector_pluralized_array_and_attribute_name
    dog = XMLObject.new %|
      <dog feet="4">
        <foot>A</foot>
        <foot>B</foot>
        <foot>C</foot>
        <foot>D</foot>
      </dog> |

    assert_equal '4', dog.feet
    assert_equal '4', dog['feet']
    assert_equal '4', dog[:attr => 'feet']

    assert_instance_of Array, dog.foot
    assert_instance_of Array, dog['foot']
    assert_instance_of Array, dog[:elem => 'foot']
  end

  def test_ambiguity_of_pluralized_array_and_attribute_and_element_name
    file = XMLObject.new %|
      <file bits="bits attribute">
        <bits>bits element</bits>
        <bit>0</bit>
        <bit>1</bit>
      </file> |

    # prioritize the element over all others
    assert_equal 'bits element', file.bits
    assert_equal 'bits element', file['bits']

    # allow respective unambiguous access
    assert_equal 'bits element',   file[:elem => 'bits']
    assert_equal 'bits attribute', file[:attr => 'bits']

    # to the Array as well
    assert_instance_of Array, file.bit
    assert_instance_of Array, file['bit']
    assert_instance_of Array, file[:elem => 'bit']
  end

  def test_ambiguity_of_attribute_and_method_name
    string = XMLObject.new '<string upcase="upcase attribute">hello</string>'
    assert_equal 'hello', string
    assert_equal 'HELLO', string.upcase

    assert_equal 'upcase attribute', string['upcase']
    assert_equal 'upcase attribute', string[:attr => 'upcase']
  end

  def test_ambiguity_of_element_and_method_name
    string = XMLObject.new '<string><upcase>Hi There</upcase></string>'
    assert_equal '', string
    assert_equal '', string.upcase

    assert_equal 'Hi There', string['upcase']
    assert_equal 'Hi There', string[:elem => 'upcase']
  end

  def test_elements_named_like_invalid_ruby_method_names
    x = XMLObject.new '<x><invalid-method>XML!</invalid-method></x>'
    assert_equal 'XML!', x['invalid-method']
  end

  def test_attributes_named_like_invalid_ruby_method_names
    x = XMLObject.new '<x attr-with-dashes="XML too!" />'
    assert_equal 'XML too!', x['attr-with-dashes']
  end

  def test_behavior_of_auto_folded_array
    chart = XMLObject.new '<chart><axis>y</axis><axis>x</axis></chart>'

    assert_equal 'y', chart.axis[0]
    assert_equal 'y', chart.axis.first

    assert_equal 'x', chart.axis[1]
    assert_equal 'x', chart.axis.last

    assert_equal chart.axis, chart.axiss # 's' plural (naïve)
    assert_equal chart.axis, chart.axes if defined?(ActiveSupport::Inflector)
  end

  def test_behaviour_of_collection_proxy
    two = XMLObject.new '<two><dude>Peter</dude><dude>Paul</dude></two>'

    assert_equal two.dudes, two
    assert_equal two.dudes[-1], two[-1]
    assert_equal two.dudes.first.downcase, two.first.downcase
    assert_equal two.dudes.map { |d| d.upcase }, two.map { |d| d.upcase }
  end

  def test_construction_from_strings
    assert_equal 'bar', XMLObject.new('<foo>bar</foo>')
  end

  def test_construction_from_something_that_responds_to_to_s
    duck = Class.new.new
    duck.class.instance_eval { undef_method :read } if duck.respond_to? :read

    def duck.to_s
      '<foo>bar</foo>'
    end

    assert_equal 'bar', XMLObject.new(duck)
  end

  def test_construction_from_something_that_responds_to_read
    duck = Class.new.new
    duck.class.instance_eval { undef_method :to_s } if duck.respond_to? :to_s

    def duck.read
      '<foo>bar</foo>'
    end

    assert_equal 'bar', XMLObject.new(duck)
  end

  def test_raise_exception_from_duck_that_responds_to_neither_to_s_or_read
    duck = Class.new.new
    duck.class.instance_eval { undef_method :read } if duck.respond_to? :read
    duck.class.instance_eval { undef_method :to_s } if duck.respond_to? :to_s

    assert_raise(RuntimeError) { XMLObject.new(duck) }
  end

  def test_behaviour_of_sample_atom_dot_xml
    feed = XMLObject.new %'<?xml version="1.0" encoding="utf-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom">

       <title>Example Feed</title>
       <subtitle>A subtitle.</subtitle>
       <link href="http://example.org/feed/" rel="self"/>
       <link href="http://example.org/"/>
       <updated>2003-12-13T18:30:02Z</updated>
       <author>
         <name>John Doe</name>
         <email>johndoe@example.com</email>
       </author>
       <id>urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6</id>

       <entry>
         <title>Atom-Powered Robots Run Amok</title>
         <link href="http://example.org/2003/12/13/atom03"/>
         <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
         <updated>2003-12-13T18:30:02Z</updated>
         <summary>Some text.</summary>
       </entry>
      </feed>'

    assert_equal '', feed

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://www.w3.org/2005/Atom', feed.xmlns
    end

    assert_equal 'Example Feed', feed.title
    assert_equal 'A subtitle.',  feed.subtitle

    assert_instance_of Array, feed.link
    assert_equal       feed.links, feed.link

    assert_equal 'http://example.org/feed/', feed.link.first.href
    assert_equal 'self',                     feed.link.first.rel
    assert_equal 'http://example.org/',      feed.link.last.href

    assert_equal '2003-12-13T18:30:02Z', feed.updated

    assert_equal '',                    feed.author
    assert_equal 'John Doe',            feed.author.name
    assert_equal 'johndoe@example.com', feed.author.email

    assert_equal 'urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6', feed['id']

    assert_equal '', feed.entry
    assert_equal 'Atom-Powered Robots Run Amok', feed.entry.title
    assert_equal '2003-12-13T18:30:02Z',         feed.entry.updated
    assert_equal 'Some text.',                   feed.entry.summary
    assert_equal \
      'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a', feed.entry['id']
  end

  def test_behaviour_of_sample_function_dot_xml
    function = XMLObject.new \
      %'<function name="Hello">
          <description>Greets the indicated person.</description>
          <input>
            <param name="name" required="true">
              <description>The name of the greeted person.</description>
            </param>
          </input>
          <output>
            <param name="greeting" required="true">
              <description>The constructed greeting.</description>
            </param>
          </output>
        </function>'

    assert_equal '', function
    assert_equal 'Hello', function.name
    assert_equal 'Greets the indicated person.', function.description

    assert_equal '', function.input
    assert_equal '', function.input.param
    assert_equal 'name', function.input.param.name
    assert_equal 'true', function.input.param.required
    assert       function.input.param.required?
    assert_equal 'The name of the greeted person.',
                 function.input.param.description

    assert_equal '', function.output
    assert_equal '', function.output
    assert_equal 'greeting', function.output.param.name
    assert_equal 'true', function.output.param.required
    assert       function.output.param.required?
    assert_equal 'The constructed greeting.',
                 function.output.param.description
  end

  def test_behaviour_of_sample_persons_dot_xml
    persons = XMLObject.new %'<?xml version="1.0" ?>
                              <persons>
                                <person username="JS1">
                                  <name>John</name>
                                  <family-name>Smith</family-name>
                                </person>
                                <person username="MI1">
                                  <name>Morka</name>
                                  <family-name>Ismincius</family-name>
                                </person>
                              </persons>'

    assert_equal [ '', '' ],      persons
    assert_equal persons.person,  persons
    assert_equal persons.persons, persons

    if defined? ActiveSupport::Inflector
      assert_equal persons.people, persons
    end

    assert_equal '', persons[0]
    assert_equal '', persons[-1]

    assert_equal 'JS1',   persons.first.username
    assert_equal 'John',  persons.first.name
    assert_equal 'Smith', persons.first['family-name']

    assert_equal 'MI1',       persons.last.username
    assert_equal 'Morka',     persons.last.name
    assert_equal 'Ismincius', persons.last[:'family-name']
  end

  def test_behaviour_of_sample_playlist_dot_xml
    playlist = XMLObject.new %'<?xml version="1.0" encoding="UTF-8"?>
      <playlist version="1" xmlns="http://xspf.org/ns/0/">
        <trackList>
          <track>
            <title>Internal Example</title>
            <location>file:///C:/music/foo.mp3</location>
          </track>
          <track>
            <title>External Example</title>
            <location>http://www.example.com/music/bar.ogg</location>
          </track>
        </trackList>
      </playlist>'

    assert_equal '',  playlist
    assert_equal '1', playlist.version

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://xspf.org/ns/0/', playlist.xmlns
    end

    # can't use 'assert_instance_of' here, not yet anyway.
    assert_equal Array, playlist.trackList.class

    assert_instance_of Array, playlist.trackList.track
    assert_instance_of Array, playlist.trackList.tracks

    assert_equal playlist.trackList.track,  playlist.trackList
    assert_equal playlist.trackList.tracks, playlist.trackList

    assert_equal playlist.trackList, playlist.trackList.track

    assert_equal 'Internal Example',         playlist.trackList.first.title
    assert_equal 'file:///C:/music/foo.mp3', playlist.trackList.first.location

    assert_equal 'External Example', playlist.trackList.last.title
    assert_equal 'http://www.example.com/music/bar.ogg',
                 playlist.trackList.last.location
  end

  def test_behaviour_of_sample_recipe_dot_xml
    recipe = XMLObject.new \
      %'<recipe name="bread" prep_time="5 mins" cook_time="3 hours">
          <title>Basic bread</title>
          <ingredient amount="8" unit="dL">Flour</ingredient>
          <ingredient amount="10" unit="grams">Yeast</ingredient>
          <ingredient amount="4" unit="dL" state="warm">Water</ingredient>
          <ingredient amount="1" unit="teaspoon">Salt</ingredient>
          <instructions>
            <step>Mix all ingredients together.</step>
            <step>Knead thoroughly.</step>
            <step>Cover with a cloth, and leave for one hour.</step>
            <step>Knead again.</step>
            <step>Place in a bread baking tin.</step>
            <step>Cover with a cloth, and leave for one hour.</step>
            <step>Bake in the oven at 180(degrees)C for 30 minutes.</step>
          </instructions>
        </recipe>'

    assert_equal '',            recipe
    assert_equal 'bread',       recipe.name
    assert_equal '5 mins',      recipe.prep_time
    assert_equal '3 hours',     recipe.cook_time
    assert_equal 'Basic bread', recipe.title

    assert_instance_of Array, recipe.ingredient
    assert_equal recipe.ingredient, recipe.ingredients
    assert_equal %w[ Flour Yeast Water Salt ], recipe.ingredients
    assert_equal %w[ 8 10 4 1 ], recipe.ingredients.map { |i| i.amount }
    assert_equal 'warm', recipe.ingredients[2].state
    assert_equal %w[ dL grams dL teaspoon ],
                 recipe.ingredients.map { |i| i.unit }

    # can't use instance_of? here
    assert_equal Array, recipe.instructions.class

    assert_instance_of Array, recipe.instructions.step
    assert_instance_of Array, recipe.instructions.steps

    assert_equal recipe.instructions.steps, recipe.instructions
    assert_equal recipe.instructions.steps, recipe.instructions.step

    assert_equal 'Mix, Knead, Cover, Knead, Place, Cover, Bake',
                 recipe.instructions.map { |s| s.split(' ')[0] }.join(', ')
  end

  def test_behaviour_of_sample_voice_dot_xml
    voice = XMLObject.new \
      %'<vxml version="2.0" xmlns="http://www.w3.org/2001/vxml">
          <form>
            <block>
              <prompt>
                Hello world!
              </prompt>
            </block>
          </form>
        </vxml>'

    assert_equal '',    voice
    assert_equal '2.0', voice.version

    # LibXML eats up 'xmlns' from the attributes hash
    unless XMLObject.adapter.to_s.match 'LibXML'
      assert_equal 'http://www.w3.org/2001/vxml', voice.xmlns
    end

    assert_equal '', voice.form
    assert_equal '', voice.form.block
    assert_equal 'Hello world!', voice.form.block.prompt.strip
  end

  def test_behaviour_of_bug_sample_rating_dot_xml
    rating = XMLObject.new %'<rating>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                               <category>
                                 <property/>
                                 <property/>
                                 <property/>
                               </category>
                             </rating>'

    # can't use instance_of? here
    assert_equal Array, rating.class

    assert_equal 3, rating.size
    assert_equal 3, rating.category.size
    assert_equal 3, rating.category.first.size
  end
end

class REXMLAdapterTest < Test::Unit::TestCase
  require 'xml-object/adapters/rexml'
  include XMLObjectAdapterBehavior

  def setup
    XMLObject.adapter = XMLObject::Adapters::REXML
  end

  def test_raw_xml_method
    assert_kind_of REXML::Element, XMLObject.new('<x/>').raw_xml
  end
end

if defined?(LibXML)
  class LibXMLAdapterTest < Test::Unit::TestCase
    require 'xml-object/adapters/libxml'
    include XMLObjectAdapterBehavior

    def setup
      XMLObject.adapter = XMLObject::Adapters::LibXML
    end

    def test_raw_xml_method
      assert_kind_of LibXML::XML::Node, XMLObject.new('<x/>').raw_xml
    end
  end
end