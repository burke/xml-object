class XMLObject::BlankishSlate # :nodoc:

  instance_methods.each do |m|
    undef_method m unless m =~ /^__/        ||
                          m =~ /respond_to/ ||
                          m =~ /extend/     ||
                          m =~ /object_id/  ||
                          m =~ /^instance_/
  end
end