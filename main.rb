# coding: UTF-8

require 'csv'
require 'uri'
require 'net/http'
require 'linkeddata'

source = ARGV[0] || 'all_20130125.csv'

class Vocabulary
	attr_accessor :uri, :prefix, :formats
	def initialize
		@formats = Array.new
	end

	def to_rdf_statements
		statements = Array.new
		statements << "<#{uri}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#Ontology> ."
		statements << "<#{uri}> <http://purl.org/vocab/vann/preferredNamespacePrefix> \"#{@prefix}\" ."
		formats.each do |format|
			statements << "<#{uri}> <#{RDF::DC.hasFormat}> <#{format[:location]}> ."
			statements << "<#{format[:location]}> <#{RDF::DC.format}> <#{format[:uri]}> ."
		end
		statements.each do |statement|
			puts statement.to_s
		end
	end
end

def fetch(uri, header = {}, limit = 10)
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

	http = Net::HTTP.new(uri.host, uri.port)
	response = http.get(uri.path, header)
  case response
  when Net::HTTPSuccess
    [uri, response]
  when Net::HTTPRedirection
    fetch(URI.parse(response['location']), header, limit - 1)
  else
    response.value
  end
end

CSV.open(source).each do |row|
	next if row[1] == ""
	vocabulary = Vocabulary.new
	vocabulary.prefix = row[0]
	vocabulary.uri = URI.parse(row[1])
	formats = [
		{:uri => "http://www.w3.org/ns/formats/RDF_XML", :content_type => "application/rdf+xml"},
		{:uri => "http://www.w3.org/ns/formats/N-Triples", :content_type => "text/plain"},
		{:uri => "http://www.w3.org/ns/formats/Turtle", :content_type => "application/x-turtle"},
		{:uri => "http://www.w3.org/ns/formats/N3", :content_type => "text/n3"},
		#{:uri => "http://www.w3.org/ns/formats/RDFa", :content_type => "application/xhtml+xml"}
	]
	formats.each do |format|
		response = nil
		request = nil
		begin
			timeout(20) do
				request, response = fetch(vocabulary.uri, "Accept" => format[:content_type])
			end
		rescue Timeout::Error
			next
		rescue
			next
		end
		if response.content_type == format[:content_type]
			location = response["content-location"] || response["Content-Location"]
			location = location.nil? ? request : request.merge(location)
			vocabulary.formats << {:uri => format[:uri], :location => location}
		end
	end
	vocabulary.to_rdf_statements
end
