
%{
	#include<stdio.h>
	#include<ctype.h>
	void yyerror (char *s);
	int yydebug=1;
	int symbols[52];
	void assign(char a, int b);
	int getValue(char v);
%}

%union {
      int program;
      int class_;
      int feature;
      int expression;
      char id;
      int num;
    }
    %start program
  %token POOL IF STR_CONST WHILE ESAC CLASS LOOP OF BOOL_CONST  FI THEN  ELSE DARROW IN ERROR
  %token <id> OBJECTID TYPEID
  %token <num> INT_CONST

	%type <program> program
	%type <class_> class
	%type <feature> feature
	%type <expression> expr  
	%type <expressoin> expr_list  

    %right ASSIGN
    %left NOT
    %nonassoc LE '<' '='
    %left '+' '-'
    %left '*' '/'
    %left '~'
    %left '@'
    %left '.'


%%
    program     : class { }
                ;
				
    class     : CLASS TYPEID '{'feature  '}' ';' { }
                ;
                      
    feature     : OBJECTID '(' ')' ':' TYPEID '{'expr_list  '}' {  }
                ;
	expr        : OBJECTID ASSIGN expr { assign($1,$3); }
                | IF expr THEN expr ELSE expr FI {printf("HH%d",$2); if($2){$$=$4;}else{$$=$6;} }
                | WHILE expr LOOP expr POOL { printf("OUT%d",$2);while($2){ printf("N%d",$2);} }
		| '(' expr ')' { $$ = $2; printf("Hel%d",$$);}
                | expr '+' expr { $$ = $1 + $3;  }
                | expr '-' expr { $$ = $1 - $3;  }
                | expr '*' expr { $$ = $1 * $3;  }
                | expr '/' expr {  $$ = $1/$3; }
                | '~' expr {  }
                | expr '<' expr { $$ = $1< $3; printf("COMING"); }
                | expr LE expr {  }
                | expr '=' expr {  $$ = ($1==$3); }
                | NOT expr {  }
                | OBJECTID { $$ = getValue($1);}
		| '{' expr_list '}' {} 
                | INT_CONST { $$ = $1; }
                | STR_CONST {  }
                | BOOL_CONST {  }
                ;
    expr_list	: expr ';' { }
		| expr_list expr ';' { }

%%

int main(void) 
{
	int i;
	for(i =0; i<52;i++)	{	symbols[i] = 0;	}
	return yyparse();
}

int computeSymbolIndex( char token)
{
	int idx = -1;
	if(islower(token))	{	idx = token - 'a' +26;	}
	else if(isupper(token))	{	idx = token - 'A';}
	return idx;
} 


void assign(char a, int b)
{	
	int index=computeSymbolIndex(a);
	symbols[index]=b;
	printf("%c %d",a,b);
}

int getValue(char v){
	int index=computeSymbolIndex(v);
	return symbols[index];
}

void yyerror(char *s)	{	fprintf(stderr, "%s\n",s);	} 

