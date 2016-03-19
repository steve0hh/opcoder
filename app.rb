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
