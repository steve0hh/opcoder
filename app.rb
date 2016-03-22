require 'sinatra'
require './convert.rb'

get '/' do
  # use the views/index.erb file
  erb :index
end

get '/help' do
  erb :help
end

post '/bullshit' do
  # filelines = params[:file][:tempfile].readline
  tempfile = params[:file][:tempfile]
  opcode_dict = {}
  opcode_dict["ADD"]  = "000000"
  opcode_dict["SUB"]  = "000001"
  opcode_dict["AND"]  = "000010"
  opcode_dict["XOR"]  = "000011"
  opcode_dict["COM"]  = "000100"
  opcode_dict["MUL"]  = "000101"
  opcode_dict["ADDI"] = "000110"
  opcode_dict["LW"]   = "000111"
  opcode_dict["SW"]   = "001000"
  opcode_dict["BEQ"]  = "001001"
  opcode_dict["JR"]   = "001010"
  opcode_dict["JMP"]  = "001011"
  opcode_dict["JAL"]  = "001100"
  out = Tempfile.new("tempfile")
  tempfile.readlines.each do |instruction|
    out << convert_to_binary(instruction, opcode_dict).to_hex.rjust(8, "0").upcase << " // #{instruction.gsub(/\/\/.*/, "")}"
  end
  out.close
  send_file out.path, :type => 'application/zip',
    :disposition => 'attachment',
    :filename => "imem_test0.txt",
    :stream => false
end

post '/convert' do
  lines_with_empty_lines = params[:editor].split("\n")
  lines = lines_with_empty_lines.reject { |c| c.empty? }
  opcode_dict = {}
  opcode_dict["ADD"]  = params[:add]
  opcode_dict["SUB"]  = params[:sub]
  opcode_dict["AND"]  = params[:and]
  opcode_dict["XOR"]  = params[:xor]
  opcode_dict["COM"]  = params[:com]
  opcode_dict["MUL"]  = params[:mul]
  opcode_dict["ADDI"] = params[:addi]
  opcode_dict["LW"]   = params[:lw]
  opcode_dict["SW"]   = params[:sw]
  opcode_dict["BEQ"]  = params[:beq]
  opcode_dict["JR"]   = params[:jr]
  opcode_dict["JMP"]  = params[:jmp]
  opcode_dict["JAL"]  = params[:jal]

  out = Tempfile.new("tempfile")
  lines.each_with_index do |instruction, index|
    instruction_number = "#{index}".rjust(8, "0")
    instruction_number = "#{instruction_number} "
    out << instruction_number << convert_to_binary(instruction, opcode_dict).to_hex.rjust(8, "0").upcase << " // #{instruction.gsub(/\/\/.*/, "")}"
  end
  out.close
  send_file out.path, :type => 'application/zip',
    :disposition => 'attachment',
    :filename => "imem_test0.txt",
    :stream => false
end
