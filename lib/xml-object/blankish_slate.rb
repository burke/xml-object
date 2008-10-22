class XMLObject::BlankishSlate # :nodoc:

  instance_methods.each do |m|
    meth_str, meth_sym = m.to_s, m.to_sym # Ruby 1.8 and 1.9 differ, so...

    undef_method meth_sym unless ( (meth_str =~ /^__/)        ||
                                   (meth_str =~ /^instance_/) ||
                                   (meth_sym == :extend)      ||
                                   (meth_sym == :object_id)     )
  end
end