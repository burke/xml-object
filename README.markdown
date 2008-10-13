# XML Struct

(This is inspired by Python's `xml_objectify`)

  XML Struct attempts to make accessing small, well-formed XML structures
convenient, by using dot notation (`foo.bar`) to represent both attributes
and child elements whenever possible.

  XML parsing libraries (in general) have interfaces that are useful when
one is using XML for its intended purpose, but cumbersome when one always
sends the same XML structure, and always process all of it in the same
way. This one aims to be a bit different.

## Example usage

    <recipe name="bread" prep_time="5 mins" cook_time="3 hours">
      <title>Basic bread</title>
      <ingredient amount="8" unit="dL">Flour</ingredient>
      <ingredient amount="10" unit="grams">Yeast</ingredient>
      <ingredient amount="4" unit="dL" state="warm">Water</ingredient>
      <ingredient amount="1" unit="teaspoon">Salt</ingredient>
      <instructions easy="yes" hard="false">
        <step>Mix all ingredients together.</step>
        <step>Knead thoroughly.</step>
        <step>Cover with a cloth, and leave for one hour in warm room.</step>
        <step>Knead again.</step>
        <step>Place in a bread baking tin.</step>
        <step>Cover with a cloth, and leave for one hour in warm room.</step>
        <step>Bake in the oven at 180(degrees)C for 30 minutes.</step>
      </instructions>
    </recipe>

    require 'xml_struct'
    recipe = XMLStruct.new io_with_recipe_xml_shown_above

    recipe.name                      => "bread"
    recipe.title                     => "Basic bread"

    recipe.ingredients.is_a?(Array)  => true
    recipe.ingredients.first.amount  => "8" # Not a Fixnum. Too hard. :(

    recipe.instructions.easy?        => true

    recipe.instructions.first.upcase => "MIX ALL INGREDIENTS TOGETHER."
    recipe.instructions.steps.size   => 7

## Installation instructions

    sudo gem install jordi-xml_struct --source http://gems.github.com

## Motivation

  XML is an **extensible** markup language. It is extensible because it is
meant to define markup languages for **any** type of document, so new tags
are needed depending on the problem domain.

  Sometimes, however, XML ends up being used to solve a much simpler problem:
the issue of passing a data-structure over the network, and/or between two
different languages. Tools like JSON or YAML are a much better fit for
this kind of job, but one doesn't always have that luxury.

## Caveats

  The dot notation is used as follows. For the given file:

    <outer id="root" name="foo">
      <name>Outer Element</name>
    </outer>

  `outer.name` is the `<name>` element. Child elements are always looked up
first, then attributes. To access the attribute in the case of ambiguity,
use `outer[:attr => 'name']`.

  `outer.id` is really `Object#id`, because all of the object methods are
preserved (this is on purpose). To access the attribute `id`, use
`outer[:attr => 'id']`, or `outer['id']` since there's no element/attribute
ambiguity.

## Features & Problems

### Collection auto-folding

  Similar to XML::Simple, XML Struct folds same named elements at the same
level. For example:

    <student>
      <name>Bob</name>
      <course>Math</course>
      <course>Biology</course>
    </student>

    student = XMLStruct.new(xml_file)

    student.course.is_a? Array       => true
    student.course.first == 'Math'   => true
    student.course.last  == 'Biology => true

### Collection pluralization:

  With the same file from the `Collection auto-folding` section above, you
also get this (courtesy of `ActiveSupport`'s `Inflector`):

    student.courses.first == student.course.first => true

### Collection proxy

  Sometimes, collections are expressed with a container element in XML:

    <student>
      <name>Bob</name>
      <courses>
        <course>Math</course>
        <course>Biology</course>
      </courses>
    </student>

  In this case, since the container element `courses` has no text element
of its own, and it only has elements of one name under it, it delegates
all methods it doesn't contain to the collection below, so you get:

    student.courses.collect { |c| c.downcase.to_sym } => [:math, :biology]

### Question mark notation

  Strings that look like booleans are "booleanized" if called by their
question mark names (such as `enabled?`)

### Slow

So far, XML Struct uses REXML to do the actual XML parsing. Support
for using faster parsers is planned, leaving REXML as a fallback option.

### Recursive

The entire XML file is parsed using REXML right now, and then converted to
an XMLStruct of XMLStruct objects recursively. Deep files are bound to
throw `SystemStackError`, but for the kinds of files I need to read, things
are working fine so far. In any case, stream parsing is on the TODO list.

### Incomplete

It most likely doesn't work with a ton of features of complex XML files. I
will always try to accomodate those, as long as they don't make the basic
usage more complex. As usual, patches welcome.

## Legal

Copyright (c) 2008 Jordi Bunster, released under the MIT license



