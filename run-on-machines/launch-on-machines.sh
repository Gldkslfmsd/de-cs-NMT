QS="th preprocess.lua -train_src data/src-train.txt -train_tgt data/tgt-train.txt -valid_src data/src-val.txt -valid_tgt data/tgt-val.txt -save_data data/demo"
: > ok
#cat 10ips-dm |
#cat 5ips-de |
#echo bojar 13.65.37.251 -p 50010 | 
#cat new-machines |
cat new14 |
while read us ip; do 
		echo $us $ip; 
#		echo for s in \`find .\`\; do sudo chown $us \$s\; done  |
#		echo luarocks install tds |
#		echo cp csen-data/csen-onmt-data-train.t7 OpenNMT |
#		echo rm -rf OpenNMT/*.t7 |
#		echo cd OpenNMT \; th preprocess.lua -train_src data/src-train.txt -train_tgt data/tgt-train.txt -valid_src data/src-val.txt -valid_tgt data/tgt-val.txt -save_data data/demo |
#		echo cd OpenNMT \&\& th preprocess.lua -train_src \~/csen-data/train.bpe.cs -train_tgt \~/csen-data/train.bpe.en  -valid_src \~/csen-data/dev.bpe.cs -valid_tgt \~/csen-data/dev.bpe.en -save_data /mnt/csen-onmt-data  |
# 		echo rm -rf nvidia *out *log *pid *.err \; cd OpenNMT \; rm -rf nvidia *out *log *pid *err *pid# |
#		echo rm -rf abc cmd lsonmt* |
		echo "nohup [ ! -s par.running ] && ./launch-script.sh par &" |
#		echo "nohup ./launch-script.sh par &" |
#		echo cp /share/obo-machacek/install-onmt.sh . \; ./install-onmt.sh |
#		echo cp /share/obo-machacek/install-lua5.2.sh . \; ./install-lua5.2.sh |

#		echo source ~/.bashrc \; luarocks install tds  |
#		echo cp /share/obo-machacek/demo.sh . \; ./demo.sh |
#		echo cat ok |
#		echo luarocks list |
#		echo kill \`cat *.pid\`\; |
#		echo rm -rf *.err *.pid *.log *.out |
#		echo mkdir data-50k \; cp /share/obo-machacek/data-50k-csen/* data-50k |
#		echo chmod -x data-50k/* |

#		echo mkdir -p csen-data \; cd csen-data \; cp /share/obo-machacek/csen-data.tar.gz . \; tar -xzvf csen-data.tar.gz \; |
	
#		echo ps aux \| grep $us |
#		echo kill -9 \`cat *.pid\` |
#		echo ls -la OpenNMT* \> lsonmt\$\(hostname\) |

#		echo kill "\`ps aux | grep $us | grep train.lua | sed 's/ \+/ /g' | cut -f 2 -d\" \"\`" |



#		echo git clone https://github.com/Gldkslfmsd/de-cs-NMT.git |
#		echo mkdir -p /mnt/obo-machacek/subtitles |
#		echo cd de-cs-NMT \; git pull |
#		echo 'make -C ~/de-cs-NMT/data/subtitles osub.cs osub.de -j' |
#		echo 'make -C ~/de-cs-NMT/data osub.cs.bpe osub.de.bpe -j -B' |
		
#		echo mkdir -p /mnt/obo-machacek/subtitles |
#		echo cp /share/obo-machacek/data-osub-train.t7 /mnt/obo-machacek/subtitles/ |
		#echo ls -la /mnt/obo-machacek/subtitles/data-osub-train.t7 |

#		echo cp /share/obo-machacek/preserve_checkpoints.sh . |
#		echo nohup ./preserve_checkpoints.sh \& |

#		echo  cd /mnt \; sudo chown bojar . |
		ssh $us@$ip && echo $us $ip  >> ok || echo ko $us $ip >> ok &
done
wait
