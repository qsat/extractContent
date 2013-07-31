# -*- coding: utf-8 -*-

#require "./fileCopy.rb"
#copy = FileCopy.new
#copy.exec "../../home/www/htdocs", "./src", "path.txt"


require "nokogiri"
require 'fileutils'
require 'kconv'

class ExtractContent

  def exec(src, dest, list)
    Dir.chdir File.expand_path File.dirname($0)

    found = {}
    result = {}
    notfound = []


    IO.foreach(list) do |path|
      path = path.strip

      next if found.key? path
      found[path] = true

      file = src + path

      unless File.exist? file
        notfound << path
        next
      end

      doc = Nokogiri::HTML.parse IO.read file, encoding: Encoding::EUC_JP

      elem = doc.css(
        "#hiddennavi, #headerline, #endline1, #endline2, #endline3")
      if result[ elem.length ].nil?
        result[ elem.length ] = []
      end

      result[ elem.length ] << path
      
      elem.remove()

      str = "<div id='main' class='single'>#{doc.css("body").inner_html}</div>"

      dir = dest + File::dirname(path)
      FileUtils.mkdir_p dir
      begin
        File.write dest+path, str.kconv(Kconv::UTF8, Kconv::EUC)
      rescue Encoding::UndefinedConversionError => e
        File.write dest+path, str
        p e, path
      end


      # nakahara, au 以外はディレクトリ変更なし。

    end
    puts "#hiddennavi, #headerline, #endline1, #endline2, #endline3"
    puts "のIDがついているヘッダフッタを削除する"
    puts ""
    puts ""
    putResult "該当ファイルが存在しない", notfound
    putResult "削除対象ヘッダフッタ：マッチなし", result[0]
    putResult "削除対象ヘッダフッタ：マッチ1つ",  result[1]
    putResult "削除対象ヘッダフッタ：マッチ2つ",  result[2]
    putResult "削除対象ヘッダフッタ：マッチ3つ", result[3]
    putResult "削除対象ヘッダフッタ：マッチ4つ", result[4]
  end

  def putResult(str, items)
    puts "#{str}： #{items.size}件"
    puts ""
    items.each do |i| puts i end
    puts ""
    puts ""

  end
end


ins = ExtractContent.new
ins.exec "../../home/www/htdocs", "./dest", "path.txt"

