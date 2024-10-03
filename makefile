#!/bin/bash
a:
	erl -sname a

b:
	erl -sname b

c:
	erl -sname c

d:
	erl -sname d


all:   
	python3 -c  \
		"print('aa'); \
   			print('bb'); \
			quit()"