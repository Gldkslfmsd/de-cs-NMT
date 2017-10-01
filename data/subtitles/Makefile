
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
