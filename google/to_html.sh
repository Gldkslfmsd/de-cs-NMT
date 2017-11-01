#!/bin/bash
echo '<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head><body>'

while read line; do
	echo $line
	echo '<br>'
done

echo  '</body></html>'
