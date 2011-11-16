#!/usr/bin/env python

def conjuntizar(entradas, i):
	res = list(set([x[i] for x in entradas]))
	res.sort()
	return res

def dosplitandtuple(entrada):
	entrada = entrada.split(',')
	return (int(entrada[0]), entrada[1], int(entrada[2]), float(entrada[3]))

f = file('t2.out','r')
datos = f.read()
f.close()
entradas = [dosplitandtuple(entrada) for entrada in datos.splitlines()[1:]]

seq = conjuntizar(entradas, 2)
buf_num = conjuntizar(entradas, 0)
strat = conjuntizar(entradas, 1)

eldic = {}
for x in seq:
	eldic[x] = {}
	for buf_n in buf_num:
		eldic[x][buf_n] = {}
		for s in strat:
			eldic[x][buf_n][s] = {}

for x in entradas:
	eldic[x[2]][x[0]][x[1]] = x[3]

for x in seq:
	for y in buf_num:
		print x, y, eldic[x][y]['FIFO'], eldic[x][y]['LRU'], eldic[x][y]['MRU']


