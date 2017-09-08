
# https://lindat.mff.cuni.cz/repository/xmlui/handle/11858/00-097C-0000-0008-D259-7

download:
	wget http://www.statmt.org/wmt11/test.tgz -O test.tgz
	gzip -d test.tgz
	tar -xvf test.tar

preprocess:
	sed  's/<[^>]*> *//g' newstest2011-src.cs.sgm | grep . > news11.cs
	sed  's/<[^>]*> *//g' newstest2011-src.de.sgm | grep . > news11.de


