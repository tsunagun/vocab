# coding: UTF-8

# 語彙定義ファイルの取得に失敗した名前空間URIを見つける
#   現在は，事前にSPARQLエンドポイントにデータを登録しておく必要あり

require 'open-uri'
require 'cgi'
require 'sparql/client'

sparql =<<-EOF
SELECT ?uri ?prefix
FROM <http://purl.org/net/mdlab/vocab>
WHERE {
  ?uri <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2002/07/owl#Ontology> .
  ?uri <http://purl.org/vocab/vann/preferredNamespacePrefix> ?prefix .
  FILTER NOT EXISTS { ?uri <http://purl.org/dc/terms/hasFormat> ?format } 
}
EOF

endpoint_uri = "http://mdlab.slis.tsukuba.ac.jp/sparql"

endpoint = SPARQL::Client.new(endpoint_uri)
results = endpoint.query(sparql)
results.each do |result|
  puts "#{result[:prefix]},#{result[:uri]}"
end
