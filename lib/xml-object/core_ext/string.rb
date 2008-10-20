class String
  def blank?
    self !~ /\S/
  end unless ''.respond_to? :blank?

  def squish
    dup.squish!
  end unless ''.respond_to? :squish

  def squish!
    strip!
    gsub! /\s+/, ' '
    self
  end unless ''.respond_to? :squish!

  def singularize
    self.chomp 's'
  end unless ''.respond_to? :singularize
end