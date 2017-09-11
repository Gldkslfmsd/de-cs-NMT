all: europarl.cs europarl.de

#opensub_cs:
#	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fmono%2FOpenSubtitles2016.cs.gz \
#	-O opensub_cs.gz
#
#opensub_de:
#	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fmono%2FOpenSubtitles2016.de.gz \
#	-O opensub_de.gz
#

download europarl_cs_de.tmx.gz:
	wget http://opus.lingfil.uu.se/download.php?f=Europarl/cs-de.tmx.gz -O europarl_cs_de.tmx.gz

unzip europarl_cs_de.tmx: europarl_cs_de.tmx.gz
	gzip -d europarl_cs_de.tmx.gz

P3=p3/bin/python3

install_langdetect $(P3):
	virtualenv -p python3 p3
	p3/bin/pip install langdetect


preproces europarl.raw.cs europarl.raw.de: europarl_cs_de.tmx
	grep '<tuv xml:lang="de">' europarl_cs_de.tmx | sed -r 's/^ *<tuv xml:lang="de"><seg>//;s#</seg></tuv>$$##;s/[0-9]+\. ?//' > europarl.raw.de
	grep '<tuv xml:lang="cs">' europarl_cs_de.tmx | sed 's/^ *<tuv xml:lang="cs"><seg>//;s#</seg></tuv>$$##;s/[0-9]+\. ?//' > europarl.raw.cs

clean_langs: $(P3) clean_languages.py europarl.raw.cs europarl.raw.de
	$(P3) clean_languages.py europarl.raw.cs europarl.raw.de europarl.cs europarl.de
	


