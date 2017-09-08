
download test.tgz:
	wget http://www.statmt.org/wmt13/test.tgz -O test.tgz

unzip test: test.tgz
	gunzip test.tgz
	tar -xvf test.tar

copy news.cs news.de: test
	sed 's/<[^>]*>//g' test/newstest2013-src.cs.sgm | grep . > news.cs
	sed 's/<[^>]*>//g' test/newstest2013-src.de.sgm | grep . > news.de


	

clean:
	rm -rf test/

