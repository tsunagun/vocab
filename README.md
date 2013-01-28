# Vocabularies

## 概要

prefix.ccで公開されている[名前空間リスト](http://prefix.cc/popular/all.file.csv)を基に，名前空間URIと実際の語彙定義ファイルを関連付けたデータセットです．  
以下の2つのファイルををRDFリポジトリに登録することで，名前空間URIから実際の語彙定義ファイルを取得するなどの用途に利用できます．

  * **output_auto.nt**
  * **output_manual.nt**

## データ構造

スキーマを以下のファイルに[簡易DSP](http://www.meta-proj.jp/A04.pdf)で記述しています．

  * **simplified_dsp.txt**


## データ作成手順

1. 以下のContent-Typeを一つずつAccept Headerに付加しながら，それぞれの名前空間URIにアクセスする
  * RDF/XML : application/rdf+xml
  * Turtle : application/x-turtle
  * N-Triples : text/plain
  * N3 : text/n3
2. レスポンスのContent-Typeが1で使用したContent-Typeと同じならば，語彙定義ファイルを取得できたと判断する
3. 名前空間URIと語彙定義ファイルをdcterms:hasFormatで関連付けて，RDF形式で出力する
4. 3で出力したRDFファイルをリポジトリに登録する
5. 語彙定義ファイルの取得に失敗した名前空間URIをSPARQLで探しリストアップする
6. 語彙定義ファイルを手作業で探しCSVファイルに入力していく
7. 6で作成したCSVファイルから，名前空間URIと語彙定義ファイルを関連付けたRDFを出力する


## ファイルの説明

simplified_dsp.txt
  * 出力するRDFファイルのスキーマを簡易DSPで記述したもの．

all_20130125.csv
  * prefix.ccが公開する名前空間リスト(2013/01/25時点)

main.rb
  * 手順1から3を実行するスクリプト．prefix.ccが公開する名前空間リストから，名前空間URIと語彙定義ファイルを関連付けたRDF(N-Triples)を出力する．

output_auto.nt
  * 手順3の成果物．名前空間URIと語彙定義ファイルの関連付けをスクリプトで行ったもの．

list_no_file_namespace.rb
  * 手順5を実行するスクリプト．語彙定義ファイルを取得できなかった名前空間URIをリストアップする．

manual.csv
  * 手順6の成果物．手作業で入力した，名前空間URIと語彙定義ファイルの対応表

convert_manual_csv_to_rdf.rb
  * 手順7を実行するスクリプト．手作業で入力した名前空間URIと語彙定義ファイルの対応表をRDF(N-Triples)で出力する

output_manual.nt
  * 手順7の成果物．名前空間URIと語彙定義ファイルの関連付けを手作業で行ったもの．
