%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(); 
void yyerror();
extern int j;
extern FILE *yyin;

%}

%union{char *id;}
%token ENTRADA SAIDA FIM ENQUANTO FACA INC DEC ZERA
%token<id>  ID NUM
%type <id> cmd cmds varlist id 

%%

program:
   
   ENTRADA varlist SAIDA varlist cmds FIM 
   /* abrir o arqivo */
   {    
       
        FILE *out = fopen("out.c", "w");
        if (out == NULL) exit(1);
        char* total = malloc(strlen($2) + strlen($4) + strlen($5) + 15);
        strcpy(total, "int main() {" );
        strcat(total, $2); strcat(total, $4); strcat(total, $5);
        strcat(total, "}");   
        fprintf(out, "%s", total);
        fclose(out);

        printf("Código C gerado com sucesso - resultado em ' out.c'\n");

        exit(0);
    }
    ;

    varlist: 
        varlist id {
        char* mostra = malloc(strlen($1) + strlen($2) + 1);
        strcpy(mostra, $1);
        strcat(mostra, $2);
        $$ = mostra;
}

| id {$$ = $1;}

;


id: 
  ID {
    char* mostra = malloc(strlen($1) + 11);
   strcpy(mostra, "int");
    strcat(mostra, $1); strcat(mostra, " = 0;\n");
    $$ = mostra;
  }
;


cmds:
  cmd cmds {
    char* mostra = malloc(strlen($1) + strlen($2) + 1);
    strcpy(mostra, $1); strcat(mostra, $2); $$ = mostra;
  }
  | cmd {$$ = $1;}
;

cmd:
ENQUANTO ID FACA cmds FIM {
char* mostra = malloc(strlen($2) + strlen($4) + 12); strcpy(mostra, "while(");
strcat(mostra, $2); strcat(mostra, "){\n"); strcat(mostra, $4); strcat(mostra, "}\n");
$$ = mostra;
}
;
| ID '=' ID {
    char* mostra = malloc(strlen($1) + strlen($3) + 6); strcpy(mostra, $1);
    strcat(mostra, " = "); strcat(mostra, $3); strcat(mostra, ";\n"); 
    $$ = mostra;
}

| ID '=' NUM {
    char* mostra = malloc(strlen($1) + strlen($3) + 6); strcpy(mostra, $1);
    strcat(mostra, " = "); strcat(mostra, $3); strcat(mostra, ";\n"); 
    $$ = mostra;

}

| INC '(' ID ')' {
    char* mostra = malloc(strlen($3) + 5); strcpy(mostra, $3);
    strcat(mostra, "++\n"); $$ = mostra
}

| DEC '(' ID ')' {
    char* mostra= malloc(strlen($3) + 5); strcpy(mostra, $3);
    strcat(mostra, "--\n"); 
    $$ = mostra;
}

| ZERA '(' ID ')' {
    char* mostra = malloc(strlen($3) + 7); strcpy(mostra, $3);
    strcat(mostra, " = 0\n"); 
    $$ = mostra;
}
;

%%

void yyerror(){
  fprintf(stderr, "Syntax error at line %d\n", j);
};   


int main (int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }

  return(0);
}
