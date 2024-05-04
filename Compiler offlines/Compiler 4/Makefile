main:
	yacc -d -y 2005057.y
	g++ -w -c -o y.o y.tab.c
	flex 2005057.l
	g++ -w -c -o l.o lex.yy.c
	g++ y.o l.o -lfl -o 2005057
	./2005057 noerror.c