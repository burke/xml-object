require File.join(File.dirname(__FILE__), 'test_helper')

shared 'boolish string container' do
  should 'convert boolish strings to bool when asked' do
    @container.tall?.should.be.true
    @container.cube?.should.be.true
    @container.heavy?.should.be.true
    @container.house?.should.be.true

    @container.short?.should.be.false
    @container.round?.should.be.false
    @container.light?.should.be.false
    @container.ball?.should.be.false
  end

  should 'NOT convert boolish strings to bool even when asked' do
    should.raise(NameError) { @container.hypercube? }
  end
end

shared 'element containing XML named like methods' do
  should 'prioritize methods over XML' do
    @with_methods.upcase.should.not == 'Bummer!'
    @with_methods.upcase.should     == 'DUDE!'
  end

  should 'allow XML to be reached via [] notation' do
    @with_methods['upcase'].should == 'Bummer!'
  end
end

shared 'any XMLObject adapter' do

  describe 'Attribute' do
    describe 'with whitespace' do
      should 'be stripped of its whitespace' do
        @xml = XMLObject.new(%'<x with_whitespace=" \n x \t " />')
        @xml.with_whitespace.should == 'x'
      end
    end
  end

  describe 'Element' do

    should 'raise exception at [] notation used with invalid keys' do
      should.raise NameError do
        XMLObject.new('<x><z /></x>')[:invalid => 'foo']
      end
    end

    describe 'with no attributes, children, text or CDATA' do
      before do
        @blank_extended_strings = XMLObject.new '<x><one> </one> <two /></x>'
      end

      should 'look like an empty string' do
        @blank_extended_strings.should == ''
      end

      should "raise when asked for things it doesn't have" do
        should.raise NameError do
          @blank_extended_strings.foobared
        end

        should.raise NameError do
          @blank_extended_strings['foobared']
        end

        should.raise NameError do
          @blank_extended_strings[:elem => 'foobared']
        end

        should.raise NameError do
          @blank_extended_strings[:attr => 'foobared']
        end
      end
    end

    describe 'with a child element named "age" valued "19"' do
      should 'respond to "age" with "19"' do
        @string_with_age_child = XMLObject.new '<x><age>19</age></x>'

        @string_with_age_child.age.should == "19"

        @string_with_age_child['age'].should == "19"
        @string_with_age_child[:age].should  == "19"

        @string_with_age_child[:elem  => 'age'].should == "19"
        @string_with_age_child[:elem  => :age].should  == "19"
        @string_with_age_child['elem' => 'age'].should == "19"
        @string_with_age_child['elem' => :age].should  == "19"
      end
    end

    describe 'with an attribute "Rope" called "name"' do
      should 'respond to "name" with "Rope"' do
        @string_with_name_attr = XMLObject.new '<x name="Rope" />'

        @string_with_name_attr.name.should == "Rope"

        @string_with_name_attr['name'].should == "Rope"
        @string_with_name_attr[:name].should  == "Rope"

        @string_with_name_attr[:attr  => 'name'].should == "Rope"
        @string_with_name_attr[:attr  => :name].should  == "Rope"
        @string_with_name_attr['attr' => 'name'].should == "Rope"
        @string_with_name_attr['attr' => :name].should  == "Rope"
      end
    end

    describe 'with other parallel same-named XML elements' do
      should 'auto-fold with its namesakes into an Element Array' do
        @xml = XMLObject.new '<x><sheep></sheep><sheep></sheep></x>'

        @xml.sheep.should.be.instance_of(Array)
      end
    end

    describe 'without text or CDATA, with attrs and one Array child' do
      should 'delegate missing methods to its single child' do
        @container = XMLObject.new %| <x alpha="a" beta="b">
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should == @container.sheep
      end
    end

    describe 'without text, attrs, or CDATA, with one Array child' do
      should 'act as a Collection Proxy to its single child' do
        @container = XMLObject.new %| <x>
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should == @container.sheep
      end
    end

    describe 'without attrs or CDATA, with text and one Array child' do
      should 'NOT act as a Collection Proxy to its single child' do
        @x = XMLObject.new %| <x>Text in "x"
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.should.be.instance_of(Array)
      end
    end

    describe 'without text or attrs, with CDATA and one Array child' do
      should 'NOT act as a Collection Proxy to its single child' do
        @x = XMLObject.new %| <x><![CDATA[Text in "x"]]>
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.should.be.instance_of(Array)
      end
    end

    describe 'without text or CDATA, with attrs and one non-Array child' do
      should 'delegate missing methods to its single child' do
        @container = XMLObject.new %| <x alpha="a" beta="b">
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should.not == @container.sheep
      end
    end

    describe 'without text, attrs, or CDATA, with one non-Array child' do
      should 'act as a Collection Proxy to its single child' do
        @container = XMLObject.new %| <x>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should.not == @container.sheep
      end
    end

    describe 'with boolish attributes' do
      before do
        @container = XMLObject.new %|
          <x tall="Yes"   short="no"
             cube="y"     round="N"
             heavy="T"    light="f"
             house="tRUE" ball="fAlSE"
             hypercube="What?" /> |
      end

      behaves_like 'boolish string container'
    end

    describe 'with boolish elements' do
      before do
        @container = XMLObject.new %|
          <x>
            <tall>yEs</tall>    <short>nO</short>
            <cube>Y</cube>      <round>n</round>
            <heavy>t</heavy>    <light>F</light>
            <house>tRue</house> <ball>FalsE</ball>

            <hypercube>the hell?</hypercube>
          </x> |
      end

      behaves_like 'boolish string container'
    end

    describe 'without text and with multiple CDATA values' do
      should 'look like its CDATA values joined' do
        @no_text_two_cdata = XMLObject.new %| <x>
                                                <![CDATA[CDA]]>
                                                <![CDATA[TA!]]>
                                              </x> |
        @no_text_two_cdata.should == 'CDATA!'
      end
    end

    describe 'without text and CDATA' do
      should 'look like its CDATA' do
        XMLObject.new('<x><![CDATA[Not Text]]></x>').should == 'Not Text'
      end
    end

    describe 'with text and CDATA' do
      should 'look like its text' do
        XMLObject.new('<x>Text<![CDATA[Not Text]]></x>').should == 'Text'
      end
    end

    describe 'with only whitespace text' do
      should 'look like and empty string' do
        XMLObject.new("<x>\t \n</x>").should == ''
      end
    end

    describe 'with whitespace and non-whitespace text' do
      should 'retain its text verbatim' do
        XMLObject.new("<x>\t a \n</x>").should == "\t a \n"
      end
    end

    describe 'with only whitespace CDATA' do
      should 'retain its CDATA verbatim' do
        XMLObject.new("<x><![CDATA[\t \n]]></x>").should == "\t \n"
      end
    end

    describe 'with whitespace and non-whitespace CDATA' do
      should 'retain its CDATA verbatim' do
        XMLObject.new("<x><![CDATA[\t a \n]]></x>").should == "\t a \n"
      end
    end

    describe 'with attributes and child elements named the same' do
      before do
        @ambiguous = XMLObject.new %|
          <x name="attr name"><name>element name</name></x> |
      end

      should 'prioritize elements when called with dot notation' do
        @ambiguous.name.should == 'element name'
      end

      should 'prioritize element when called with [""] notation' do
        @ambiguous['name'].should == 'element name'
      end

      should 'allow unambigious access to both attr and element' do
        @ambiguous[:elem => 'name'].should == 'element name'
        @ambiguous[:attr => 'name'].should == 'attr name'
      end
    end

    describe 'with a (+s) pluralized array and an element named the same' do
      before do
        @ambiguous = XMLObject.new %|
          <x>
            <houses>Element</houses>
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      should 'prioritize the element over the pluralized array' do
        @ambiguous['houses'].should == 'Element'
        @ambiguous[:elem => 'houses'].should == 'Element'
        @ambiguous.houses.should == 'Element'
      end

      should 'maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a proper plural array and an element named the same' do
      before do
        @ambiguous = XMLObject.new %|
          <x>
            <octopi>Element</octopi>
            <octopus>Array</octopus>
            <octopus>Element</octopus>
          </x> |
      end

      should 'prioritize the element over the pluralized array' do
        @ambiguous.octopi.should == 'Element'
        @ambiguous['octopi'].should == 'Element'
        @ambiguous[:elem => 'octopi'].should == 'Element'
      end

      should 'maintain access to the array by its original name' do
        @ambiguous.octopus.join(' ').should == 'Array Element'
        @ambiguous['octopus'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'octopus'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a (+s) pluralized array and an attr named the same' do
      before do
        @ambiguous = XMLObject.new %|
          <x houses="Attribute">
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      should 'prioritize the attribute over the pluralized array' do
        @ambiguous.houses.should == 'Attribute'
        @ambiguous['houses'].should == 'Attribute'
        @ambiguous[:attr => 'houses'].should == 'Attribute'
      end

      should 'maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a proper plural array and an attribute named the same' do
      before do
        @ambiguous = XMLObject.new %|
          <x octopi="Attribute">
            <octopus>Array</octopus>
            <octopus>Element</octopus>
          </x> |
      end

      should 'prioritize the attribute over the pluralized array' do
        @ambiguous.octopi.should == 'Attribute'
        @ambiguous['octopi'].should == 'Attribute'
        @ambiguous[:attr => 'octopi'].should == 'Attribute'
      end

      should 'maintain access to the array by its original name' do
        @ambiguous.octopus.join(' ').should == 'Array Element'
        @ambiguous['octopus'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'octopus'].join(' ').should == 'Array Element'
      end
    end

    describe 'with ambiguously named plural array, attr and element' do
      before do
        @ambiguous = XMLObject.new %|
          <x houses="Attribute">
            <houses>Element</houses>
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      should 'prioritize the element over all others' do
        @ambiguous['houses'].should == 'Element'
        @ambiguous[:elem => 'houses'].should == 'Element'
        @ambiguous.houses.should == 'Element'
      end

      should 'allow unambiguous access to the attribute' do
        @ambiguous[:attr => 'houses'].should == 'Attribute'
      end

      should 'maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with attributes named like existing methods' do
      before do
        @with_methods = XMLObject.new '<x upcase="Bummer!">dude!</x>'
      end

      behaves_like 'element containing XML named like methods'
    end

    describe 'with elements named like existing methods' do
      before do
        @with_methods = XMLObject.new '<x><upcase>Bummer!</upcase>dude!</x>'
      end

      behaves_like 'element containing XML named like methods'
    end

    describe 'with elements named like invalid method names' do
      before do
        @with_illegal_methods = XMLObject.new %|
          <x><not-a-valid-method>XML!</not-a-valid-method></x> |
      end

      should 'allow access to elements using [] notation' do
        @with_illegal_methods['not-a-valid-method'].should == 'XML!'
      end
    end

    describe 'with attributes named like invalid method names' do
      before do
        @with_illegal_methods = XMLObject.new %'<x attr-with-dashes="yep" />'
      end

      should 'allow access to elements using [] notation' do
        @with_illegal_methods['attr-with-dashes'].should == 'yep'
      end
    end
  end

  describe 'Element Array' do
    before do
      @xml = XMLObject.new '<x><man>One</man><man>Two</man></x>'
    end

    should 'allow access to its elements by index' do
      @xml.man[0].should == 'One'
      @xml.man[1].should == 'Two'
    end

    should 'be accessible by its naive plural (mans)' do
      @xml.mans.should == @xml.man
    end

    if defined?(ActiveSupport::Inflector)
      should 'be available by its correct plural (men)' do
        @xml.men.should == @xml.man
      end
    end
  end

  describe 'Collection Proxy Element' do
    before do
      @proxy = XMLObject.new '<x><dude>Peter</dude><dude>Paul</dude></x>'
    end

    should 'be equal to the Array it targets' do
      @proxy.should == @proxy.dudes
    end

    should 'respond to the same methods of the Array it targets' do
      @proxy.map { |d| d.upcase }.should == @proxy.dude.map { |d| d.upcase }
      @proxy.first.downcase.should == @proxy.dude.first.downcase
      @proxy[-1].should == @proxy.dude[-1]
    end
  end

  describe '#new() function' do
    before do
      @xml_str = '<x>Bar</x>'
      @duck    = StringIO.new(@xml_str)
    end

    should 'accept Strings with XML' do
      XMLObject.new(@xml_str).should == 'Bar'
    end

    should 'accept things that respond to "to_s"' do
      def @duck.respond_to?(m); (m == :'read') ? false : super; end
      def @duck.to_s; self.read; end

      XMLObject.new(@duck).should == 'Bar'
    end

    should 'accept things that respond to "read"' do
      def @duck.respond_to?(m); (m == :'to_s') ? false : super; end

      XMLObject.new(@duck).should == 'Bar'
    end

    should "raise exception at things that don't know #to_s or #read" do
      def @duck.respond_to?(m)
        ((m == :'to_s') || (:'read' == m)) ? false : super
      end

      should.raise { XMLObject.new(@duck) }
    end
  end

  describe 'Sample atom.xml' do
    before { @feed = XMLObject.new(XMLObject::Helper.sample(:atom)) }

    should 'behave as follows' do
      @feed.should == ''

      # LibXML eats up 'xmlns' from the attributes hash
      unless XMLObject.adapter.to_s.match /LibXML$/
        @feed.xmlns.should == 'http://www.w3.org/2005/Atom'
      end

      @feed.title.should    == 'Example Feed'
      @feed.subtitle.should == 'A subtitle.'

      @feed.link.should.be.instance_of(Array)
      @feed.link.should == @feed.links

      @feed.link.first.href.should == 'http://example.org/feed/'
      @feed.link.first.rel.should  == 'self'
      @feed.link.last.href.should  == 'http://example.org/'

      @feed.updated.should == '2003-12-13T18:30:02Z'

      @feed.author.should == ''
      @feed.author.name.should == 'John Doe'
      @feed.author.email.should == 'johndoe@example.com'

      @feed['id'].should == 'urn:uuid:60a76c80-d399-11d9-b91C-0003939e0af6'

      @feed.entry.should == ''
      @feed.entry.title.should == 'Atom-Powered Robots Run Amok'
      @feed.entry['id'].should == 'urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a'
      @feed.entry.updated.should == '2003-12-13T18:30:02Z'
      @feed.entry.summary.should == 'Some text.'
    end
  end

  describe 'Sample function.xml' do
    before { @function = XMLObject.new(XMLObject::Helper.sample(:function)) }

    should 'behave as follows' do
      @function.should == ''
      @function.name.should == 'Hello'
      @function.description.should == 'Greets the indicated person.'

      @function.input.should == ''
      @function.input.param.should == ''
      @function.input.param.name.should == 'name'
      @function.input.param.required.should == 'true'
      @function.input.param.required?.should.be.true
      @function.input.param.description.should == \
        'The name of the person to be greeted.'

      @function.output.should == ''
      @function.output.param.should == ''
      @function.output.param.name.should == 'greeting'
      @function.output.param.required.should == 'true'
      @function.output.param.required?.should.be.true
      @function.output.param.description.should == \
        'The constructed greeting.'
    end
  end

  describe 'Sample persons.xml' do
    before { @persons = XMLObject.new(XMLObject::Helper.sample(:persons)) }

    should 'behave as follows' do
      @persons.should == [ '', '' ]
      @persons.should == @persons.person
      @persons.should == @persons.persons
      @persons.should == @persons.people if defined? ActiveSupport::Inflector

      @persons[0].should  == ''
      @persons[-1].should == ''

      @persons.first.username.should == 'JS1'
      @persons.first.name.should == 'John'
      @persons.first['family-name'].should == 'Smith'

      @persons.last.username.should == 'MI1'
      @persons.last.name.should == 'Morka'
      @persons.last[:'family-name'].should == 'Ismincius'
    end
  end

  describe 'Sample playlist.xml' do
    before { @playlist = XMLObject.new(XMLObject::Helper.sample(:playlist)) }

    should 'behave as follows' do
      @playlist.should         == ''
      @playlist.version.should == '1'

      # LibXML eats up 'xmlns' from the attributes hash
      unless XMLObject.adapter.to_s.match /LibXML$/
        @playlist.xmlns.should == 'http://xspf.org/ns/0/'
      end

      @playlist.trackList.should.be.instance_of Array
      @playlist.trackList.track.should.be.instance_of Array
      @playlist.trackList.tracks.should.be.instance_of Array

      @playlist.trackList.should == @playlist.trackList.track
      @playlist.trackList.should == @playlist.trackList.tracks

      @playlist.trackList.track.should == @playlist.trackList.tracks

      @playlist.trackList.first.title.should == 'Internal Example'
      @playlist.trackList.first.location.should == 'file:///C:/music/foo.mp3'

      @playlist.trackList.last.title.should == 'External Example'
      @playlist.trackList.last.location.should == \
        'http://www.example.com/music/bar.ogg'
    end
  end

  describe 'Sample recipe.xml' do
    before { @recipe = XMLObject.new(XMLObject::Helper.sample(:recipe)) }

    should 'behave as follows' do
      @recipe.should           == ''
      @recipe.name.should      == 'bread'
      @recipe.prep_time.should == '5 mins'
      @recipe.cook_time.should == '3 hours'
      @recipe.title.should     == 'Basic bread'

      @recipe.ingredient.should.be.instance_of Array
      @recipe.ingredients.should == @recipe.ingredient
      @recipe.ingredients.should == %w[ Flour Yeast Water Salt ]
      @recipe.ingredients.map { |i| i.amount }.should == %w[ 8 10 4 1 ]
      @recipe.ingredients.map { |i| i.unit }.should == %w[
        dL grams dL teaspoon ]
      @recipe.ingredients[2].state.should == 'warm'

      @recipe.instructions.should.be.instance_of Array
      @recipe.instructions.step.should.be.instance_of Array
      @recipe.instructions.steps.should.be.instance_of Array

      @recipe.instructions.should      == @recipe.instructions
      @recipe.instructions.should      == @recipe.instructions.steps
      @recipe.instructions.step.should == @recipe.instructions.steps

      @recipe.instructions.map { |s| s.split(' ')[0] }.join(
        ', ').should == 'Mix, Knead, Cover, Knead, Place, Cover, Bake'
    end
  end

  describe 'Sample voice.xml' do
    before { @voice = XMLObject.new(XMLObject::Helper.sample(:voice)) }

    should 'behave as follows' do
      @voice.should == ''
      @voice.version.should == '2.0'

      # LibXML eats up 'xmlns' from the attributes hash
      unless XMLObject.adapter.to_s.match /LibXML$/
        @voice.xmlns.should == 'http://www.w3.org/2001/vxml'
      end

      @voice.form.should == ''
      @voice.form.block.should == ''
      @voice.form.block.prompt.strip.should == 'Hello world!'
    end
  end

  describe 'Sample Bug rating.xml' do
    before do
      @rating = XMLObject.new(XMLObject::Helper.sample('bugs/rating'))
    end

    should 'behave as follows' do
      @rating.should.be.instance_of Array
      @rating.size.should                == 3
      @rating.category.size.should       == 3
      @rating.category.first.size.should == 3
    end
  end
end

describe 'XMLObject' do

  describe 'REXML adapter' do
    require 'xml-object/adapters/rexml'
    XMLObject.adapter = XMLObject::Adapters::REXML

    behaves_like 'any XMLObject adapter'

    should 'return unadapted XML objects when #raw_xml is called' do
      XMLObject.new('<x/>').raw_xml.should.be.kind_of(::REXML::Element)
    end
  end

  if defined?(LibXML)
    describe 'LibXML adapter' do
      require 'xml-object/adapters/libxml'
      XMLObject.adapter = XMLObject::Adapters::LibXML

      behaves_like 'any XMLObject adapter'

      should 'return unadapted XML objects when #raw_xml is called' do
        XMLObject.new('<x/>').raw_xml.should.be.kind_of(::LibXML::XML::Node)
      end
    end
  end
end