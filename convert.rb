class String
  def to_b
    self.to_i.to_s(2)
  end

  def to_hex
    "%02x"%self.to_i(2)
  end
end

def map_string_to_register(string)
  string.delete("$").to_b.rjust(5, "0")
end

def convert_to_binary(instruction, opcode_dict)
  instruction = instruction.gsub(",", " ") # replace commas with spaces
  instruction = instruction.gsub(/\/\/.*/, "") # remove comments
  split_string = instruction.split(" ")
  opcode = split_string[0]
  binary_string = ""
  if ["ADD", "SUB", "AND", "XOR", "COM", "MUL"].include? opcode # R-type instruction
    rd = map_string_to_register(split_string[1])
    rs = map_string_to_register(split_string[2])
    rt = map_string_to_register(split_string[3])
    binary_string = "#{opcode_dict[opcode]}#{rs}#{rt}#{rd}00000000000"
  elsif opcode == "ADDI"
    rd = map_string_to_register(split_string[1])
    rs = map_string_to_register(split_string[2])
    im = split_string[3].to_b.rjust(16, "0")
    binary_string = "#{opcode_dict[opcode]}#{rs}#{rd}#{im}"
  elsif opcode == "BEQ"
    rs = map_string_to_register(split_string[1])
    rt = map_string_to_register(split_string[2])
    im = split_string[3].to_b.rjust(16, "0")
    binary_string = "#{opcode_dict[opcode]}#{rs}#{rt}#{im}"
  elsif ["LW", "SW"].include? opcode
    rt = map_string_to_register(split_string[1])
    offset_rs = split_string[2]
    offset = offset_rs[/^\d+/].rjust(16, "0").to_b.rjust(16, "0")
    rs = offset_rs[/\(.*?\)/][/\d+/] # get number inside parenthesis
    rs = map_string_to_register(rs) # map the string to register
    binary_string = "#{opcode_dict[opcode]}#{rs}#{rt}#{offset}" #set as binary string
  elsif ["JMP", "JAL"].include? opcode
    offset = split_string[1].to_b.rjust(26, "0")
    binary_string = "#{opcode_dict[opcode]}#{offset}"
  elsif opcode == "JR"
    rs = map_string_to_register(split_string[1])
    rt = "00000"
    rd = "00000"
    binary_string = "#{opcode_dict[opcode]}#{rs}#{rt}#{rd}00000000000"
  end
  return binary_string
end

# contents = File.readlines('opcode.txt')
# opcode_dict = {}
# opcode_dict["ADD"]  = "000000"
# opcode_dict["SUB"]  = "000001"
# opcode_dict["AND"]  = "000010"
# opcode_dict["XOR"]  = "000011"
# opcode_dict["COM"]  = "000100"
# opcode_dict["MUL"]  = "000101"
# opcode_dict["ADDI"] = "000110"
# opcode_dict["LW"]   = "000111"
# opcode_dict["SW"]   = "001000"
# opcode_dict["BEQ"]  = "001001"
# opcode_dict["JR"]   = "001010"
# opcode_dict["JMP"]  = "001011"
# opcode_dict["JAL"]  = "001100"
# contents.each do |instruction|
#   puts convert_to_binary(instruction, opcode_dict).to_hex.rjust(8, "0").upcase << " // #{instruction.gsub(/\/\/.*/, "")}"
# end
