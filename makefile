###########################################################
# Makefile Assignment 3
# Brian Arlantico, cssc3010, 821125494
# CS530 Fall 2020
# Assignment 3, Parser
# makefile
###########################################################
PROGRAM = parser
CC = gcc

all: ${PROGRAM}

${PROGRAM}.tab.c ${PROGRAM}.tab.h: ${PROGRAM}.y
	bison -d ${PROGRAM}.y

lex.yy.c: ${PROGRAM}.l ${PROGRAM}.tab.h
	flex ${PROGRAM}.l

${PROGRAM}: lex.yy.c ${PROGRAM}.tab.c ${PROGRAM}.tab.h
	${CC} -o ${PROGRAM} lex.yy.c ${PROGRAM}.tab.c -ly -ll
	
clean:
	rm ${PROGRAM} ${PROGRAM}.tab.c ${PROGRAM}.tab.h lex.yy.c