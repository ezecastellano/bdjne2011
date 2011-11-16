#!/usr/bin/env python

def conjuntizar(entradas, i):
	return list(set([x[i] for x in entradas]))

f = file('t2.out','r')
datos = f.read()
f.close()
entradas = [tuple(entrada.split(',')) for entrada in datos.splitlines()[1:]]

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

for x in eldic:
	for y in eldic[x]:
		print x, y, eldic[x][y]['FIFO'], eldic[x][y]['LRU'], eldic[x][y]['MRU']


