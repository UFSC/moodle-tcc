# encoding: utf-8

# Descobre o diretório do texlive no linux e mac
texlive_bin_dir = Dir.glob('/usr/local/texlive*/20*/bin/x86_64-*').first
if texlive_bin_dir.nil?
  system("#{Rails.root}/latex/latex-docker-installed.sh")
  if $? != 0
    $stderr.puts 'Texlive não está instalado corretamente, nem como docker (docker pull blang/latex)'
    exit 1
  end
end

ENV['PATH']="#{texlive_bin_dir}:#{ENV['PATH']}"
LatexToPdf.config[:arguments].delete('-halt-on-error')
LatexToPdf.config.merge! :distro => :xelatex, bibtex: true, :dockerImage => Settings.docker_image
