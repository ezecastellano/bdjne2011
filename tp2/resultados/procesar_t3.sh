#!/usr/bin/env bash

cat t3.out |grep LRU|grep ^1[^0]| awk -F "," '{print $2,$4}' > LRU1.csv
cat t3.out |grep LRU|grep ^2[^0]| awk -F "," '{print $2,$4}' > LRU2.csv
cat t3.out |grep LRU|grep ^5[^0]| awk -F "," '{print $2,$4}' > LRU5.csv
cat t3.out |grep LRU|grep ^10 | awk -F "," '{print $2,$4}' > LRU10.csv

cat t3.out |grep MRU|grep ^1[^0]| awk -F "," '{print $2,$4}' > MRU1.csv
cat t3.out |grep MRU|grep ^2[^0]| awk -F "," '{print $2,$4}' > MRU2.csv
cat t3.out |grep MRU|grep ^5[^0]| awk -F "," '{print $2,$4}' > MRU5.csv
cat t3.out |grep MRU|grep ^10 | awk -F "," '{print $2,$4}' > MRU10.csv

cat t3.out |grep FIFO|grep ^1[^0]| awk -F "," '{print $2,$4}' > FIFO1.csv
cat t3.out |grep FIFO|grep ^2[^0]| awk -F "," '{print $2,$4}' > FIFO2.csv
cat t3.out |grep FIFO|grep ^5[^0]| awk -F "," '{print $2,$4}' > FIFO5.csv
cat t3.out |grep FIFO|grep ^10 | awk -F "," '{print $2,$4}' > FIFO10.csv

for x in {1,2,5,10};
	do
	echo 'Difference FIFO LRU MRU' > iteration$x.csv
	join FIFO$x.csv LRU$x.csv | join - MRU$x.csv >> iteration$x.csv;
	
done;

rm -rf Iterations.csv;

for x in $(ls iteration*.csv);
	do
	echo $x >> Iterations.csv
	cat $x >> Iterations.csv;
	echo '' >> Iterations.csv;
done;
