class Hash
  def blank?
    size.zero?
  end unless {}.respond_to? :blank?
end