# lscleaner1.rb
# E Camden Fisher
# Simple script to cleanup X days of
# elasticsearch indexes from logstash 
# (expects indexes to be in the form: 
# logstash-YYYY.MM.DD)

require 'stretcher'
require 'date'

# number of days to keep
KEEP = 3

now = Date.today
keep_days_ago = (now - KEEP)

server = Stretcher::Server.new('http://127.0.0.1:9200')
server.status['indices'].each do |k,v|
	d = Date.parse k.gsub('logstash-','')
	raise if d.nil?
	if d < keep_days_ago
		puts "Deleting #{k}"
		server.index(k).delete rescue nil
	end
end