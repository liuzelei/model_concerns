class Array
  def trim_head
    array_trim = Array.new(self)
    while [0, nil].include?(array_trim[0]) do
      array_trim.shift
    end
    return array_trim
  end
end