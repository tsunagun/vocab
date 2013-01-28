# coding: UTF-8

# 手作業で入力した名前空間URIと語彙定義ファイルの対応表をRDFに変換する

require 'csv'

file = ARGV[0] || 'manual.csv'
CSV.open(file).each_with_index do |row, index|
  next if index.zero?
  unless row[2].nil?
    puts "<#{row[1]}> <http://purl.org/dc/terms/hasFormat> <#{row[2]}> ."
    puts "<#{row[2]}> <http://purl.org/dc/terms/format> <http://www.w3.org/ns/formats/RDF_XML> ."
  end
  unless row[3].nil?
    puts "<#{row[1]}> <http://purl.org/dc/terms/hasFormat> <#{row[3]}> ."
    puts "<#{row[3]}> <http://purl.org/dc/terms/hasFormat> <http://www.w3.org/ns/formats/N3> ."
  end
  unless row[4].nil?
    puts "<#{row[1]}> <http://purl.org/dc/terms/hasFormat> <#{row[4]}> ."
    puts "<#{row[4]}> <http://purl.org/dc/terms/hasFormat> <http://www.w3.org/ns/formats/N-Triples> ."
  end
  unless row[5].nil?
    puts "<#{row[1]}> <http://purl.org/dc/terms/hasFormat> <#{row[5]}> ."
    puts "<#{row[5]}> <http://purl.org/dc/terms/hasFormat> <http://www.w3.org/ns/formats/RDFa> ."
  end
end
