all: news13.cs news13.de

download test.tgz:
	wget http://www.statmt.org/wmt13/test.tgz -O test.tgz

unzip test: test.tgz
	gunzip test.tgz
	tar -xvf test.tar

copy news13.cs news13.de: test
	sed 's/<[^>]*>//g' test/newstest2013-src.cs.sgm | grep . > news13.cs
	sed 's/<[^>]*>//g' test/newstest2013-src.de.sgm | grep . > news13.de


	

clean:
	rm -rf test/

