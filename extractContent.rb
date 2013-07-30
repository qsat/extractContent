# -*- coding: utf-8 -*-

#require "./fileCopy.rb"
#copy = FileCopy.new
#copy.exec "../../home/www/htdocs", "./src", "path.txt"


require "nokogiri"

class ExtractContent
  def initialize
    Dir.chdir File.expand_path File.dirname($0)

    @selectors = [
      "body > #body",
      "table[width='100%'] td[valign='top'] > table[width='580']",
      "table[width='100%'] td[valign='top'] > table[width='540']",
    ]
  end

  def exec(src, dest, list)

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

      txt = ""
      txt << doc.css("body > #body").length.to_s
      txt << doc.css("body > #wrapper").length.to_s
      txt <<  doc.css("td[valign='top'] > table[width='580']").length.to_s
      txt << doc.css("table[width='100%'] td[valign='top'] > table[width='540']").length.to_s
      txt << doc.css("table[width='100%'] td[valign='top'] > table[width='750']").length.to_s
      txt << doc.css("table[width='100%'] td[valign='top'] > table[width='738']").length.to_s
      txt << doc.css("table[width='100%'] td[valign='top'] table[width='600']").length.to_s
      #hidenavi, headerline削除してbodyの内容を抽出
      txt << doc.css("body > table[width='620']").length.to_s
      #hidenavi, headerline削除してbodyの内容を抽出
      txt << doc.css("body > table[width='520']").length.to_s
      
      if txt.match /^0+$/
        unless file.match /xbanner|chtml|php/
          p txt  + " " + path
        end
      end
      p txt  + " " + path

      # nakahara, au 以外はディレクトリ変更なし。

    end
  end
end


ins = ExtractContent.new
ins.exec "./src", "./dest", "path.txt"


### body以下をそのままコピー
#support/setup/mansion/manual.html
#en/setting_mannual.html
#shared/html/assisance.html
#sys/tag/tag_help.html
#userpage/road/index.html
#support/setup/internet/cgi/246_guest_example.html
#userpage/road/index.html
#itscom-ch/access/go/lh-tekuteku.html redirect
#userpage/go/train.html  redirect
#signup/index.html
#contents/police/index.html
