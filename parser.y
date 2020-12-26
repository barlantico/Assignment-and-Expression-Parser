/*
* Brian Arlantico, cssc3010, 821125494
* CS530 Fall 2020
* Assignment 3, Parser
* parser.y
*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
extern char yytext[];
%}
%error-verbose
%token <sval>ID
%token <sval>OP
%token <sval>SEMICOLON
%token NEWLINE
%token <sval>ASSIGNMENT_NL
%token END_OF_FILE
%token <sval>EQUALS
%token <sval>OPEN_PARENS
%token <sval>CLOSE_PARENS
%token <sval>INT
%token <sval>UNKNOWN
%token <sval>INVALID_ID
%union {
    char *sval;
}

%%
next:line
    |next line 
    ;

line:NEWLINE {}
    |END_OF_FILE {return 0;}
    |assignment NEWLINE {printf("VALID ASSIGNMENT\n");}
    |expr NEWLINE {printf("VALID EXPRESSION\n");} 
    |invassignment {}
    |error {yyerrok;}
    ;

assignment:id equals expr semicolon
    ;

invassignment: id equals expr NEWLINE {printf("Error: syntax error, expecting SEMICOLON. Specifically, ;\n");}
    ;

expr:id 
        |expr op expr
        |oparen expr cparen
        ;


id : ID {printf("%s ", $1);};
op : OP {printf("%s ", $1);};
equals: EQUALS {printf("%s ", $1);};
oparen: OPEN_PARENS {printf("%s ", $1);};
cparen: CLOSE_PARENS {printf("%s ", $1);};
semicolon : SEMICOLON {printf("%s ",$1);};

%%
int main(void)
{
    FILE* inputFile = fopen("statements.txt", "r");
    
    if (inputFile == NULL) { /* exits if file not found */
        printf("Error: statements.txt cannot be opened.\n");
        return 0;
    }
    
    yyin = inputFile; /* parsers reading from file */
    yyparse(); /* begin parsing process */
    return 0;  
}

int yyerror(const char *s)
{
 int ntoken = 0; /* saves token type*/
 char* t = yylval.sval; /* temp char* for printing rest of sentence */
 char* err = strdup(yylval.sval); /* saves string that caused error */
 printf("%s ", t);
 while (1) { /*continues to print the sentence after the error */
 ntoken = yylex();
 if (ntoken == NEWLINE)
    break;
 t = yylval.sval;
 printf("%s ", t);
 }

 printf("Error: %s. Specifically, %s\n", s,err); /* Prints error */
 yyparse(); /* resume parsing process */
 return 1;
}