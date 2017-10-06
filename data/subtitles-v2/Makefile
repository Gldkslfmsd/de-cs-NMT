
jrc jrc.cs.gz jrc.de.gz:
	wget http://opus.lingfil.uu.se/download.php?f=JRC-Acquis%2Fmono%2FJRC-Acquis.cs.gz -O jrc.cs.gz & \
	wget http://opus.lingfil.uu.se/download.php?f=JRC-Acquis%2Fmono%2FJRC-Acquis.de.gz -O jrc.de.gz ; \
	wait

DIR=/mnt/obo-machacek/subtitles
#DIR=.
$(DIR)/osub.cs.gz:
	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fmono%2FOpenSubtitles2016.cs.gz -O $(DIR)/osub.cs.gz

$(DIR)/osub.de.tar.gz:
	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fmono%2FOpenSubtitles2016.de.gz -O $(DIR)/osub.de.gz

sub: $(DIR)/osub.de.tar.gz $(DIR)/osub.cs.gz

subxces $(DIR)/osub.cs-de.xml.gz:
	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fxml%2Fcs-de.xml.gz -O $(DIR)/osub.cs-de.xml.gz

osub.cs-de.xml.gz: $(DIR)/osub.cs-de.xml.gz
	ln -s $(DIR)/osub.cs-de.xml.gz osub.cs-de.xml.gz

tmx osub.cs-de.tmx.gz:
	wget http://opus.lingfil.uu.se/download.php?f=OpenSubtitles2016%2Fcs-de.tmx.gz -O $(DIR)/osub.cs-de.tmx.gz
	ln -s $(DIR)/osub.cs-de.tmx.gz .


osub.de: osub.cs-de.tmx.gz
	gunzip -c osub.cs-de.tmx.gz | grep '<tuv xml:lang="de">' | sed -r 's/^ *<tuv xml:lang="de"><seg>//;s#</seg></tuv>$$##;s/[0-9]+\. ?//' > osub.de

osub.cs: osub.cs-de.tmx.gz
	gunzip -c osub.cs-de.tmx.gz | grep '<tuv xml:lang="cs">' | sed -r 's/^ *<tuv xml:lang="cs"><seg>//;s#</seg></tuv>$$##;s/[0-9]+\. ?//' > osub.cs

/mnt/obo-machacek/subtitles/osub.cs.prep.tok.fixlI: osub.cs.prep.tok
	sed 's/\([a-z]\)I\([ýáěíeéioůúuoa ]\)/\1l\2/g'  osub.cs.prep.tok > /mnt/obo-machacek/subtitles/osub.cs.prep.tok.fixlI

osub.cs.clear osub.de.clear:  /mnt/obo-machacek/subtitles/osub.cs.prep.tok.fixlI /mnt/obo-machacek/subtitles/osub.de.prep.tok
	python3 clear-osub.py /mnt/obo-machacek/subtitles/osub.cs.prep.tok.fixlI /mnt/obo-machacek/subtitles/osub.de.prep.tok
	ln -s /mnt/obo-machacek/subtitles/osub.cs.prep.tok.fixlI.clear osub.cs.clear
	ln -s /mnt/obo-machacek/subtitles/osub.de.prep.tok osub.de.clear
	
