%{
	#include "y.tab.h"
	#include <stdio.h>
#include <stdlib.h>
#define MAX_STR_CONST 1025
char  string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;
int buffersize;
int flag=0;


 int curr_lineno=0;
%}


A   [aA]
B   [bB]
C   [cC]
D   [dD]
E   [eE]
F   [fF]
G   [gG]
H   [hH]
I   [iI]
J   [jJ]
K   [kK]
L   [lL]
M   [mM]
N   [nN]
O   [oO]
P   [pP]
Q   [qQ]
R   [rR]
S   [sS]
T   [tT]
U   [uU]
V   [vV]
W   [wW]
X   [xX]
Y   [yY]
Z   [zZ]

%x COMMENT
%x STRING 

%%

 /* Keywords  */
{C}{L}{A}{S}{S}							{ return (CLASS); }
{E}{L}{S}{E}							{ return (ELSE); }
f{A}{L}{S}{E}							{ return (BOOL_CONST); }	/*---  -------*/
{F}{I}								{ return (FI); }
{I}{F}								{ return (IF); }
{I}{N}								{ return (IN); }
{L}{O}{O}{P}							{ return (LOOP); }
{P}{O}{O}{L}							{ return (POOL); }
{T}{H}{E}{N}							{ return (THEN); }
{W}{H}{I}{L}{E}							{ return (WHILE); }
{E}{S}{A}{C}							{ return (ESAC); }
{O}{F}								{ return (OF); }
{N}{O}{T}							{ return (NOT); }
t{R}{U}{E}							{ return (BOOL_CONST); } 	/*----------*/
"=>"								{ return (DARROW); }
"<-"								{ return (ASSIGN); }
"<="								{ return (LE); }
[0-9]+								{ return (INT_CONST);}		/*--- ------------------*/
[.@~*/+-<={}();:,]						{ return (int)(yytext[0]);}
"(*" 								{ BEGIN(COMMENT);}       
<COMMENT>"*)"							{ BEGIN(INITIAL);}
<COMMENT>\n							{ curr_lineno++; }	/*---Mid option is not there where eof is enconuntered ------------------*/
<COMMENT>.							{}  
<COMMENT><<EOF>>           					{ BEGIN(INITIAL);
           							  return (ERROR);
								}
[\ \f\r\t\v]							{}
[a-z][a-zA-Z]*							{  return (OBJECTID);}
[A-Z][a-zA-Z]*							{  return (TYPEID);}

\"								{ BEGIN(STRING);string_buf_ptr=string_buf; }
<STRING><<EOF>>            					{ BEGIN(INITIAL);
           							  return (ERROR); 
								}
  
<STRING>.							{
									if(buffersize>MAX_STR_CONST){
										return (ERROR);
									} else{
										char tchar=yytext[0];
										if(flag==1){
											switch(tchar){
												case 'n':	{*string_buf_ptr++ = '\n';buffersize++;break;}
												case 't':	{*string_buf_ptr++ = '\t'; buffersize++;break;}
												case 'r':	{*string_buf_ptr++ = '\r';buffersize++; break;}
												case 'b':	{*string_buf_ptr++ = '\b';buffersize++; break;}
												case 'f':	{*string_buf_ptr++ = '\n';buffersize++; break;}
												case '"':	{*string_buf_ptr++ = '"'; buffersize++;break;}
												case '\\':	{*string_buf_ptr++ = '\\';buffersize++; break;}
												case '0':	{BEGIN(INITIAL);
														return (ERROR);}
												default: {*string_buf_ptr++ = tchar;buffersize++; break;}
											}
											flag=0;
										} else {
											if(tchar=='\\') {
												flag=1; 
											} else {
												if(tchar=='"') {
													BEGIN(INITIAL);
													buffersize=0;
									                                return (STR_CONST);
												} else  {
													*string_buf_ptr++ = yytext[0];buffersize++;
												}
											}
										}
									}			
								}
%%

int yywrap(void) {return 1;}