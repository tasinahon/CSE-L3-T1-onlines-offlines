%option noyywrap
%option yylineno
%x MYSTATE
%x COMMENT
%x MULTILINE_STRING
%x SINGLE_COMMENT
%x CURLY_BRACE
%x MANAGE



%{
#include<bits/stdc++.h>
#include<stdio.h>
#include "2005057.cpp"
FILE *logout;
FILE *tokenout;
int line_count=1;
int id_c=0;
int errors=0;
string s="";
char *comment=NULL;
int position=0;
int length=3000;
int initial=0;
int indentation = 0;
int last_indentation = 0;
int last_tabs = 0;
int last_spaces = 0;
int warnings=0;
int current_indent=0;
int actual_spaces=0;
int actual_tabs=0;
int curly_brace=0;
int track_line_no;
SymbolTable symbol_table(10);
ScopeTable *scope=symbol_table.get_current_scope();

void for_insert(string name,string type)
{
    
  
    SymbolInfo *symbolinfo=new SymbolInfo(name,type);
    bool t=symbol_table.Insert_Symbol(symbolinfo,logout);
    if(t)
    {
        symbol_table.Print_all_scopetable(logout);
    }
    
   
}
char real_char(char* yytext)
{
  char actualChar;
  if(yytext[1]=='\\'){
       switch(yytext[2]) {
        case 'n': actualChar = '\n'; break;
        case 't': actualChar = '\t'; break;
        case 'f': actualChar = '\f'; break;
        case 'r': actualChar = '\r'; break;
        case 'b': actualChar = '\b'; break;
        case 'v': actualChar = '\v'; break;
        case 'a': actualChar = '\a'; break;
        case '0': actualChar = '\0'; break;
        case '\\': actualChar = '\\'; break;
        case '\'': actualChar = '\''; break;
        case '\"': actualChar = '\"'; break;
        default: actualChar = yytext[1];  
    }
    return actualChar;
  }
  else{
    actualChar=yytext[1];
    return actualChar;
  }
    
}
char* char_replace(char* yytext) {
    size_t len = strlen(yytext);
    char* result = (char*)malloc((len + 1) * sizeof(char)); 

    size_t result_index = 0;
    for (size_t i = 1; i < len-1; i++) {
        if (yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == 't') {
            result[result_index++] = '\t';
            i++; 
        }
        else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == 'v'){
           result[result_index++] = '\v';
           i++; 
        }
          else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == 'b'){
           result[result_index++] = '\b';
           i++; 
        }
          else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == 'a'){
           result[result_index++] = '\a';
           i++; 
        }
         else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == '0'){
           result[result_index++] = '\0';
           i++; 
        }
         else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == 'n'){
           result[result_index++] = '\n';
           i++; 
        }
         else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == '"'){
           result[result_index++] = '\"';
           i++; 
        }
         else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == '\''){
           result[result_index++] = '\'';
           i++; 
        }
         else if(yytext[i] == '\\' && i + 1 < len && yytext[i + 1] == '\\'){
           result[result_index++] = '\\';
           i++; 
        }
         else {
            result[result_index++] = yytext[i];
        }
    }

    result[result_index] = '\0';

    return result;
}
char* char_replace_multiline_string(char* yytext) {
    size_t len = strlen(yytext);
    char* result = (char*)malloc((len + 1) * sizeof(char));
    size_t result_index = 0;

    for (int i = 1; i < len-1; i++) {
        if (yytext[i] == '\\' && yytext[i + 1] == '\n') {
            i++;  // Skip the newline
        } else {
            result[result_index++] = yytext[i];
        }
    }

    result[result_index] = '\0';

    return result;
}


    

%}

DIGITS ([0-9]+)
EXPONENT ([E][+-]?{DIGITS})
CONST_CHAR ([a-zA-Z][ ]*|\\n|\\t|\\f|\\r|\\b|\\v|\\a|\\0|\\\\|\\\'|\\\")
EXPO_NUM {DIGITS}{EXPONENT}(\.)*|{DIGITS}\.{DIGITS}?{EXPONENT}?(\.)*|\.{DIGITS}{EXPONENT}?


%%
^[^ \tv\{}\n].* {
  yyless(0);
  if(curly_brace){
  
  
  int fixed_tabs=scope->get_fixed_indentation();
  if(fixed_tabs!=0){
    fprintf(logout, "Line# %d: warning, %d of tabs needed but got 0 tabs.\n",line_count,fixed_tabs);
    warnings++;
  }
  }
}

^[ \t]* {
      int actual_spaces = 0;
    int actual_tabs = 0;

    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == ' ') {
            actual_spaces++;
        } else if (yytext[i] == '\t') {
            actual_tabs++;
        }
    }

    

    int fixed_spaces = scope->get_fixed_indentation();
    int fixed_tabs = scope->get_fixed_indentation();
    
    
    int diff_tabs=actual_tabs-fixed_tabs;
    if((diff_tabs>0|| diff_tabs<0) && actual_spaces==0 )
    {
      fprintf(logout, "Line# %d: warning, %d of tabs needed but got %d tabs.\n", line_count, fixed_tabs, actual_tabs);
      warnings++;
    }
    if((diff_tabs>=0 || diff_tabs<=0) && actual_spaces!=0)
    {
      fprintf(logout, "Line# %d: Warning, tab requrired but got space.\n",line_count);
      warnings++;
    }
    

   
}













"if"	{
			fprintf(logout,"Line# %d: Token <IF> Lexeme %s found\n",line_count,yytext);
      fprintf(tokenout,"<IF, %s>\n",yytext);

			
		}
"else"	{
			fprintf(logout,"Line# %d: Token <ELSE> Lexeme %s found\n",line_count,yytext);
      fprintf(tokenout,"<ELSE, %s>\n",yytext);
		}
"for"   {
        fprintf(logout,"Line# %d: Token <FOR> Lexeme %s found\n",line_count,yytext);
        fprintf(tokenout,"<FOR, %s>\n",yytext);
}
"do"  {
    fprintf(logout,"Line# %d: Token <DO> Lexeme %s found\n",line_count,yytext);
    fprintf(tokenout,"<DO, %s>\n",yytext);
}

"int"  {
   fprintf(logout,"Line# %d: Token <INT> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<INT, %s>\n",yytext);
}

"float" {
   fprintf(logout,"Line# %d: Token <FLOAT> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<FLOAT, %s>\n",yytext);
}
"void" {
  fprintf(logout,"Line# %d: Token <VOID> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<VOID, %s>\n",yytext);
}
"switch" {
   fprintf(logout,"Line# %d: Token <SWITCH> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<SWITCH, %s>\n",yytext);
}
"default" {
   fprintf(logout,"Line# %d: Token <DEFAULT> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<DEFAULT, %s>\n",yytext);
}
"while"  {
   fprintf(logout,"Line# %d: Token <WHILE> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<WHILE, %s>\n",yytext);
}
"break"  {
  fprintf(logout,"Line# %d: Token <BREAK> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<BREAK, %s>\n",yytext);
}
"char"  {
  fprintf(logout,"Line# %d: Token <CHAR> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<CHAR, %s>\n",yytext);
}


"double"  {
   fprintf(logout,"Line# %d: Token <DOUBLE> Lexeme %s found\n",line_count,yytext);
   fprintf(tokenout,"<DOUBLE, %s>\n",yytext);
}
"return" {
  fprintf(logout,"Line# %d: Token <RETURN> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<RETURN, %s>\n",yytext);
}
"case"  {
  fprintf(logout,"Line# %d: Token <CASE> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<CASE, %s>\n",yytext);
}
"continue" {
  fprintf(logout,"Line# %d: Token <CONTINUE> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<CONTINUE, %s>\n",yytext);
}
[0-9]+ {
    fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",line_count,yytext);
    fprintf(tokenout,"<CONST_INT, %s>\n",yytext);
}

{DIGITS}{EXPONENT}|{DIGITS}\.{DIGITS}?{EXPONENT}?|\.{DIGITS}{EXPONENT}?  {
  fprintf(logout,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<CONST_FLOAT, %s>\n",yytext);
}


\'[ \t\f\r\v]*\'    {
    fprintf(logout,"Error at line# %d: EMPTY_CONST_CHAR %s\n",line_count,yytext);
     errors++;
}

\'([a-zA-Z]|\\n|\\t|\\f|\\r|\\b|\\v|\\a|\\0|\\\\|\\\'|\\\")\'   {
    char actualChar=real_char(yytext);
    fprintf(logout, "Line# %d: Token <CONST_CHAR> Lexeme %c found\n", line_count, actualChar);
    fprintf(tokenout,"<CONST_CHAR, %c>\n",actualChar);
    
}





"+"|"-" {
  fprintf(logout,"Line# %d: Token <ADDOP> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<ADDOP, %s>\n",yytext);
}
"*"|"/"|"%" {
  fprintf(logout,"Line# %d: Token <MULOP> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<MULOP, %s>\n",yytext);
}
"++"|"--" {
 fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",line_count,yytext);
 fprintf(tokenout,"<INCOP, %s>\n",yytext);
}
"<"|"<="|">"|">="|"=="|"!=" {
 fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",line_count,yytext);
 fprintf(tokenout,"<RELOP, %s>\n",yytext);
}
"=" {
  fprintf(logout,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<ASSIGNOP, %s>\n",yytext);
}
"&&"|"||" {
  fprintf(logout,"Line# %d: Token <LOGICOP> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<LOGICOP, %s>\n",yytext);
}
"&"|"|"|"^"|"<<"|">>" {
  fprintf(logout,"Line# %d: Token <BITOP> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<BITOP, %s>\n",yytext);
}
"!" {
  fprintf(logout,"Line# %d: Token <NOT> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<NOT, %s>\n",yytext);
}
"(" {
  fprintf(logout,"Line# %d: Token <LPAREN> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<LPAREN, %s>\n",yytext);
}
")" {
  fprintf(logout,"Line# %d: Token <RPAREN> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<RPAREN, %s>\n",yytext);
}
"{" {

  symbol_table.Enter_Scope();
  scope=symbol_table.get_current_scope();
  fprintf(logout,"Line# %d: Token <LCURL> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<LCURL, %s>\n",yytext);
  curly_brace=1;
  track_line_no=line_count;
}

[ \t]*\}  {
  
  symbol_table.Exit_Scope();
  scope=symbol_table.get_current_scope();
   int actual_spaces = 0;
    int actual_tabs = 0;
    int printed = 0;
    if(track_line_no!=line_count){
    for (int i = 0; i < yyleng; i++) {
        if (yytext[i] == ' ') {
            actual_spaces++;
        } else if (yytext[i] == '\t') {
            actual_tabs++;
        }
    }

    

    int fixed_spaces = scope->get_fixed_indentation();
    int fixed_tabs = scope->get_fixed_indentation();
    
    int diff_tabs=actual_tabs-fixed_tabs;
    if((diff_tabs>0|| diff_tabs<0) && actual_spaces==0 )
    {
      fprintf(logout, "Line# %d: warning, %d of tabs needed but got %d tabs.\n", line_count, fixed_tabs, actual_tabs);
      warnings++;
    }
    if((diff_tabs>=0 || diff_tabs<=0) && actual_spaces!=0)
    {
      fprintf(logout, "Line# %d: Warning, tab requrired but got space.\n",line_count);
      warnings++;
    }
   
    }
     for (int i = 0; i < yyleng; i++) {
        if (!printed && (yytext[i] == ' ' || yytext[i] == '\t')) {
            
            continue;
        }

      
        fprintf(logout, "Line# %d: Token <RCURL> Lexeme %c found\n", line_count, yytext[i]);
        fprintf(tokenout,"<RCURL, %c>\n",yytext[i]);
        printed = 1;
    }
    
    
   
   


}

"[" {
  fprintf(logout,"Line# %d: Token <LSQUARE> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<LSQUARE, %s>\n",yytext);
}
"]" {
  fprintf(logout,"Line# %d: Token <RSQUARE> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<RSQUARE, %s>\n",yytext);
}
"," {
  fprintf(logout,"Line# %d: Token <COMMA> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<COMMA, %s>\n",yytext);
}
";" {
  fprintf(logout,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",line_count,yytext);
  fprintf(tokenout,"<SEMICOLON, %s>\n",yytext);
}


[a-zA-Z\_][a-zA-Z0-9\_]* {
  
    
    fprintf(logout,"Line# %d: Token <ID> Lexeme %s found\n",line_count,yytext);
    fprintf(tokenout,"<ID, %s>\n",yytext);
    for_insert(yytext,"ID");
    id_c++;
}






\/\/([^\n]|\\\n)* {

     fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",line_count,yytext);
     for(int i=0;i<yyleng;i++)
     {
      if(yytext[i]=='\n')
      {
        line_count++;
      }
     }
}






\"([^\"\\\n]|\\.)*?\"  {
 
    fprintf(logout, "Line# %d: Token <SINGLE LINE STRING> Lexeme %s found\n", line_count, yytext);
    char* a=char_replace(yytext);
    fprintf(tokenout,"<SINGLE LINE STRING, %s>\n",a);
}

\"([^\"\\\n]|\\.|\\\n)*?\" {
    fprintf(logout, "Line# %d: Token <MULTI LINE STRING> Lexeme %s found\n", line_count, yytext);
    char* r=char_replace_multiline_string(yytext);
    fprintf(tokenout,"<MULTI LINE STRING, %s>\n",r);
       for(int i=0;i<yyleng;i++)
     {
      if(yytext[i]=='\n')
      {
        line_count++;
      }
     }
   
}






[ \t\f\r\v]+  {}

\n {
    
    line_count++;
   
}
[0-9]*(\.)+[0-9\.]+(\.[0-9]*)*[E]?([0-9]+(\.[0-9]+)*)*  {
     fprintf(logout,"Error at line# %d: TOO_MANY_DECIMAL_POINTS %s\n",line_count,yytext);
     errors++;
}


\'({CONST_CHAR}{CONST_CHAR}+|\\[^tnfvbar0\']+)\'   {
    fprintf(logout,"Error at line# %d: MULTICHAR_CONST_CHAR %s\n",line_count,yytext);
    errors++;
}

\'([^\'\n]*|([\\][.]*(\')?))  {
    fprintf(logout, "Error at line# %d: UNFINISHED_CONST_CHAR %s\n", line_count, yytext);
    errors++;
}



([0-9]+|[0-9]+E[-]?|{DIGITS}{EXPONENT}|{DIGITS}\.{DIGITS}?{EXPONENT}?|\.{DIGITS}{EXPONENT}?)[a-zA-Z\_][a-zA-Z0-9\_]* {
    fprintf(logout,"Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n",line_count,yytext);
     errors++;
}
\"([^\"\\\n]|\\.|\\\n)* {
    fprintf(logout,"Error at line# %d: UNFINISHED_STRING %s\n",line_count,yytext);
     errors++;
        for(int i=0;i<yyleng;i++)
     {
      if(yytext[i]=='\n')
      {
        line_count++;
      }
     }
}
[^0-9a-zA-Z]  {
     fprintf(logout,"Error at line# %d: UNRECOGNIZED_CHAR %s\n",line_count,yytext);
     errors++;
}

[0-9]*[\.]?[0-9]*E[0-9]*[\.][0-9]*  {
    fprintf(logout,"Error at line# %d: ILLFORMED_NUMBER %s\n",line_count,yytext);
    errors++;

}


\/\*  {
    
    comment = (char*)malloc(length); 
    
    comment[0] = '/';
    comment[1]='*';
    position=position+2;
    initial=line_count;
    BEGIN COMMENT;
}
<COMMENT>{
.|\n|\ |\t  {
  
  comment[position++] = *yytext;
  if (*yytext == '\n') {
            line_count++;
        }
    
}
\*\/  {
        comment[position++]='*';
        comment[position++]='/';
        comment[position] = '\0';
        fprintf(logout, "Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n", initial, comment);
        free(comment);  
        position=0;
        BEGIN(INITIAL);
   
    
}
<<EOF>> {
    fprintf(logout,"Error at line# %d: UNFINISHED_COMMENT %s\n",line_count,comment);
    errors++;
    return 0;
}
}



%%



int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
  symbol_table.Print_all_scopetable(logout);
    fprintf(logout,"Total lines: %d\n",line_count);
    fprintf(logout,"Total errors: %d\n",errors);
    fprintf(logout,"Total warnings: %d\n", warnings);
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}