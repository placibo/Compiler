%{
        #include<stdio.h>
        #include<ctype.h>
        void yyerror (char *s);
        int yydebug=1;
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
				
    class     : CLASS TYPEID '{'feature_list'}' ';' { }
                ;

    feature_list : feature ';' {}
                 | feature_list feature ';' {}
                 ;
                  
    feature     : OBJECTID '('formal')' ':' TYPEID '{'expr_list  '}' {  }
                ;
    formal        : OBJECTID ',' formal        {}
                | OBJECTID        {}
                |        {}
                ;
    
	   expr        : OBJECTID ASSIGN expr {}
                | OBJECTID '(' param_expr ')' {}
		| IF expr THEN expr  ifextented{}
                | WHILE expr LOOP expr POOL {}
                | '(' expr ')' { }
                | expr '+' expr {  }
                | expr '-' expr { }
                | expr '*' expr { }
                | expr '/' expr {}
                | '~' expr {  }
                | expr '<' expr { }
                | expr LE expr {  }
                | expr '=' expr {}
                | NOT expr {  }
                | OBJECTID { }					
                | '{' expr_list '}' {}
                | INT_CONST {}
                | STR_CONST {  }
                | BOOL_CONST {  }
				;
				
	
	ifextented	: ELSE expr FI{}
				| FI{}
	
    expr_list	: expr ';' { }
		| expr_list expr ';' { }

    param_expr          : expr {  }
                        | param_expr ',' expr {  }
                        | {  }
                        ;


%%

int main(void) 
{
	return yyparse();
}

void yyerror(char *s)	{	fprintf(stderr, "%s\n",s);	}