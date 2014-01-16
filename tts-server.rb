require 'sinatra'
require 'parseconfig'

#todo 
#1. work out a caching mechanism so that if the file exists then it isn't regenerated. 

######### pull variables from config file #########
config = ParseConfig.new('tts.conf')

tts_engine = config["tts_engine"]
tts_options = config["tts_options"]
encode_engine = config["encode_engine"]
encode_options = config["encode_options"]
outfile = config["outfile"]

############### actual app ################
get '/api/say/' do
	utter = URI.decode("#{params[:query]}")
	lang = params[:t]
	query = params[:q]
	
	#output the query to the log
	puts "#{query}"

	#puts "#{tts_engine} #{tts_options} /tmp/query.wav \'#{query}\'; #{encode_engine} /tmp/query.wav #{tts_options} #{outfile}"
	system("#{tts_engine} #{tts_options} /tmp/query.wav \'#{query}\'; #{encode_engine} /tmp/query.wav #{encode_options} #{outfile}")
	
	#define output
	@output = send_file '#{outfile}'
	
	#clean up after yourself #remove this once caching works
	system("rm -r /tmp/query.wav #{outfile}")
	
	#send output
	"#{@output}"
end