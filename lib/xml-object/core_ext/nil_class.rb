class NilClass
  def blank?
    true
  end unless nil.respond_to? :blank?
end