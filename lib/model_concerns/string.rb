require "model_concerns/array"

class String
  def ^ (other)
    self_binary_array = self.unpack("U*")
    key_binary_array = other.unpack("U*")
    longest = [self_binary_array.length, key_binary_array.length].max
    self_binary_array = [0] * (longest - self_binary_array.length) + self_binary_array
    key_binary_array = [0] * (longest - key_binary_array.length) + key_binary_array
    return self_binary_array.zip(key_binary_array).map { |a, b| a ^ b }.trim_head.pack("U*")
  end
end