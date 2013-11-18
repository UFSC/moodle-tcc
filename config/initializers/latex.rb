# encoding: utf-8

# Descobre o diretório do texlive no linux e mac
texlive_bin_dir = Dir.glob('/usr/local/texlive/2013/bin/x86_64-*').first
if texlive_bin_dir.empty?
  $stderr.puts 'Texlive não está instalado corretamente'
  exit 1
end

ENV['PATH']="#{texlive_bin_dir}:#{ENV['PATH']}"
LatexToPdf.config[:arguments].delete('-halt-on-error')
LatexToPdf.config.merge! parse_twice: true, bibtex: true