# -*- coding: utf-8 -*-

require 'fileutils'

class FileCopy
  def exec (src, dest, list)
    Dir.chdir(File.expand_path(File.dirname($0)))

#    list = 'path.txt'
#    src  = '/Users/macbookpro/project/htdocs'
#    dest = '/Users/macbookpro/project/output'

    found    = {}
    notfound = []

    IO.foreach(list) do |path|
      path.strip!
      next if found.key? path
      found[path] = true
      file = src + path
      unless File.exist? file
        notfound << path
        next
      end
      dir = dest + File::dirname(path)
      FileUtils.mkdir_p(dir)
      FileUtils.cp(file, dir)
    end

    File.open('notfound.txt', 'w:utf-8') do |f|
      f.write notfound.join("\n")
    end
  end
end
