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

      elem = doc.css("#hiddennavi, #headerline, #endline1, #endline2, #endline3")
      
      elem.remove()

      str = doc.css("body").inner_html

      dir = dest + File::dirname(path)
      FileUtils.mkdir_p dir
      begin
        File.write dest+path, str.encode( "UTF-8", "EUC-JP" )
      rescue Encoding::UndefinedConversionError => e
        File.write dest+path, str
        p e, path
      end


      # nakahara, au 以外はディレクトリ変更なし。

    end
  end
end


ins = ExtractContent.new
ins.exec "./src", "./dest", "path.txt"

