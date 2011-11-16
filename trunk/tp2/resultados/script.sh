cat t3.out |grep MRU|grep ^1[^0]| awk -F "," '{print $2,$4}' > MRU1.csv
cat t3.out |grep MRU|grep ^2[^0]| awk -F "," '{print $2,$4}' > MRU2.csv
cat t3.out |grep MRU|grep ^5[^0]| awk -F "," '{print $2,$4}' > MRU5.csv
cat t3.out |grep MRU|grep ^10 | awk -F "," '{print $2,$4}' > MRU10.csv

cat t3.out |grep FIFO|grep ^1[^0]| awk -F "," '{print $2,$4}' > FIFO1.csv
cat t3.out |grep FIFO|grep ^2[^0]| awk -F "," '{print $2,$4}' > FIFO2.csv
cat t3.out |grep FIFO|grep ^5[^0]| awk -F "," '{print $2,$4}' > FIFO5.csv
cat t3.out |grep FIFO|grep ^10 | awk -F "," '{print $2,$4}' > FIFO10.csv
