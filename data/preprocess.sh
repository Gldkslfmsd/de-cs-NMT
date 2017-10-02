MOSES=moses/scripts/tokenizer
		perl $MOSES/remove-non-printing-char.perl | \
		perl $MOSES/replace-unicode-punctuation.perl | \
		perl $MOSES/normalize-punctuation.perl 
