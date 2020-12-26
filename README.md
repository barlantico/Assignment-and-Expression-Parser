# Assignment-and-Expression-Parser

Brian Arlantico, 821125494

CS530 Fall 2020

Assignment #3, Parser 


The following are discussed in this file:
1. BNF Grammar
2. File Manifest
3. Compile and run instructions
4. Issues, if any
5. Lessons learned, significant findings

1. BNF Grammar

	<next>          ::= <line> | <next><line>
	<line>          ::= <NEWLINE> | <END_OF_FILE> | assignment NEWLINE | expr NEWLINE | invassignment 
	<assignment>    ::= <id><equals><expr><semicolon>
	<invassignment> ::= <id><equals><expr><NEWLINE> 
	<expr>          ::= <id> | <expr><op><expr> | <oparen><expr><cparen>
  
	<id>          ::= <char> | <id><char> | <id><digit>
	<op>          ::= '+' | '-' | '*' | '/' | '%'
	<equals>      ::= '='
	<oparen>      ::= '('
	<cparen>      ::= ')'
	<semicolon>   ::= ';'
	<NEWLINE>     ::= "\n"
	<END_OF_FILE> ::= <<EOF>>


<char>  ::=  a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|
             A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z
<digit> ::=  0|1|2|3|4|5|6|7|8|9


2. Files in directory:
 - parser.l
 - parser.y
 - statements.txt
 - makefile
 - README

3. Compile instrucitons:
run make and an executable parser will be created

Operating instructions:
Once compiled, ensure statements.txt is present in the directory, as the program is 
hardcoded to open that file exclusively. If present, simply run

	parser

and all statements with their evaluations (valid / invalid with reason) will be printed
to stdout. 

To remove all the files produced by make, simply enter
    
    make clean

NOTICE: each statement (assignment/expression) ends with a new line so there should be an
extra line at the bottom of statements.txt


4. Issues/Bugs:
Since my program disregarded spaces, it is not able to differentiate between some tokens, one in 
particular is seen in the example file that can be found in canvas:

 bad +- delta
 bad + - delta

my program will just print the two sentences with spaces in between since my program recognizes 
the '+' and '-' as two separate tokens so stdout will look like:

 bad + - delta
 bad + - delta

and the error will be "unexpected '-'" for the first one instead of "unexpected '+-'", where
'+-' is considered as one token.

Another issue is when compiling (running make), I do get a warning:

parser.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]

I did try various things to remove this conflict, however every time I attempted to resovle it 
my grammar would no longer detect valid/invalid statements correctly. Ultimately I ended up leaving
it the way it is as it does work as intended, but a warning does print out after every compile. 

Lessons Learned: 
After attempting to start this program solely in C, I decided to bite the bullet and just play
around with flex/bison. It was difficult at first getting everything down but once I was able 
to figure it out, it was much much easier than trying to create a parser in C. After that, I ran
into two errors in particular. One major error I had was that the assignment/expression will stop 
printing the rest of the tokens right when it encounters an error, and the way I was able to fix 
it was to modify yyerror() so that it would be able to print the rest of the tokens. Another 
error that kept happening was that a missing semicolon would result in the next sentence's error
(if any) with being overridden with the missing semicolon error. This was fixed by defining the error
itself in the grammar so that the error detection of the parser would leave that alone and prevent
that error from overriding the next line. In my BNF grammar, this rule can be seen as invassignment.
