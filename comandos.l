%{

#include <stdio.h>
#include <string.h>
#include "comandos.tab.h"

int j = 1;


%}

var   ([_a-zA-Z][_a-zA-Z0-9]*)
n ([0-9]+)

%option noyywrap

%%

ENTRADA {return(ENTRADA);}
SAIDA   {return(SAIDA);}
ENQUANTO {return(ENQUANTO);}
FACA     {return(FACA);}
SAIDA    {return(SAIDA);}
INC      {return(INC);}
ZERA     {return(ZERA);}
DEC      {return(DEC);}
FIM      {return(FIM);}
[=()]    { return yytext[0];}
{var}    { yylval.id=strdup(yytext); return (ID); }
{n}      { yylval.id=strdup(yytext); return (NUM); }
[\n]     {j++;}
.          ;

%%