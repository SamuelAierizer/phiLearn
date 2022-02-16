module GroupsHelper
  def generateCode
    return Array.new(3) { rand(256) }.pack('C*').unpack('H*').first
  end

end