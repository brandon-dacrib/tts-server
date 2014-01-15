require 'sinatra'

#todo 
#1. move the params to a config file
#2. work out a caching mechanism so that if the file exists then it isn't regenerated. 

tts_engine = "/usr/local/bin/swift"
tts_options = "-o"

encode_engine = "/usr/bin/lame"
encode_options = "-b 256 -h"

outfile = "/tmp/utter.mp3"

#need to add code to generate a random string/number for the query name 
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