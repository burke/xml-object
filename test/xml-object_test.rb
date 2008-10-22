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
    @container.hypercube?.should.not.be true
    @container.hypercube?.should.not.be false
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
    describe 'with no attributes, children, text or CDATA' do
      it 'should look like an empty string' do
        @blank_extended_strings = XMLObject.new '<x><one> </one> <two /></x>'
        @blank_extended_strings.should == ''
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

        numbers = @container.collect { |sheep| sheep.number }
        numbers.should == @container.sheep.collect { |sheep| sheep.number }
      end
    end

    describe 'without text, attrs, or CDATA, with one Array child' do
      it 'should pass forth missing methods to its single child' do
        @container = XMLObject.new %| <x>
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |

        numbers = @container.collect { |sheep| sheep.number }
        numbers.should == @container.sheep.collect { |sheep| sheep.number }
      end
    end

    describe 'without attrs or CDATA, with text and one Array child' do
      it 'should NOT pass forth missing methods to its single child' do
        @x = XMLObject.new %| <x>Text in "x"
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.is_a?(Array).should.be true
      end
    end

    describe 'without text or attrs, with CDATA and one Array child' do
      it 'should NOT pass forth missing methods to its single child' do
        @x = XMLObject.new %| <x><![CDATA[Text in "x"]]>
                                <sheep number="0">?</sheep>
                                <sheep number="1">Dolly</sheep>
                              </x> |

        @x.strip.should == 'Text in "x"'
        @x.sheep.is_a?(Array).should.be true
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
        @ambiguous['name'] == 'element name'
      end

      it 'should still allow unambigious access to both attr and element' do
        @ambiguous[:elem => 'name'].should == 'element name'
        @ambiguous[:attr => 'name'].should == 'attr name'
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

  it 'should raise exception at [] notation used with invalid keys' do
    should.raise { XMLObject.new('<x><z /></x>')[:invalid => 'foo'] }
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
