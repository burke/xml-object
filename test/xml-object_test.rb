require File.join(File.dirname(__FILE__), 'test_helper')

describe_shared 'any XMLObject adapter' do

  describe 'Element' do
    describe 'with no attributes, children, text or CDATA' do
      before(:each) do
        @blank_extended_strings = XMLObject.new '<x><one> </one> <two /></x>'
      end

      it 'should look like an empty string' do
        @blank_extended_strings.should == ''
      end
    end

    describe 'with a child element named "age" valued "19"' do
      before(:each) do
        @string_with_age_child = XMLObject.new '<x><age>19</age></x>'
      end

      it 'should have "19" for an "age"' do
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
      before(:each) do
        @string_with_name_attr = XMLObject.new '<x name="Rope" />'
      end

      it 'should have a name called "Rope"' do
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
      before(:each) do
        @xml = XMLObject.new '<x><sheep></sheep><sheep></sheep></x>'
      end

      it 'should fold with its namesakes into an Element Array' do
        @xml.sheep.is_a?(Array).should.be true
      end
    end

    describe 'with no text, no CDATA, with attrs, with one Array child' do
      before(:each) do
        @container = XMLObject.new %| <x alpha="a" beta="b">
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |
      end

      it 'should pass forth missing methods to its single child' do
        numbers = @container.collect { |sheep| sheep.number }
        numbers.should == @container.sheep.collect { |sheep| sheep.number }
      end
    end

    describe 'with no text, no attrs, no CDATA, with one Array child' do
      before(:each) do
        @container = XMLObject.new %| <x>
                                        <sheep number="0">?</sheep>
                                        <sheep number="1">Dolly</sheep>
                                      </x> |
      end

      it 'should pass forth missing methods to its single child' do
        numbers = @container.collect { |sheep| sheep.number }
        numbers.should == @container.sheep.collect { |sheep| sheep.number }
      end
    end

    describe 'with attributes that look like boolean' do
      before(:each) do
        @x = XMLObject.new %|
          <x tall="Yes"   short="no"
             cube="y"     round="N"
             heavy="T"    light="f"
             house="tRUE" ball="fAlSE"
             hypercube="What?" /> |
      end

      it 'should convert boolish attributes to bool when asked' do
        @x.tall?.should.be  true
        @x.cube?.should.be  true
        @x.heavy?.should.be true
        @x.house?.should.be true

        @x.short?.should.be false
        @x.round?.should.be false
        @x.light?.should.be false
        @x.ball?.should.be  false
      end

      it 'should not convert non-boolish attributes to bool when asked' do
        @x.hypercube?.should.not.be true
        @x.hypercube?.should.not.be false
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
      # Take the "to_s" and "read" responses out:
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
