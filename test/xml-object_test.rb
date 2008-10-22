require File.join(File.dirname(__FILE__), 'test_helper')

describe_shared 'boolish string container' do
  it 'should convert boolish strings to bool when asked' do
    @container.tall?.should.be  true
    @container.cube?.should.be  true
    @container.heavy?.should.be true
    @container.house?.should.be true

    @container.short?.should.be false
    @container.round?.should.be false
    @container.light?.should.be false
    @container.ball?.should.be  false
  end

  it 'should not convert boolish strings to bool even when asked' do
    should.raise(NameError) { @container.hypercube? }
  end
end

describe_shared 'element containing XML named like methods' do
  it 'should prioritize methods over XML' do
    @with_methods.upcase.should.not == 'Bummer!'
    @with_methods.upcase.should     == 'DUDE!'
  end

  it 'should still allow XML to be reached via [] notation' do
    @with_methods['upcase'].should == 'Bummer!'
  end
end

describe_shared 'any XMLObject adapter' do

  describe 'Attribute' do
    describe 'with whitespace' do
      it 'should be stripped of its whitespace' do
        @xml = XMLObject.new(%'<x with_whitespace=" \n x \t " />')
        @xml.with_whitespace.should == 'x'
      end
    end
  end

  describe 'Element' do

    it 'should raise exception at [] notation used with invalid keys' do
      should.raise NameError do
        XMLObject.new('<x><z /></x>')[:invalid => 'foo']
      end
    end

    describe 'with no attributes, children, text or CDATA' do
      before(:each) do
        @blank_extended_strings = XMLObject.new '<x><one> </one> <two /></x>'
      end

      it 'should look like an empty string' do
        @blank_extended_strings.should == ''
      end

      it "should raise when asked for things it doesn't have" do
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
      it 'should respond to "age" with "19"' do
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
      it 'should respond to "name" with "Rope"' do
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
      it 'should fold-in with its namesakes into an Element Array' do
        @xml = XMLObject.new '<x><sheep></sheep><sheep></sheep></x>'

        @xml.sheep.is_a?(Array).should.be true
      end
    end

    describe 'without text or CDATA, with attrs and one Array child' do
      it 'should pass forth missing methods to its single child' do
        @container = XMLObject.new %| <x alpha="a" beta="b">
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should == @container.sheep
      end
    end

    describe 'without text, attrs, or CDATA, with one Array child' do
      it 'should become a Collection Proxy to its single child' do
        @container = XMLObject.new %| <x>
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should == @container.sheep
      end
    end

    describe 'without attrs or CDATA, with text and one Array child' do
      it 'should NOT become a Collection Proxy to its single child' do
        @x = XMLObject.new %| <x>Text in "x"
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.is_a?(Array).should.be true
      end
    end

    describe 'without text or attrs, with CDATA and one Array child' do
      it 'should NOT become a Collection Proxy to its single child' do
        @x = XMLObject.new %| <x><![CDATA[Text in "x"]]>
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.is_a?(Array).should.be true
      end
    end

    describe 'without text or CDATA, with attrs and one non-Array child' do
      it 'should pass forth missing methods to its single child' do
        @container = XMLObject.new %| <x alpha="a" beta="b">
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should.not == @container.sheep
      end
    end

    describe 'without text, attrs, or CDATA, with one non-Array child' do
      it 'should become a Collection Proxy to its single child' do
        @container = XMLObject.new %| <x>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        @container.should.not == @container.sheep
      end
    end

    describe 'with boolish attributes' do
      before(:each) do
        @container = XMLObject.new %|
          <x tall="Yes"   short="no"
             cube="y"     round="N"
             heavy="T"    light="f"
             house="tRUE" ball="fAlSE"
             hypercube="What?" /> |
      end

      it_should_behave_like 'boolish string container'
    end

    describe 'with boolish elements' do
      before(:each) do
        @container = XMLObject.new %|
          <x>
            <tall>yEs</tall>    <short>nO</short>
            <cube>Y</cube>      <round>n</round>
            <heavy>t</heavy>    <light>F</light>
            <house>tRue</house> <ball>FalsE</ball>

            <hypercube>the hell?</hypercube>
          </x> |
      end

      it_should_behave_like 'boolish string container'
    end

    describe 'without text and with multiple CDATA values' do
      it 'should look like its CDATA values joined' do
        @no_text_two_cdata = XMLObject.new %| <x>
                                                <![CDATA[CDA]]>
                                                <![CDATA[TA!]]>
                                              </x> |
        @no_text_two_cdata.should == 'CDATA!'
      end
    end

    describe 'without text and CDATA' do
      it 'should look like its CDATA' do
        XMLObject.new('<x><![CDATA[Not Text]]></x>').should == 'Not Text'
      end
    end

    describe 'with text and CDATA' do
      it 'should look like its text' do
        XMLObject.new('<x>Text<![CDATA[Not Text]]></x>').should == 'Text'
      end
    end

    describe 'with only whitespace text' do
      it 'should look like and empty string' do
        XMLObject.new("<x>\t \n</x>").should == ''
      end
    end

    describe 'with whitespace and non-whitespace text' do
      it 'should retain its text verbatim' do
        XMLObject.new("<x>\t a \n</x>").should == "\t a \n"
      end
    end

    describe 'with only whitespace CDATA' do
      it 'should retain its CDATA verbatim' do
        XMLObject.new("<x><![CDATA[\t \n]]></x>").should == "\t \n"
      end
    end

    describe 'with whitespace and non-whitespace CDATA' do
      it 'should retain its CDATA verbatim' do
        XMLObject.new("<x><![CDATA[\t a \n]]></x>").should == "\t a \n"
      end
    end

    describe 'with attributes and child elements named the same' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x name="attr name"><name>element name</name></x> |
      end

      it 'should prioritize elements when called with dot notation' do
        @ambiguous.name.should == 'element name'
      end

      it 'should prioritize element when called with [""] notation' do
        @ambiguous['name'].should == 'element name'
      end

      it 'should still allow unambigious access to both attr and element' do
        @ambiguous[:elem => 'name'].should == 'element name'
        @ambiguous[:attr => 'name'].should == 'attr name'
      end
    end

    describe 'with a (+s) pluralized array and an element named the same' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x>
            <houses>Element</houses>
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      it 'should prioritize the element over the pluralized array' do
        @ambiguous['houses'].should == 'Element'
        @ambiguous[:elem => 'houses'].should == 'Element'
        @ambiguous.houses.should == 'Element'
      end

      it 'should maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a proper plural array and an element named the same' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x>
            <octopi>Element</octopi>
            <octopus>Array</octopus>
            <octopus>Element</octopus>
          </x> |
      end

      it 'should prioritize the element over the pluralized array' do
        @ambiguous.octopi.should == 'Element'
        @ambiguous['octopi'].should == 'Element'
        @ambiguous[:elem => 'octopi'].should == 'Element'
      end

      it 'should maintain access to the array by its original name' do
        @ambiguous.octopus.join(' ').should == 'Array Element'
        @ambiguous['octopus'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'octopus'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a (+s) pluralized array and an attr named the same' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x houses="Attribute">
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      it 'should prioritize the attribute over the pluralized array' do
        @ambiguous.houses.should == 'Attribute'
        @ambiguous['houses'].should == 'Attribute'
        @ambiguous[:attr => 'houses'].should == 'Attribute'
      end

      it 'should maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with a proper plural array and an attribute named the same' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x octopi="Attribute">
            <octopus>Array</octopus>
            <octopus>Element</octopus>
          </x> |
      end

      it 'should prioritize the attribute over the pluralized array' do
        @ambiguous.octopi.should == 'Attribute'
        @ambiguous['octopi'].should == 'Attribute'
        @ambiguous[:attr => 'octopi'].should == 'Attribute'
      end

      it 'should maintain access to the array by its original name' do
        @ambiguous.octopus.join(' ').should == 'Array Element'
        @ambiguous['octopus'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'octopus'].join(' ').should == 'Array Element'
      end
    end

    describe 'with ambiguously named plural array, attr and element' do
      before(:each) do
        @ambiguous = XMLObject.new %|
          <x houses="Attribute">
            <houses>Element</houses>
            <house>Array</house>
            <house>Element</house>
          </x> |
      end

      it 'should prioritize the element over all others' do
        @ambiguous['houses'].should == 'Element'
        @ambiguous[:elem => 'houses'].should == 'Element'
        @ambiguous.houses.should == 'Element'
      end

      it 'should allow unambiguous access to the attribute' do
        @ambiguous[:attr => 'houses'].should == 'Attribute'
      end

      it 'should maintain access to the array by its original name' do
        @ambiguous.house.join(' ').should == 'Array Element'
        @ambiguous['house'].join(' ').should == 'Array Element'
        @ambiguous[:elem => 'house'].join(' ').should == 'Array Element'
      end
    end

    describe 'with attributes named like existing methods' do
      before(:each) do
        @with_methods = XMLObject.new '<x upcase="Bummer!">dude!</x>'
      end

      it_should_behave_like 'element containing XML named like methods'
    end

    describe 'with elements named like existing methods' do
      before(:each) do
        @with_methods = XMLObject.new '<x><upcase>Bummer!</upcase>dude!</x>'
      end

      it_should_behave_like 'element containing XML named like methods'
    end

    describe 'with elements named like invalid method names' do
      before(:each) do
        @with_illegal_methods = XMLObject.new %|
          <x><not-a-valid-method>XML!</not-a-valid-method></x> |
      end

      it 'should allow access to elements using [] notation' do
        @with_illegal_methods['not-a-valid-method'].should == 'XML!'
      end
    end

    describe 'with attributes named like invalid method names' do
      before(:each) do
        @with_illegal_methods = XMLObject.new %'<x attr-with-dashes="yep" />'
      end

      it 'should allow access to elements using [] notation' do
        @with_illegal_methods['attr-with-dashes'].should == 'yep'
      end
    end
  end

  describe 'Element Array' do
    before(:each) do
      @xml = XMLObject.new '<x><man>One</man><man>Two</man></x>'
    end

    it 'should allow access to its elements by index' do
      @xml.man[0].should == 'One'
      @xml.man[1].should == 'Two'
    end

    it 'should be accessible by its naive plural (mans)' do
      @xml.mans.should == @xml.man
    end

    describe 'when ActiveSupport::Inflector is found' do
      if defined?(ActiveSupport::Inflector)
        it 'should be available by its correct plural (men)' do
          @xml.men.should == @xml.man
        end
      else
        xit 'ActiveSupport::Inflector NOT found'
      end
    end
  end

  describe 'Collection Proxy Element' do
    before(:each) do
      @proxy = XMLObject.new '<x><dude>Peter</dude><dude>Paul</dude></x>'
    end

    it 'should be equal to the Array it targets' do
      @proxy.should == @proxy.dudes
    end

    it 'should respond to the same methods of the Array it targets' do
      @proxy.map { |d| d.upcase }.should == @proxy.dude.map { |d| d.upcase }
      @proxy.first.downcase.should == @proxy.dude.first.downcase
      @proxy[-1].should == @proxy.dude[-1]
    end
  end

  describe '#new() function' do
    before(:each) do
      @xml_str = '<x>Bar</x>'
      @duck    = StringIO.new(@xml_str)
    end

    it 'should accept Strings with XML' do
      XMLObject.new(@xml_str).should == 'Bar'
    end

    it 'should accept things that respond to "to_s"' do
      def @duck.respond_to?(m); (m == :'read') ? false : super; end
      def @duck.to_s; self.read; end

      XMLObject.new(@duck).should == 'Bar'
    end

    it 'should accept things that respond to "read"' do
      def @duck.respond_to?(m); (m == :'to_s') ? false : super; end

      XMLObject.new(@duck).should == 'Bar'
    end

    it "should raise exception at things that don't know #to_s or #read" do
      def @duck.respond_to?(m)
        ((m == :'to_s') || (:'read' == m)) ? false : super
      end

      should.raise { XMLObject.new(@duck) }
    end
  end

  describe 'Sample atom.xml' do
    before(:each) { @feed = XMLObject.new(open_sample_xml(:atom)) }

    it 'should behave accordingly' do
      @feed.should          == ''

      # LibXML eats up 'xmlns' from the attributes hash
      unless XMLObject.adapter.to_s.match /LibXML$/
        @feed.xmlns.should == 'http://www.w3.org/2005/Atom'
      end

      @feed.title.should    == 'Example Feed'
      @feed.subtitle.should == 'A subtitle.'

      @feed.link.is_a?(Array).should.be true
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
    before(:each) { @function = XMLObject.new(open_sample_xml(:function)) }

    it 'should behave accordingly' do
      @function.should == ''
      @function.name.should == 'Hello'
      @function.description.should == 'Greets the indicated person.'

      @function.input.should == ''
      @function.input.param.should == ''
      @function.input.param.name.should == 'name'
      @function.input.param.required.should == 'true'
      @function.input.param.required?.should.be true
      @function.input.param.description.should ==
        'The name of the person to be greeted.'

      @function.output.should == ''
      @function.output.param.should == ''
      @function.output.param.name.should == 'greeting'
      @function.output.param.required.should == 'true'
      @function.output.param.required?.should.be true
      @function.output.param.description.should ==
        'The constructed greeting.'
    end
  end

  describe 'Sample persons.xml' do
    before(:each) { @persons = XMLObject.new(open_sample_xml(:persons)) }

    it 'should behave accordingly' do
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
end

describe 'XMLObject' do

  describe 'REXML adapter' do
    before(:all)  { require 'xml-object/adapters/rexml' }
    before(:each) { XMLObject.adapter = XMLObject::Adapters::REXML }

    it_should_behave_like 'any XMLObject adapter'

    it 'should return unadapted XML objects when #raw_xml is called' do
      XMLObject.new('<x/>').raw_xml.is_a?(::REXML::Element).should.be true
    end
  end

  describe 'Hpricot adapter' do
    before(:all)  { require 'xml-object/adapters/hpricot' }
    before(:each) { XMLObject.adapter = XMLObject::Adapters::Hpricot }

    it_should_behave_like 'any XMLObject adapter'

    it 'should return unadapted XML objects when #raw_xml is called' do
      XMLObject.new('<x/>').raw_xml.is_a?(::Hpricot::Elem).should.be true
    end
  end if defined?(Hpricot)

  describe 'LibXML adapter' do
    before(:all)  { require 'xml-object/adapters/libxml' }
    before(:each) { XMLObject.adapter = XMLObject::Adapters::LibXML }

    it_should_behave_like 'any XMLObject adapter'

    it 'should return unadapted XML objects when #raw_xml is called' do
      XMLObject.new('<x/>').raw_xml.is_a?(::LibXML::XML::Node).should.be true
    end
  end if defined?(LibXML)
end
