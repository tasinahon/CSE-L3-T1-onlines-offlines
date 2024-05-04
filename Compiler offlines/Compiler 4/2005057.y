%{
    #include<bits/stdc++.h>
    using namespace std;
    #include "Parse_tree_eachnode.hpp"
    #include "Parse_tree_eachnode.cpp"
    #include "2005057.hpp"
    #include "function.hpp"
    #include "function.cpp"
    #include "variable.hpp"
    #include "variable.cpp"
	#include "myVar.hpp"
    #include "y.tab.h"

     
    extern FILE *yyin;
    extern int line_count;
    extern int errors;
    FILE *output_file;
    FILE *logout;
    FILE *codeout;
    int error_f=0;
    FILE *errorout;
    int yylex(void);
    int yyparse(void);

    string funcname;
    void yyerror(char *s)
    {

	      fprintf(errorout,"Line# %d: Syntax error ",line_count,s);
          fprintf(logout,"Error at line no %d : %s\n",line_count,s);
          errors++;
          
    }

    void code_optimization();
    void first_pass();
    void second_pass();
    void third_pass();
    void fourth_pass();


    ofstream parsetree_file;

    SymbolTable symbol_table(11);
    FILE *parse;
struct StringPair {
    string first;
    string second;
};

StringPair* myStringPairs = nullptr;
int arraySize=0;

string *param_type;
string *one_case;
int label=0;
vector<string>argument_variable;



vector<vector<string>>code;
vector<vector<string>>first;
vector<vector<string>>second;
vector<vector<string>>third;
vector<vector<string>>fourth;

VarDeclList myVarDeclList;
VarDeclList global_varlist;
vector<SymbolInfo*>arguments;
Parse_tree_eachnode* funcparams = new Parse_tree_eachnode();

struct ArgumentList {
    string* array;
    int size;
};

ArgumentList myArgumentList;

int temp_size=0;
string parse_data_name;
string f_name;
string *for_func_definition;
int for_func_definition_size;
int line_no_for_func;
string zero_or_not;
int flag_for_func_error=0;


void function_declare_error(string* param, int numParams,int line_no) {
   
    for (int i = 0; i < numParams - 1; ++i) {
        
        for (int j = i + 1; j < numParams; ++j) {
            
            if (param[i] == param[j] && param[i]!="") {
                
                fprintf(errorout,"Line# %d: Redefinition of parameter '%s'\n",line_no,param[i].c_str());
                errors++;
                flag_for_func_error=1;
            }
        }
    }
    
}
void function_check(string return_type,string *param_type,string func_name,int all_par_size,int line_no)
{
    SymbolInfo* symbolInfo = symbol_table.Lookup_Symbol(func_name);
    Function* function = (Function*)symbolInfo;
    string return_type_from_symboltable;
    int param_no;

    string *a=param_type;

    
   
    if (function) {
    
    
        return_type_from_symboltable = function->get_return_function();
         string *all_param_types=function->get_params();
        param_no=function->get_no_of_parameter();

        
        
        if(return_type_from_symboltable!=return_type)
        {
            fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",line_no,func_name.c_str());
           
            errors++;
        }

        
        
        
           
            if(param_no!=all_par_size)
            {
                  fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",line_no,func_name.c_str());
                  errors++;
                  
            }
            else{

                for(int i=0;i<param_no;i++)
                {
                   
                      if(a[i]!=all_param_types[i])
                         {
                                fprintf(errorout,"Line# %d: Conflicting data type  of '%s'hello\n",line_no,func_name.c_str());
                                errors++;
                        }
        
                }

            }
            
        
        
    
    }
   
    
   


}

string newLabel(){
        string a = to_string(label++);
        a = "L"+a;
        return a;
    }

void argument_check(string func_name,string *arg_list,int size,int line_no)
{
    SymbolInfo* symbolInfo = symbol_table.Lookup_Symbol(func_name);
    Function* function = (Function*)symbolInfo;
    if(function==nullptr)
    {
        fprintf(errorout,"Line# %d: Undeclared function '%s'\n",line_no,func_name.c_str());
        errors++;
    }
    else{
        string *a=arg_list;
        string *b=function->get_params();
        int length_from_symboltable=function->get_no_of_parameter();
        
        if(size>length_from_symboltable)
        {
            fprintf(errorout,"Line# %d: Too many arguments to function '%s'\n",line_no,func_name.c_str());
            errors++;
        }
        else if(size<length_from_symboltable)
        {
            fprintf(errorout,"Line# %d: Too few arguments to function '%s'\n",line_no,func_name.c_str());
            errors++;
        }
        else if(size==length_from_symboltable){
            for(int i=0;i<size;i++)
             {
                 if(a[i]!=b[i])
                  {
                    
                    fprintf(errorout,"Line# %d: Type mismatch for argument %d of '%s'\n",line_count,i+1,func_name.c_str());
                    errors++;
                  }
             }

        }
       
        

    }
}



string rel_op(string op){
	string opcode = "";
	if(op == "<") opcode ="\tJL";
	else if(op == ">") opcode ="\tJG";
	else if(op == ">=") opcode ="\tJGE";
	else if(op == "<=") opcode ="\tJLE";
	else if(op == "==") opcode ="\tJE";
	else if(op == "!=") opcode ="\tJNE";
	return opcode;
}
void tree_traversal(int t,Parse_tree_eachnode *root)
{
	if(root==nullptr)
	{
		return;
	}
	if(root->get_productionrule()=="start : program")
	{
		    
              string newLineProc = "new_line PROC\n\tPUSH AX\n\tPUSH DX\n\tMOV AH,2\n\tMOV DL,CR\n\tINT 21H\n\tMOV AH,2\n\tMOV DL,LF\n\tINT 21H\n\tPOP DX\n\tPOP AX\n\tRET\nnew_line ENDP\n";
            string printOutputProc = "print_output PROC  ;PRINT WHAT IS IN AX\n\tPUSH AX\n\tPUSH BX\n\tPUSH CX\n\tPUSH DX\n\tPUSH SI\n\tLEA SI,NUMBER\n\tMOV BX,10\n\tADD SI,4\n\tCMP AX,0\n\tJNGE NEGATE\n\tPRINT:\n\tXOR DX,DX\n\tDIV BX\n\tMOV [SI],DL\n\tADD [SI],'0'\n\tDEC SI\n\tCMP AX,0\n\tJNE PRINT\n\tINC SI\n\tLEA DX,SI\n\tMOV AH,9\n\tINT 21H\n\tPOP SI\n\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n\tRET\n\tNEGATE:\n\tPUSH AX\n\tMOV AH,2\n\tMOV DL,'-'\n\tINT 21H\n\tPOP AX\n\tNEG AX\n\tJMP PRINT\nprint_output ENDP\n";
            string header = ".MODEL SMALL\n.STACK 1000H\n.DATA\n\tCR EQU 0DH\n\tLF EQU 0AH\n\tNUMBER DB \"00000$\"\n";
            fprintf(codeout,header.c_str());
            for(int i=0; i<global_varlist.size; i++){
                if(global_varlist.array[i].intValue!=-1){
					fprintf(codeout,"\t%s DW %d DUP (0000H)\n",global_varlist.array[i].symbolInfo->get_name().c_str(),global_varlist.size);
                    
                }
                else{
					fprintf(codeout,"\t%s DW 1 DUP (0000H)\n",global_varlist.array[i].symbolInfo->get_name().c_str());
                    
                }
            }
			fprintf(codeout,".CODE\n");
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            fprintf(codeout,"%s",newLineProc.c_str());
            fprintf(codeout,"%s\n",printOutputProc.c_str());
			
			fprintf(codeout,"END main\n");
            code_optimization();
	}

	if(root->get_productionrule()=="program : program unit"){
		    Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[1]);
        }
    if(root->get_productionrule()=="program : unit"){
		    Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="unit : var_declaration"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="unit : func_declaration"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="unit : func_definition"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[3]);
        }
        if(root->get_productionrule()=="func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[3]);
            fprintf(codeout,"%s PROC\n",root->function_name[0].c_str());
            fprintf(codeout,"\tPUSH BP\n");
            fprintf(codeout,"\tMOV BP, SP\n");
            tree_traversal(t+1,child[5]);
            fprintf(codeout,"%s_exit:\n",root->funcname.c_str());
            fprintf(codeout,"\tADD SP, %d\n",child[5]->stack_offset*-1);
            fprintf(codeout,"\tPOP BP\n");
             if(root->function_name[0]!="main")
            {
                fprintf(codeout,"\tRET\n");
                
            }
            
            
            fprintf(codeout,"%s ENDP\n",root->function_name[0].c_str());
            

            
        }
        if(root->get_productionrule()=="func_definition : type_specifier ID LPAREN RPAREN compound_statement"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            
            fprintf(codeout,"%s PROC\n",root->function_name[0].c_str());
            
            if(root->function_name[0]=="main")
            {
                fprintf(codeout,"\tMOV AX, @DATA\n");
                fprintf(codeout,"\tMOV DS, AX\n");
            }
            
            fprintf(codeout,"\tPUSH BP\n");
            fprintf(codeout,"\tMOV BP, SP\n");
            tree_traversal(t+1,child[4]);
            fprintf(codeout,"%s_exit:\n",root->funcname.c_str());
            if(root->function_name[0]=="main")
            {
                fprintf(codeout,"\tMOV AX, 4CH\n");
                fprintf(codeout,"\tINT 21H\n");
            }
            
            fprintf(codeout,"\tADD SP, %d\n",child[4]->stack_offset*-1);
            

            
            fprintf(codeout,"\tPOP BP\n");
            
            
            
            
            fprintf(codeout,"%s ENDP\n",root->function_name[0].c_str());
            
        }
        if(root->get_productionrule()=="parameter_list : parameter_list COMMA type_specifier ID"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[2]);
        }
        if(root->get_productionrule()=="parameter_list : parameter_list COMMA type_specifier"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[2]);
        }
        if(root->get_productionrule()=="parameter_list : type_specifier ID"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[1]);
        }
        if(root->get_productionrule()=="parameter_list : type_specifier"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
		 if(root->get_productionrule()=="compound_statement : LCURL statements RCURL"){
            Parse_tree_eachnode **child=root->get_child();
            
            if(root->lEnd=="") 
            {
                root->lEnd = newLabel();
            }
            
            child[1]->lEnd = root->lEnd;
            tree_traversal(t+1,child[1]);
        }
        if(root->get_productionrule()=="var_declaration : type_specifier declaration_list SEMICOLON"){
            
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[1]);
            
            
				
            for(int i= 0; i<child[1]->declaration_list.size(); i++){
                
				
                if(child[1]->declaration_list[i]->is_Global)
				{
					 
				}
                else{
                    if( child[1]->declaration_list[i]->arraySize!=-1) 
					{
                        
						
						fprintf(codeout,"\tSUB SP, %d\n",child[1]->declaration_list[i]->stackSize);
					}
                    else 
					{
                        
						fprintf(codeout,"\tSUB SP, 2\n");
                       
					}
					
                }
            }
        }
        
     if(root->get_productionrule()=="statements : statement"){
			Parse_tree_eachnode **child=root->get_child();
             child[0]->lEnd=root->lEnd;
             tree_traversal(t+1,child[0]);
             fprintf(codeout,"%s:\n",root->lEnd.c_str());
             
            
        }
        if(root->get_productionrule()=="statements : statements statement"){
            Parse_tree_eachnode **child=root->get_child();
            child[0]->lEnd = newLabel();
            child[1]->lEnd = root->lEnd;
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[1]);
            fprintf(codeout,"%s:\n",root->lEnd.c_str());
            
            
        }
        if(root->get_productionrule()=="statement : var_declaration"){
			Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="statement : expression_statement")
        {
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }

        if(root->get_productionrule()=="statement : compound_statement"){
            Parse_tree_eachnode **child=root->get_child();
            child[0]->lEnd = newLabel();
            tree_traversal(t+1,child[0]);
        }

        if(root->get_productionrule()=="statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[2]);
            string loop = newLabel();
            fprintf(codeout,"%s:\n",loop.c_str());
            child[3]->isCond = true;
            child[3]->lTrue = newLabel();
            child[3]->lFalse = root->lEnd;
            child[6]->lEnd = newLabel();
            tree_traversal(t+1,child[3]);
            
            fprintf(codeout,"%s:\n",child[3]->lTrue.c_str());
            tree_traversal(t+1,child[6]);
            tree_traversal(t+1,child[4]);
            fprintf(codeout,"\tJMP %s\n",loop.c_str());
            
            
        }

            if(root->get_productionrule()=="statement : IF LPAREN expression RPAREN statement"){
            Parse_tree_eachnode **child=root->get_child();
            child[2]->isCond = true;
            child[2]->lTrue = newLabel();
            child[2]->lFalse = root->lEnd;
            child[4]->lEnd =root-> lEnd;
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"%s:\n",child[2]->lTrue.c_str());
            tree_traversal(t+1,child[4]);
        }
        if(root->get_productionrule()=="statement : IF LPAREN expression RPAREN statement ELSE statement"){
            Parse_tree_eachnode **child=root->get_child();
            child[2]->isCond = true;
            child[2]->lTrue = newLabel();
            child[2]->lFalse = newLabel();
            child[4]->lEnd = child[2]->lFalse;
            child[6]->lEnd = root->lEnd;
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"%s:\n",child[2]->lTrue.c_str());
            tree_traversal(t+1,child[4]);
            
            fprintf(codeout,"\tJMP %s\n",root->lEnd.c_str());
            
            fprintf(codeout,"%s:\n",child[2]->lFalse.c_str());
            tree_traversal(t+1,child[6]);
        }
      
        if(root->get_productionrule()=="statement : WHILE LPAREN expression RPAREN statement"){
            Parse_tree_eachnode **child=root->get_child();
            string loop = newLabel();
            child[2]->isCond = true;
            child[2]->lTrue = newLabel();
            child[2]->lFalse = root->lEnd;
            child[4]->lEnd = root->lEnd;
            fprintf(codeout,"%s:\n",loop.c_str());
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"%s:\n",child[2]->lTrue.c_str());
            tree_traversal(t+1,child[4]);
            fprintf(codeout,"\tJMP %s\n",loop.c_str());
        }
        
        if(root->get_productionrule()=="statement : PRINTLN LPAREN ID RPAREN SEMICOLON"){
             Parse_tree_eachnode **child=root->get_child();
            if(root->is_Global){
                
                fprintf(codeout,"\tMOV AX, %s\n",child[2]->declaration_list[0]->get_name().c_str());
                fprintf(codeout,"\tCALL print_output\n");
                fprintf(codeout,"\tCALL new_line\n");
            }
            else{
               
                
                fprintf(codeout,"\tPUSH BP\n");
                fprintf(codeout,"\tMOV BX, %d\n",root->stack_offset);
                fprintf(codeout,"\tADD BP, BX\n");
                fprintf(codeout,"\tMOV AX, [BP]\n");
                fprintf(codeout,"\tCALL print_output\n");
                fprintf(codeout,"\tCALL new_line\n");
                fprintf(codeout,"\tPOP BP\n");
                
            }
            
        }

          if(root->get_productionrule()=="statement : RETURN expression SEMICOLON"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[1]);
		    fprintf(codeout,"\tMOV DX,CX\n");
            
            
            fprintf(codeout,"\tJMP %s_exit\n",child[0]->funcname.c_str());
        }
     
    
    

        if(root->get_productionrule()=="expression_statement : expression SEMICOLON")
        {
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue;
            child[0]->lFalse = root->lFalse;
            tree_traversal(t+1,child[0]);

            
            
        }
        if(root->get_productionrule()=="expression : logic_expression"){
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue;
            child[0]->lFalse = root->lFalse;
            tree_traversal(t+1,child[0]);

            
           
        }
         if(root->get_productionrule()=="expression : variable ASSIGNOP logic_expression")
        {
          Parse_tree_eachnode **child=root->get_child();
            
            
            tree_traversal(t+1,child[2]);
            child[0]->isCond = false;
            child[2]->isCond = false;
            
            
            if(child[0]->is_Global && child[0]->declaration_list[0]->arraySize==-1){
                
                tree_traversal(t+1,child[0]);
                fprintf(codeout,"\tMOV %s , CX\n",child[0]->declaration_list[0]->get_name().c_str());
               
                

            }
            else{
                
                
               
                fprintf(codeout, "\tPUSH CX\n");
                tree_traversal(t+1,child[0]);
                fprintf(codeout,"\tPOP AX\n");
                fprintf(codeout,"\tPOP CX\n");
                fprintf(codeout,"\tMOV [BP], CX\n");
                fprintf(codeout,"\tMOV BP, AX\n");
                
                
            }
            if(root->isCond)
            {
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
             
        }
         if(root->get_productionrule()=="variable : ID"){
            if(root->is_Global)
            {
                
            }
            else{
                
                fprintf(codeout,"\tPUSH BP\n");
                fprintf(codeout,"\tMOV BX, %d\n",root->stack_offset);
                fprintf(codeout,"\tADD BP, BX\n");
                
                
                
                
            }
        }
         if(root->get_productionrule()=="variable : ID LSQUARE expression RSQUARE"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[2]);
           if(!root->is_Global)
           {
             fprintf(codeout,"\tPUSH BP\n");
             fprintf(codeout,"\tMOV BX, CX\n");
             fprintf(codeout,"\tADD BX, BX\n");
             fprintf(codeout,"\tADD BX, %d\n",root->stack_offset);
             fprintf(codeout,"\tADD BP, BX\n");
           }
           else{
            fprintf(codeout,"\tLEA SI, %s\n",child[0]->declaration_list[0]->get_name().c_str());
            fprintf(codeout,"\tADD SI, CX\n");
            fprintf(codeout,"\tADD SI, CX\n");
            fprintf(codeout,"\tPUSH BP\n");
            fprintf(codeout,"\tMOV BP, SI\n");
           }
                
                
            
        }
        if(root->get_productionrule()=="logic_expression : rel_expression"){
                       Parse_tree_eachnode **child=root->get_child();
                       child[0]->isCond = root->isCond;
                       child[0]->lTrue = root->lTrue;
                       child[0]->lFalse = root->lFalse;
                       tree_traversal(t+1,child[0]);

        }
       
        if(root->get_productionrule()=="rel_expression : simple_expression"){
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue ;
            child[0]->lFalse = root->lFalse ;
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="rel_expression : simple_expression RELOP simple_expression"){ 
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            fprintf(codeout,"\tPUSH CX\n");
            tree_traversal(t+1,child[2]);
            
            
            fprintf(codeout,"\tPOP AX\n");
            fprintf(codeout,"\tCMP AX, CX\n");
             if(root->lTrue == "") 
             {
                root->lTrue = newLabel();
             }
            if(root->lFalse == "")
            {
                root->lFalse = newLabel();
            }
            string opcode=rel_op(child[1]->declaration_list[0]->get_name());
            fprintf(codeout,"%s %s\n",opcode.c_str(),root->lTrue.c_str());
            fprintf(codeout,"\tJMP %s\n",root->lFalse.c_str());
            
            if(!root->isCond){
                
                fprintf(codeout,"%s:\n",root->lTrue.c_str());
                fprintf(codeout,"\tMOV CX, 1\n");
                string leave = newLabel();
                fprintf(codeout,"\tJMP %s\n",leave.c_str());
                fprintf(codeout,"%s:\n",root->lFalse.c_str());
                fprintf(codeout,"\tMOV CX, 0\n");
                fprintf(codeout,"%s:\n",leave.c_str());
            }
            
        }
        if(root->get_productionrule()=="simple_expression : term"){
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue ;
            child[0]->lFalse = root->lFalse ;
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="simple_expression : simple_expression ADDOP term"){
            
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            
            fprintf(codeout,"\tPUSH CX\n");
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"\tPOP AX\n");
           
            
            if(child[1]->declaration_list[0]->get_name()=="+")
            {
                
                fprintf(codeout,"\tADD CX, AX\n");
            } 
            if(child[1]->declaration_list[0]->get_name()=="-")
            {
                fprintf(codeout,"\tSUB AX, CX\n\tMOV CX, AX\n");
            } 
             if(root->isCond){
                
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
           
           
        }
       
        if(root->get_productionrule()=="term : term MULOP unary_expression"){
            
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            fprintf(codeout,"\tPUSH CX\n");
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"\tPOP AX\n");
            if(child[1]->declaration_list[0]->get_name()=="*"){
                
                fprintf(codeout,"\tIMUL CX\n");
                fprintf(codeout,"\tMOV CX,AX\n");
                
                
            }
            else if(child[1]->declaration_list[0]->get_name()=="/"){
                fprintf(codeout,"\tCWD\n");
                fprintf(codeout,"\tIDIV CX\n");
                fprintf(codeout,"\tMOV CX, AX\n");
            }
            else if(child[1]->declaration_list[0]->get_name()=="%"){
                fprintf(codeout,"\tCWD\n");
                fprintf(codeout,"\tIDIV CX\n");
                fprintf(codeout,"\tMOV CX, DX\n");
                
            }
            if(root->isCond){
                
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
           
        }
        if(root->get_productionrule()=="logic_expression : rel_expression LOGICOP rel_expression"){
            

            Parse_tree_eachnode **child=root->get_child();
            
            child[0]->isCond = root->isCond;
            child[2]->isCond = root->isCond;
            if(child[1]->declaration_list[0]->get_name() == "||"){
                child[0]->lTrue = root->lTrue;
                child[0]->lFalse = newLabel()+"jmpfalse";
                child[2]->lTrue = root->lTrue;
                child[2]->lFalse = root->lFalse;
            }
            else{
                child[0]->lTrue = newLabel();
                child[0]->lFalse = root->lFalse;
                child[2]->lTrue = root->lTrue;
                child[2]->lFalse = root->lFalse;
            }
            tree_traversal(t+1,child[0]);
            if(root->isCond){
                if(child[1]->declaration_list[0]->get_name() == "||")
                {
                    fprintf(codeout,"%s:\n",child[0]->lFalse.c_str());
                }
                else
                {
                    fprintf(codeout,"%s:\n",child[0]->lTrue.c_str());
                }   
            }
            fprintf(codeout,"\tPUSH CX\n");
            tree_traversal(t+1,child[2]);
            
            if(!root->isCond){
                
                     fprintf(codeout,"\tPOP AX\n");
                if(child[1]->declaration_list[0]->get_name()=="||"){
                    string x = newLabel();
                    string y = newLabel();
                    string z = newLabel();
                    string a = newLabel();
                    fprintf(codeout, "\tCMP AX, 0\n");
                    fprintf(codeout,"\tJE %s\n",x.c_str());
                    fprintf(codeout,"\tJMP %s\n",y.c_str());
                    fprintf(codeout,"%s:\n",x.c_str());
                    
                    fprintf(codeout, "\tJCXZ %s\n",z.c_str());
                    fprintf(codeout,"%s:\n",y.c_str());
                    fprintf(codeout,"\tMOV CX, 1\n");
                    fprintf(codeout,"\tJMP %s:\n",a.c_str());
                    fprintf(codeout,"%s:\n",z.c_str());
                    fprintf(codeout,"\tMOV CX, 0\n");
                    fprintf(codeout,"%s:\n",a.c_str());
                    

                }
                else{
                    string x = newLabel();
                    string y = newLabel();
                    string z = newLabel();
                    
                    
                    fprintf(codeout, "\tCMP AX, 0\n");
                    
                    fprintf(codeout,"\tJE %s\n",x.c_str());
                    fprintf(codeout,"\tJCXZ %s\n",x.c_str());
                    
                    
                    fprintf(codeout,"\tJMP %s\n",y.c_str());
                    fprintf(codeout,"%s:\n",x.c_str());
                    fprintf(codeout,"\tMOV CX, 0\n");
                    fprintf(codeout,"\tJMP %s\n",z.c_str());
                    fprintf(codeout,"%s:\n",y.c_str());
                    fprintf(codeout,"\tMOV CX, 1\n");
                    fprintf(codeout,"%s:\n",z.c_str());
                    
                }
            }
      
            }
        
        if(root->get_productionrule()=="term : unary_expression"){
            
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue ;
            child[0]->lFalse = root->lFalse ;
            tree_traversal(t+1,child[0]);  
        }
         if(root->get_productionrule()=="unary_expression : ADDOP unary_expression"){
            Parse_tree_eachnode **child=root->get_child();
            child[1]->isCond = root->isCond;
            child[1]->lTrue = root->lTrue ;
            child[1]->lFalse = root->lFalse ;
            tree_traversal(t+1,child[1]);
            if(child[0]->declaration_list[0]->get_name()=="-"){
                
                fprintf(codeout,"\tNEG CX\n");
                
                
            }
        }
        if(root->get_productionrule()=="unary_expression : NOT unary_expression"){
           
            Parse_tree_eachnode **child=root->get_child();
            child[1]->isCond = root->isCond;
            child[1]->lTrue = root->lFalse ;
            child[1]->lFalse = root->lTrue ;
            tree_traversal(t+1,child[1]);
             if(!root->isCond){
                string label0 = newLabel();
                string label1 = newLabel();
        
                fprintf(codeout,"\tJCXZ %s\n",label1.c_str());
                fprintf(codeout,"\tMOV CX,0\n");
                fprintf(codeout,"\tJCXZ %s\n",label0.c_str());
                fprintf(codeout,"%s:\n",label1.c_str());
                fprintf(codeout,"\tMOV CX,1\n");
                fprintf(codeout,"%s:\n",label0.c_str());
            }
            
        }
        if(root->get_productionrule()=="unary_expression : factor"){
            
            Parse_tree_eachnode **child=root->get_child();
            child[0]->isCond = root->isCond;
            child[0]->lTrue = root->lTrue ;
            child[0]->lFalse = root->lFalse ;
            tree_traversal(t+1,child[0]);
            
        }
        if(root->get_productionrule()=="factor : variable"){
            
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            if(child[0]->is_Global && child[0]->declaration_list[0]->arraySize==-1){
                if(child[0]->declaration_list[0]->arraySize==-1)
                {
                    fprintf(codeout,"\tMOV CX, %s\n",child[0]->declaration_list[0]->get_name().c_str());
                } 
            }
            else{
                fprintf(codeout,"\tMOV CX, [BP]\n");
                fprintf(codeout,"\tPOP BP\n");
                
            }
             if(root->isCond){
                
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
            
        }
        if(root->get_productionrule()=="factor : ID LPAREN argument_list RPAREN"){
            Parse_tree_eachnode **child=root->get_child();
              tree_traversal(t+1,child[0]);
            
                 
                 tree_traversal(t+1,child[2]);
            
            
            fprintf(codeout,"\tCALL %s\n",child[0]->declaration_list[0]->get_name().c_str());
            fprintf(codeout,"\tMOV CX, DX\n");
            fprintf(codeout,"\tADD SP, %d\n",child[2]->stack_offset);
             
            if(root->isCond){
               fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
          
           
            
        }
        if(root->get_productionrule()=="factor : LPAREN expression RPAREN"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[1]);
            if(root->isCond){
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
        }

        if(root->get_productionrule()=="factor : CONST_INT"){

            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            fprintf(codeout,"\tMOV CX, %s\n",root->declaration_list[0]->get_name().c_str());
            
             if(root->isCond){
                
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
           
        }
        if(root->get_productionrule()=="factor : CONST_FLOAT"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            fprintf(codeout,"\tMOV CX, %s\n",root->declaration_list[0]->get_name().c_str());
             if(root->isCond){
                
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
            
        }
        if(root->get_productionrule()=="factor : variable INCOP"){
            
            
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            if(child[0]->is_Global && child[0]->declaration_list[0]->arraySize ==-1) 
            {
                 fprintf(codeout,"\tMOV CX, %s\n",child[0]->declaration_list[0]->get_name().c_str());
            }
            else
            {
                fprintf(codeout, "\tMOV CX, [BP]\n");
            }
            fprintf(codeout,"\tMOV AX, CX\n");
            if(child[1]->declaration_list[0]->get_name()=="++") 
            {
                
                fprintf(codeout,"\tINC CX\n");
            }
            
            if(child[1]->declaration_list[0]->get_name()=="--") 
            {
                fprintf(codeout,"\tDEC CX\n");
            }
            
            
            if(child[0]->is_Global)
            {
                fprintf(codeout,"\tMOV %s , CX\n",child[0]->declaration_list[0]->get_name().c_str());
            }
            else{
                fprintf(codeout,"\tMOV [BP], CX\n");
                fprintf(codeout,"\tPOP BP\n");
            }
            fprintf(codeout, "\tMOV CX, AX\n");
             if(root->isCond){
                fprintf(codeout,"\tJCXZ %s\n",root->lFalse.c_str());
                fprintf(codeout,"\tJMP %s\n",root->lTrue.c_str());
            }
            
        }
        if(root->get_productionrule()=="argument_list : arguments"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
        }
        if(root->get_productionrule()=="arguments : arguments COMMA logic_expression"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
            tree_traversal(t+1,child[2]);
            fprintf(codeout,"\tPUSH CX\n");
        }
        if(root->get_productionrule()=="arguments : logic_expression"){
            Parse_tree_eachnode **child=root->get_child();
            tree_traversal(t+1,child[0]);
           fprintf(codeout,"\tPUSH CX\n");
        }
        


}


void first_pass()
{
    int g = INT_MAX;

    while(g>code.size()){
        g = code.size();
        
        for(int i=0; i<code.size(); i++){

            if((code[i][0]=="ADD" || code[i][0]=="SUB") && code[i][2]=="0") continue;
            if(i<code.size()-1 &&  code[i][0]=="PUSH" && code[i+1][0]=="POP"){
                if(code[i][1]!=code[i+1][1]){
                    first.push_back({"MOV",code[i+1][1],code[i][1],"\tMOV "+code[i+1][1]+", "+code[i][1]+"\n"});
                }
                i++;
                continue;
            }
            first.push_back(code[i]);
        }
    }
}
void second_pass()
{
       

        for(int i=0; i<first.size(); i++){
            if(i<first.size()-1 &&  first[i][0]=="MOV" && first[i+1][0]=="MOV" && first[i][1]==first[i+1][2] && first[i][2]==first[i+1][1]){
                i++;
                continue;
            }
            second.push_back(first[i]);
        }
}

void third_pass()
{
      for(int i=0; i<second.size(); i++){
            if(i<second.size()-1 && second[i][0]=="MOV" && second[i+1][0]=="POP" && second[i][1]==second[i+1][1]){
                continue;
            }
            third.push_back(second[i]);
        }
}

void fourth_pass()
{
     for(int i=0; i<third.size(); i++){
            if(i<third.size()-1 && third[i][0][0]=='J' && third[i][1]==third[i+1][0]){
                continue;
            }
            fourth.push_back(third[i]);
        }

        code = fourth;
}

void code_optimization(){
    
    string line;
    FILE* optimize_out;
    optimize_out=fopen("code.asm","r");
    char *read=nullptr;
    size_t length=0;
        if(optimize_out==nullptr)
        {
            return;
        }
    
        while( getline(&read,&length,optimize_out)!=-1 ){
            const char *a=read;
            line=a;
            string w = "";
            
            
            if(line.substr(0,8)=="new_line")
            {
                break;
            }
            vector<string > words;
            for(int i=0; i<line.size(); i++){
                if(line[i]==' ' || line[i]=='\n' || line[i]=='\t' || line[i]==',' || line[i]==':' || line[i]==';'){
                    if(w.size()>0) words.push_back(w);
                    w = "";
                }
                else{
                    w += line[i];
                }
            }
            if(w.size()>0) words.push_back(w);
            words.push_back(line);
            code.push_back(words);
            
            
        }
           first_pass();
           second_pass();
           third_pass();
           fourth_pass();
           FILE* op;
           op=fopen("optimized_code.asm","w");
           for(int i=0; i<code.size(); i++){
                fprintf(op,"%s",code[i][code[i].size()-1].c_str());
        
            }
             string newLineProc = "new_line PROC\n\tPUSH AX\n\tPUSH DX\n\tMOV AH,2\n\tMOV DL,CR\n\tINT 21H\n\tMOV AH,2\n\tMOV DL,LF\n\tINT 21H\n\tPOP DX\n\tPOP AX\n\tRET\nnew_line ENDP\n";
            string printOutputProc = "print_output PROC  ;PRINT WHAT IS IN AX\n\tPUSH AX\n\tPUSH BX\n\tPUSH CX\n\tPUSH DX\n\tPUSH SI\n\tLEA SI,NUMBER\n\tMOV BX,10\n\tADD SI,4\n\tCMP AX,0\n\tJNGE NEGATE\n\tPRINT:\n\tXOR DX,DX\n\tDIV BX\n\tMOV [SI],DL\n\tADD [SI],'0'\n\tDEC SI\n\tCMP AX,0\n\tJNE PRINT\n\tINC SI\n\tLEA DX,SI\n\tMOV AH,9\n\tINT 21H\n\tPOP SI\n\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n\tRET\n\tNEGATE:\n\tPUSH AX\n\tMOV AH,2\n\tMOV DL,'-'\n\tINT 21H\n\tPOP AX\n\tNEG AX\n\tJMP PRINT\nprint_output ENDP\n";
            fprintf(op,"%s",newLineProc.c_str());
            fprintf(op,"%s",printOutputProc.c_str());
            fprintf(op,"END main\n");
    

    }
   
	







%}



%union{
    Parse_tree_eachnode* parse_tree_eachnode;
	SymbolInfo* symbolinfo; 
    
	
}



%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN INCOP DECOP ASSIGNOP NOT
LPAREN RPAREN LCURL RCURL LSQUARE RSQUARE COMMA SEMICOLON 

%token <symbolinfo>  CONST_INT CONST_FLOAT CONST_CHAR ID 
%type<parse_tree_eachnode> start program unit func_declaration func_definition parameter_list compound_statement var_declaration type_specifier declaration_list statements statement expression_statement variable expression logic_expression rel_expression simple_expression term unary_expression factor argument_list arguments 
%locations


%right  ASSIGNOP
%left <symbolinfo> LOGICOP
%left  <symbolinfo> RELOP
%left  <symbolinfo> ADDOP
%left  <symbolinfo> MULOP
%left <symbolinfo>INCOP
%right  NOT
%left RPAREN
%nonassoc LOW;
%nonassoc ELSE;



%%
start : program
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("start : program");
        p->add_child($1);
        $$=p;
        $$->print_parsetree(output_file,$$,0);
		tree_traversal(0,$$);
        fprintf(logout,"start : program \n");
	}
	;

program : 
	program unit 
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("program : program unit");
        p->add_child($1);
        p->add_child($2);
        
        $$=p;
        fprintf(logout,"program : program unit \n");
	}
	| 
	unit
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("program : unit");
        p->add_child($1);
        $$=p;
        fprintf(logout,"program : unit \n");
	}
	;
unit : 
	var_declaration
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("unit : var_declaration");
        p->add_child($1);
        $$=p;
        fprintf(logout,"unit : var_declaration  \n");
        
	}
    | 
	func_declaration
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("unit : func_declaration");
        p->add_child($1);
        $$=p;
        fprintf(logout,"unit : func_declaration \n");
	}
    | 
	func_definition
	{
		Parse_tree_eachnode* p=new Parse_tree_eachnode();
        p->set_start(@$.first_line);
        p->set_ends(@$.last_line);
        p->Production("unit : func_definition");
        p->add_child($1);
        $$=p;
        fprintf(logout,"unit : func_definition  \n");
	}
    ;
     
func_declaration : 
		type_specifier ID  LPAREN parameter_list RPAREN SEMICOLON
		{
			Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("ID : " + $2->get_name());
            
            Parse_tree_eachnode* p2=new Parse_tree_eachnode();
            p2->set_start(@3.first_line);
            p2->set_ends(0);
            p2->Production("LPAREN : (");
            
            Parse_tree_eachnode* p3=new Parse_tree_eachnode();
            p3->set_start(@5.first_line);
            p3->set_ends(0);
            p3->Production("RPAREN : )");

            Parse_tree_eachnode* p4=new Parse_tree_eachnode();
            p4->set_start(@6.first_line);
            p4->set_ends(0);
            p4->Production("SEMICOLON : ;"); 

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
            main->add_child($1);
            main->add_child(p1);
            main->add_child(p2);
            main->add_child($4);
            main->add_child(p3);
            main->add_child(p4);
            $$=main;
             

            fprintf(logout,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \n");
            param_type = (string*)realloc(param_type, (arraySize + 1) * sizeof(string));
            string *all_parameter=new string[arraySize+1];
            
            for(int i=0;i<arraySize;i++)
            {
                param_type[i]=myStringPairs[i].first;
                all_parameter[i]=myStringPairs[i].second;
            }
        



            function_declare_error(all_parameter,arraySize+1,@1.first_line);
            Function *function=new Function();
            function->set_name($2->get_name());
            function->set_type("function");
            function->set_return_function($1->get_parse_data());
            function->set_params(param_type,arraySize);
            SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($2->get_name());
            if(symbolinfo==nullptr )
            {
                 symbol_table.Insert_Symbol((SymbolInfo*)function);
            }
            else if(symbolinfo->get_type()!="function")
            {
                fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",@1.first_line,symbolinfo->get_name().c_str());
                errors++;
            }
            
            arraySize=0;
            if(error_f)
            {
                fprintf(errorout,"at parameter list of function declaration\n");
                error_f=0;
            }
            funcparams->set_parameterlist({});
            
            
		}
		| 
		type_specifier ID LPAREN RPAREN SEMICOLON
		{
            Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("ID : " + $2->get_name());
            
            Parse_tree_eachnode* p2=new Parse_tree_eachnode();
            p2->set_start(@3.first_line);
            p2->set_ends(0);
            p2->Production("LPAREN : (");
            
            Parse_tree_eachnode* p3=new Parse_tree_eachnode();
            p3->set_start(@4.first_line);
            p3->set_ends(0);
            p3->Production("RPAREN : )");

            Parse_tree_eachnode* p4=new Parse_tree_eachnode();
            p4->set_start(@5.first_line);
            p4->set_ends(0);
            p4->Production("SEMICOLON : ;"); 

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON");
            main->add_child($1);
            main->add_child(p1);
            main->add_child(p2);
            main->add_child(p3);
            main->add_child(p4);
            $$=main;

            fprintf(logout,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON \n");

            Function *function=new Function();
            function->set_name($2->get_name());
            function->set_type("function");
            function->set_return_function($1->get_parse_data());
             SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($2->get_name());
            if(symbolinfo==nullptr)
            {
                 symbol_table.Insert_Symbol((SymbolInfo*)function);
            }
            else if(symbolinfo->get_type()!="function")
            {
                fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",@1.first_line,symbolinfo->get_name());
                errors++;
            }
			
		}
		;
		 
func_definition : 
	type_specifier ID  LPAREN parameter_list RPAREN { funcname=$2->get_name();} compound_statement
	{

        
            
            
            Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("ID : " + $2->get_name());
            
            Parse_tree_eachnode* p2=new Parse_tree_eachnode();
            p2->set_start(@3.first_line);
            p2->set_ends(0);
            p2->Production("LPAREN : (");
            
            Parse_tree_eachnode* p3=new Parse_tree_eachnode();
            p3->set_start(@5.first_line);
            p3->set_ends(0);
            p3->Production("RPAREN : )");

            

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement");
            main->add_child($1);
            main->add_child(p1);
            main->add_child(p2);
            main->add_child($4);
            main->add_child(p3);
            main->add_child($7);
            main->function_name.push_back($2->get_name());
            $$=main;

            function_declare_error(one_case,temp_size+1,@1.first_line);

            if(!error_f)
            {
                  fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement \n");

            Function *function=new Function();
            function->set_name($2->get_name());
            
            function->set_type("function");
            function->set_return_function($1->get_parse_data());
            function->set_params(for_func_definition,for_func_definition_size);
             SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($2->get_name());
            if(symbolinfo==nullptr && $2->get_name()!="println")
            {
                    
                    symbol_table.Insert_Symbol((SymbolInfo*)function);
                    
                
                 
            }
            $$->funcname=funcname;
            if(symbolinfo!=nullptr)
            {
                  if(symbolinfo->get_type()!="function")
                 {
                fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",@2.first_line,symbolinfo->get_name().c_str());
                errors++;
                 }

                 else{
                    function_check($1->get_parse_data(),param_type,$2->get_name(),temp_size,@1.first_line);
                 }
            
                 
            
            }
            

            }
           

           

            
            

            
        

                    
            
	}
	| 
	type_specifier ID  LPAREN RPAREN {funcname=$2->get_name();} compound_statement
	{
            Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("ID : " + $2->get_name());
            
            Parse_tree_eachnode* p2=new Parse_tree_eachnode();
            p2->set_start(@3.first_line);
            p2->set_ends(0);
            p2->Production("LPAREN : (");
            
            Parse_tree_eachnode* p3=new Parse_tree_eachnode();
            p3->set_start(@4.first_line);
            p3->set_ends(0);
            p3->Production("RPAREN : )");

            

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("func_definition : type_specifier ID LPAREN RPAREN compound_statement");
            main->add_child($1);
            main->add_child(p1);
            main->add_child(p2);
            main->add_child(p3);
            main->add_child($6);
            main->function_name.push_back($2->get_name());
            $$=main;

            fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");

            Function *function=new Function();
            function->set_name($2->get_name());
            funcname=$2->get_name();
            function->set_type("function");
            function->set_return_function($1->get_parse_data());
            SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($2->get_name());

            if(symbolinfo!=nullptr)
            {
                  if(symbolinfo->get_type()!="function")
                 {
                   fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",@2.first_line,symbolinfo->get_name());
                   errors++;
                 }

                 else{
                    function_check($1->get_parse_data(),param_type,$2->get_name(),temp_size,@1.first_line);
                 }
            
                 
            
            }
            else{
                symbol_table.Insert_Symbol((SymbolInfo*)function);
            }
            $$->funcname=funcname;
            line_no_for_func=@1.first_line;
           
		
	}
 	;	
parameter_list  : 
		parameter_list COMMA type_specifier ID
		{
			Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("COMMA : ,");

            Parse_tree_eachnode* p2=new Parse_tree_eachnode();
            p2->set_start(@4.first_line);
            p2->set_ends(0);
            p2->set_parse_data($3->get_parse_data());
            p2->Production("ID : "+ $4->get_name());

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("parameter_list : parameter_list COMMA type_specifier ID");
            main->add_child($1);
            main->add_child(p1);
            main->add_child($3);
            main->add_child(p2);
            $$=main;
            $$->add_parameter($4);
            $$->set_parameterlist($1->parameterlist); 
            fprintf(logout,"parameter_list  : parameter_list COMMA type_specifier ID\n");

            StringPair* newStringPairs = new StringPair[arraySize + 1];
            if (newStringPairs == nullptr) {
           
            cerr << "Memory allocation failed for myStringPairs." << endl;
            exit(EXIT_FAILURE);
            }

            for (int i = 0; i < arraySize; ++i) {
                newStringPairs[i] = myStringPairs[i];
            }
            delete[] myStringPairs;
            myStringPairs = newStringPairs;
            myStringPairs[arraySize].first = $3->get_parse_data();
            myStringPairs[arraySize].second = $4->get_name();  
            arraySize++;
            funcparams->set_parameterlist($$->parameterlist);
		}
		| 
		parameter_list COMMA type_specifier
		{
			Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->Production("COMMA : ,");

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("parameter_list : parameter_list COMMA type_specifier ID");
            main->add_child($1);
            main->add_child(p1);
            main->add_child($3);
            $$=main;
            $$->set_parameterlist($1->parameterlist);
            fprintf(logout,"parameter_list\t: parameter_list COMMA type_specifier ID \n");

            StringPair* newStringPairs = new StringPair[arraySize + 1];
            if (newStringPairs == nullptr) {
           
            cerr << "Memory allocation failed for myStringPairs." << endl;
            exit(EXIT_FAILURE);
            }

            for (int i = 0; i < arraySize; ++i) {
                newStringPairs[i] = myStringPairs[i];
            }
            delete[] myStringPairs;
            myStringPairs = newStringPairs;
            myStringPairs[arraySize].first = $3->get_parse_data();
            myStringPairs[arraySize].second = "";  
            arraySize++;
            funcparams->set_parameterlist($$->parameterlist);
		}
 		| 
		type_specifier ID
		{
            
			Parse_tree_eachnode* p1=new Parse_tree_eachnode();
            p1->set_start(@2.first_line);
            p1->set_ends(0);
            p1->set_parse_data($1->get_parse_data());
            p1->Production("ID : "+ $2->get_name());

            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("parameter_list : type_specifier ID");
            main->add_child($1);
            main->add_child(p1);
            $$=main;
            $$->add_parameter($2); 
            fprintf(logout,"parameter_list  : type_specifier ID\n");
            

            StringPair* newStringPairs = new StringPair[arraySize + 1];
            if (newStringPairs == nullptr) {
           
            cerr << "Memory allocation failed for myStringPairs." << endl;
            exit(EXIT_FAILURE);
            }

            for (int i = 0; i < arraySize; ++i) {
                newStringPairs[i] = myStringPairs[i];
            }
            delete[] myStringPairs;
            myStringPairs = newStringPairs;
            myStringPairs[arraySize].first = $1->get_parse_data();
            myStringPairs[arraySize].second = $2->get_name();  
            arraySize++;
            funcparams->set_parameterlist($$->parameterlist); 
		}
		| 
		type_specifier
		{
			Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(@$.last_line);
            main->Production("parameter_list : type_specifier");
            main->add_child($1);
            $$=main;
            fprintf(logout,"parameter_list\t: type_specifier \n");

            StringPair* newStringPairs = new StringPair[arraySize + 1];
            if (newStringPairs == nullptr) {
           
            cerr << "Memory allocation failed for myStringPairs." << endl;
            exit(EXIT_FAILURE);
            }

            for (int i = 0; i < arraySize; ++i) {
                newStringPairs[i] = myStringPairs[i];
            }
            delete[] myStringPairs;
            myStringPairs = newStringPairs;
            myStringPairs[arraySize].first = $1->get_parse_data();
            myStringPairs[arraySize].second = "";  
            arraySize++;
            funcparams->set_parameterlist($$->parameterlist); 
		}
        |
        error
		{
			yyclearin;
            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(0);
            main->Production("parameter_list : error");
            
         
            $$=main;
            error_f=1;
            
            
			
		}
 		;

 		
compound_statement : 
	LCURL
    {
        int so=4;
        
        symbol_table.Enter_Scope();
        if(!error_f)
        {
             
            
        if(arraySize>0)
        {
            int stackOffset = 2;
            for(int i=arraySize-1;i>=0;i--)
            {
                Variable* variable=new Variable();
                variable->set_name(myStringPairs[i].second);
                variable->set_type("variable");
                variable->set_data_type(myStringPairs[i].first);
                SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
                if(symbolinfo==nullptr )
                {
                   symbol_table.Insert_Symbol((SymbolInfo*)variable);
                   SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
                   stackOffset+=2;
                   symbolinfo->is_Global=false;
                   symbolinfo->stackOffset=stackOffset;
                   
                   
                }
                
            }
            symbol_table.set_stack_offset(0);

            param_type = (string*)realloc(param_type, (arraySize + 1) * sizeof(string));
            string *all_parameter=new string[arraySize+1];
            
            for(int i=0;i<arraySize;i++)
            {
                
                param_type[i]=myStringPairs[i].first;
                all_parameter[i]=myStringPairs[i].second;
            }

            
            for_func_definition=param_type;
            for_func_definition_size=arraySize;
            one_case=all_parameter;
            
			
            
            
            
             
            
        }
        temp_size=arraySize;
        arraySize=0;
        flag_for_func_error=0;
        }

       
        
        
    }
    statements RCURL
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
        p1->set_start(@1.first_line);
        p1->set_ends(0);
        p1->Production("LCURL : {");

        Parse_tree_eachnode* p2=new Parse_tree_eachnode();
        p2->set_start(@4.first_line);
        p2->set_ends(0);
        p2->Production("RCURL : }");
        
        Parse_tree_eachnode* main=new Parse_tree_eachnode();
        main->set_start(@$.first_line);
        main->set_ends(@$.last_line);
        main->Production("compound_statement : LCURL statements RCURL");
        main->add_child(p1);
        main->add_child($3);
        main->add_child(p2);
        main->stack_offset=symbol_table.get_stack_offset();
        $$=main;

        fprintf(logout,"compound_statement : LCURL statements RCURL  \n");

        symbol_table.Print_all_scopetable(logout);

        symbol_table.Exit_Scope();

	}
 	| 
	LCURL RCURL
	{

        symbol_table.Enter_Scope();


        Variable* variable=new Variable();
                variable->set_name("NN");
                variable->set_type("variable");
                variable->set_data_type(myStringPairs[0].first);
                SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
                if(symbolinfo==nullptr )
                {
                   symbol_table.Insert_Symbol((SymbolInfo*)variable);
                }

		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
        p1->set_start(@1.first_line);
        p1->set_ends(0);
        p1->Production("LCURL : {");

        Parse_tree_eachnode* p2=new Parse_tree_eachnode();
        p2->set_start(@2.first_line);
        p2->set_ends(0);
        p2->Production("RCURL : }");

        Parse_tree_eachnode* main=new Parse_tree_eachnode();
        main->set_start(@$.first_line);
        main->set_ends(@$.last_line);
        main->Production("compound_statement : LCURL RCURL");
        main->add_child(p1);
        main->add_child(p2);
        main->stack_offset=symbol_table.get_stack_offset();
        $$=main;
        fprintf(logout,"compound_statement : LCURL RCURL  \n");
        symbol_table.Print_all_scopetable(logout);
        arraySize=0;
        symbol_table.Exit_Scope();
	}
 	;

var_declaration : 
	type_specifier declaration_list SEMICOLON
	{
        
        
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@3.first_line);
         p1->set_ends(0);
         p1->Production("SEMICOLON : ;");

         

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("var_declaration : type_specifier declaration_list SEMICOLON");
         main->add_child($1);
         main->add_child($2);
         main->add_child(p1);
         $$=main;
         if(!error_f){
         fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON  \n");
         VarDeclList temp;
         
            
         for(int i=0;i<$2->declaration_list.size();i++)
         {
            
            
            
            Variable* variable=new Variable();
            variable->set_name($2->declaration_list[i]->get_name());
            variable->set_type("variable");
            variable->set_data_type($1->get_parse_data());
            
            variable->set_array_size($2->declaration_list[i]->arraySize);
            SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
             
            
            if(symbolinfo==nullptr){
                 symbol_table.Insert_Symbol((SymbolInfo*)variable);
                 SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
                 
				 if(symbol_table.get_current_scope_id()==1)
				 {
                   
					
                    $2->declaration_list[i]->is_Global=true;
                    symbolinfo->is_Global=true;
                    
                    VarDeclNode newVarDeclNode(symbolinfo, $2->declaration_list[i]->arraySize);
                    global_varlist.size++;
					global_varlist.array = (VarDeclNode*)realloc(global_varlist.array, global_varlist.size * sizeof(VarDeclNode));
                    global_varlist.array[global_varlist.size - 1] = newVarDeclNode;
                   
					
					


				 }
				 else
				 {
					
								
                                $2->declaration_list[i]->is_Global=false;
								if($2->declaration_list[i]->arraySize!=-1)
								{
                                    
									symbol_table.set_stack_offset(symbol_table.get_stack_offset()-2*$2->declaration_list[i]->arraySize);
                                    
                                    symbolinfo->stackOffset=symbol_table.get_stack_offset();
								} 
								else
								{
									symbol_table.set_stack_offset(symbol_table.get_stack_offset()-2);
									
                                    $2->declaration_list[i]->stackSize=symbol_table.get_stack_offset();
                                    symbolinfo->stackOffset=symbol_table.get_stack_offset();
                                    
                                    
								}
										
										
				 }
            }
            else{
                fprintf(errorout,"Line# %d: Conflicting types for'%s'\n",@1.first_line,variable->get_name().c_str());
                errors++;
            }
            
         
         
         
         
         }
        
         
        }

        
        
         
        
         

         
	}
 	;
 		 
type_specifier	: INT 
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data("INT");
         p1->Production("INT : int");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data("INT");
         main->Production("type_specifier : INT");
         main->add_child(p1);
         $$=main;
         fprintf(logout,"type_specifier\t: INT \n");

	}
 	| FLOAT
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data("FLOAT");
         p1->Production("FLOAT : float");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data("FLOAT");
         main->Production("type_specifier : FLOAT");
         main->add_child(p1);
         $$=main;

         fprintf(logout,"type_specifier\t: FLOAT \n");
	}
 	| VOID
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data("VOID");
         p1->Production("VOID : void");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data("VOID");
         main->Production("type_specifier : VOID");
         main->add_child(p1);
         $$=main;

         fprintf(logout,"type_specifier	: VOID\n");
	}
 	;
 		
declaration_list :
     error COMMA ID
		{
			yyclearin;
            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(0);
            main->Production("declaration_list  : error");
            
         
            $$=main;
            error_f=1;
            fprintf(errorout,"at declaration list of variable declaration\n");
            
            


			
		}
    | declaration_list COMMA ID
	{
        
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("COMMA : ,");

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@3.first_line);
         p2->set_ends(0);
         p2->Production("ID : "+ $3->get_name());

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("declaration_list : declaration_list COMMA ID");
         main->add_child($1);
         main->add_child(p1);
         main->add_child(p2);
         $$=main;
         if(!error_f)
        {
         fprintf(logout,"declaration_list : declaration_list COMMA ID  \n");

        
		  $$->declaration_list=$1->declaration_list;
		  $$->declaration_list.push_back($3);
         
        }

        if(error_f)
            {
                error_f=0;
            }
		 
	}
 	| declaration_list COMMA ID LSQUARE CONST_INT RSQUARE
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("COMMA : ,");
         
         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@3.first_line);
         p2->set_ends(0);
         p2->Production("ID : "+ $3->get_name());

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("LSQUARE : [");

         Parse_tree_eachnode* p4=new Parse_tree_eachnode();
         p4->set_start(@5.first_line);
         p4->set_ends(0);
         p4->Production("CONST_INT : "+ $5->get_name());

         Parse_tree_eachnode* p5=new Parse_tree_eachnode();
         p5->set_start(@6.first_line);
         p5->set_ends(0);
         p5->Production("RSQUARE : ]");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE");
         main->add_child($1);
         main->add_child(p1);
         main->add_child(p2);
         main->add_child(p3);
         main->add_child(p4);
         main->add_child(p5);
         $$=main;

         fprintf(logout,"declaration_list : declaration_list COMMA ID LSQUARE CONST_INT RSQUARE \n");


		 
         $$->declaration_list=$1->declaration_list;
         $3->arraySize=atoi($5->get_name().c_str());
         $3->stackSize= 2*atoi($5->get_name().c_str());
         $$->declaration_list.push_back($3);
        
	}
 	| ID 
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("ID : "+ $1->get_name());

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("declaration_list : ID");
         main->add_child(p1);
         
         $$=main;

         fprintf(logout,"declaration_list : ID \n");
         
         $$->declaration_list.push_back($1);
         
         
         

         

		

		 
	}
 	| ID LSQUARE CONST_INT RSQUARE
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("ID : "+ $1->get_name());

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LSQUARE : [");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@3.first_line);
         p3->set_ends(0);
         p3->Production("CONST_INT : "+$3->get_name());

         Parse_tree_eachnode* p4=new Parse_tree_eachnode();
         p4->set_start(@4.first_line);
         p4->set_ends(0);
         p4->Production("RSQUARE : ]");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("declaration_list : ID LSQUARE CONST_INT RSQUARE");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child(p3);
         main->add_child(p4);
         
         
         $$=main;
         

         fprintf(logout,"declaration_list : ID LSQUARE CONST_INT RSQUARE \n");

        

         

		 
          
          $1->arraySize=stoi($3->get_name());
          
          
          $1->stackSize= 2*atoi($3->get_name().c_str());
          $$->declaration_list.push_back($1);
		 
         
         

	}
    
 	;
 		  
statements : 
	statement
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statements : statement");
         main->add_child($1);
         
         
         $$=main;
         
         fprintf(logout,"statements : statement  \n");
	}
	| 
	statements statement
	{
		Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statements : statements statement");
         main->add_child($1);
         main->add_child($2); 
         $$=main;
        
         fprintf(logout,"statements : statements statement  \n");
         
	}
	;
	   
statement : 
	var_declaration
	{
		Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : var_declaration");
         main->add_child($1);
         
         
         $$=main;

         fprintf(logout,"statement : var_declaration \n");
	}
	|
	expression_statement
	{
        Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : expression_statement");
         main->add_child($1);
         
         
         $$=main;
         

         fprintf(logout,"statement : expression_statement  \n");
         if(error_f)
         {
            error_f=0;
         }
	}
	| 
	compound_statement
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : compound_statement");
         main->add_child($1);
         
         
         $$=main;
         

         fprintf(logout,"statement : compound_statement  \n");
	}
	| 
	FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("FOR : for");

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@6.first_line);
         p3->set_ends(0);
         p3->Production("RPAREN : )");

        

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child($4);
         main->add_child($5);
         main->add_child(p3);
         main->add_child($7);
         
         
         $$=main;
         

         fprintf(logout,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement  \n");
	}
	| 
	IF LPAREN expression RPAREN statement %prec LOW
	{
          Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("IF : if");

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("RPAREN : )");

        

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : IF LPAREN expression RPAREN statement");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child(p3);
         main->add_child($5);
         
         
         $$=main;
         

         fprintf(logout,"statement : IF LPAREN expression RPAREN statement  \n");
	}
	| 
	IF LPAREN expression RPAREN statement ELSE statement
	{
		  Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("IF : if");

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("RPAREN : )");

         Parse_tree_eachnode* p4=new Parse_tree_eachnode();
         p4->set_start(@6.first_line);
         p4->set_ends(0);
         p4->Production("ELSE : else");

        

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : IF LPAREN expression RPAREN statement ELSE statement");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child(p3);
         main->add_child($5);
         main->add_child(p4);
         main->add_child($7);
         
         
         $$=main;
         

         fprintf(logout,"statement : IF LPAREN expression RPAREN statement ELSE statement  \n");
	}
	| 
	WHILE LPAREN expression RPAREN statement
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("WHILE : while");


         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("RPAREN : )");

         

        

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : WHILE LPAREN expression RPAREN statement");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child(p3);
         main->add_child($5);
         
         
         
         $$=main;
         

         fprintf(logout,"statement : WHILE LPAREN expression RPAREN statement  \n");
	}
	| 
	PRINTLN LPAREN ID RPAREN SEMICOLON
	{
	     Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("PRINTLN : println");


         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@3.first_line);
         p3->set_ends(0);
         p3->Production("ID : "+$3->get_name());
           SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($3->get_name());
            
            $3->stackSize=symbolinfo->stackOffset;
            p3->declaration_list.push_back($3);


         Parse_tree_eachnode* p4=new Parse_tree_eachnode();
         p4->set_start(@4.first_line);
         p4->set_ends(0);
         p4->Production("RPAREN : )");

         Parse_tree_eachnode* p5=new Parse_tree_eachnode();
         p5->set_start(@5.first_line);
         p5->set_ends(0);
         p5->Production("SEMICOLON : ;");

         

        

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : PRINTLN LPAREN ID RPAREN SEMICOLON");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child(p3);
         main->add_child(p4);
         main->add_child(p5);
         main->stack_offset=symbolinfo->stackOffset;

            for(int i=0;i<global_varlist.size;i++)
            {
                 
               
                   if(strcmp(global_varlist.array[i].symbolInfo->get_name().c_str(), $3->get_name().c_str()) == 0 && symbolinfo->is_Global) {
                            
                          main->is_Global=1;
                           
                   }                     
                             
            }
         
         
         
         $$=main;
         

         fprintf(logout,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON  \n");
	}
	| 
	RETURN expression SEMICOLON
	{
       Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("RETURN : return");
         p1->funcname=funcname;


         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@3.first_line);
         p2->set_ends(0);
         p2->Production("SEMICOLON : ;");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("statement : RETURN expression SEMICOLON");
         main->add_child(p1);
         main->add_child($2);
         main->add_child(p2);
         $$=main;
         

         fprintf(logout,"statement : RETURN expression SEMICOLON\n");
         
         
	}
	;
	  
expression_statement : 
	SEMICOLON
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("SEMICOLON : ;");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("expression_statement : SEMICOLON");
         main->add_child(p1);
         
         $$=main;

         fprintf(logout,"expression_statement : SEMICOLON 		 \n");

	}			
	| 
	expression SEMICOLON 
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("SEMICOLON : ;");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("expression_statement : expression SEMICOLON");
         main->add_child($1);
         main->add_child(p1);
         
         $$=main;

         fprintf(logout,"expression_statement : expression SEMICOLON 		 \n");
         if(error_f)
         {
            fprintf(errorout,"at expression of expression statement\n");
            error_f=0;
         }
	}
	;
	  
variable : 
	ID
	{
         Variable *variable=(Variable*)symbol_table.Lookup_Symbol($1->get_name());
         SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($1->get_name());
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         if(variable!=nullptr)
         {
            
            p1->set_parse_data(variable->get_data_type());
            main->set_parse_data(variable->get_data_type());
           
            $1->stackSize=symbolinfo->stackOffset;
            main->declaration_list.push_back($1);
            for(int i=0;i<global_varlist.size;i++)
            {
               
                   if(strcmp(global_varlist.array[i].symbolInfo->get_name().c_str(), variable->get_name().c_str()) == 0 && symbolinfo->is_Global) {
       
                           main->is_Global=true;
                  }                     
                             
            }
            
           

           
            
            
         }
         else{
            fprintf(errorout,"Line# %d: Undeclared variable '%s'\n",@1.first_line,$1->get_name().c_str());
            errors++;
         }
         p1->Production("ID : "+$1->get_name());
         argument_variable.push_back($1->get_name());
         
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         
         main->Production("variable : ID");
         main->add_child(p1);
         
         $$=main;
         $$->stack_offset=symbolinfo->stackOffset;
         $$->declaration_list.push_back($1);
         fprintf(logout,"variable : ID 	 \n");
	} 		
	| 
	ID LSQUARE expression RSQUARE 
	{
         SymbolInfo *symbolinfo=symbol_table.Lookup_Symbol($1->get_name());
         Variable *variable=(Variable*)symbol_table.Lookup_Symbol($1->get_name());
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data(variable->get_data_type());
         p1->Production("ID : "+$1->get_name());
         p1->declaration_list.push_back($1);
         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LSQUARE : [");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("RSQUARE : ]");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data(variable->get_data_type());
         main->Production("variable : ID LSQUARE expression RSQUARE");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child(p3);
         $1->stackSize=symbolinfo->stackOffset;
         $1->arraySize=10;
         
          main->declaration_list.push_back($1);
         for(int i=0;i<global_varlist.size;i++)
         {
               
                   if(strcmp(global_varlist.array[i].symbolInfo->get_name().c_str(), variable->get_name().c_str()) == 0) {
       
                           main->is_Global=true;
                  }                     
                             
         }
         $$=main;
         $$->stack_offset=symbolinfo->stackOffset;
         fprintf(logout,"variable : ID LSQUARE expression RSQUARE  	 \n");


	}
	;
	 
expression : 
	logic_expression	
	{
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("expression : logic_expression");
         main->add_child($1);
        
         $$=main;

         fprintf(logout,"expression 	: logic_expression	 \n");
	}
	| 
	variable ASSIGNOP logic_expression 	
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("ASSIGNOP : =");
        

     

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("expression : variable ASSIGNOP logic_expression");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;

         fprintf(logout,"expression 	: variable ASSIGNOP logic_expression 		 \n");
	}
    |
    error
		{
            
			yyclearin;
            Parse_tree_eachnode* main=new Parse_tree_eachnode();
            main->set_start(@$.first_line);
            main->set_ends(0);
            main->Production("expression  : error");
            error_f=1;
         
            $$=main;
            
           
            
            
			
		}
	;
			
logic_expression : 
	rel_expression 	
	{
         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("logic_expression : rel_expression");
         main->add_child($1);
         
         $$=main;
         
         fprintf(logout,"logic_expression : rel_expression 	 \n");
	}
	| 
	rel_expression LOGICOP rel_expression 	
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("LOGICOP : "+$2->get_name());
            
            
            p1->declaration_list.push_back($2);

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("logic_expression : rel_expression LOGICOP rel_expression");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;
         fprintf(logout,"logic_expression : rel_expression LOGICOP rel_expression 	 	 \n");
	}
	;
			
rel_expression	: 
	simple_expression 
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("rel_expression : simple_expression");
         main->add_child($1);
         
         $$=main;
        
         fprintf(logout,"rel_expression\t: simple_expression \n");
	}
	| 
	simple_expression RELOP simple_expression	
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("RELOP : "+$2->get_name());
        
            
            p1->declaration_list.push_back($2);

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("rel_expression : simple_expression RELOP simple_expression");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;

         fprintf(logout,"rel_expression	: simple_expression RELOP simple_expression	  \n");
	}
	;
				
simple_expression : 
	term
	{
         
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("simple_expression : term");
         main->add_child($1);
         
         $$=main;
         
         fprintf(logout,"simple_expression : term \n");
	} 
	| simple_expression ADDOP term 
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("ADDOP : "+$2->get_name());
         
           
            
            p1->declaration_list.push_back($2);
            

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("simple_expression : simple_expression ADDOP term");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;

         fprintf(logout, "simple_expression : simple_expression ADDOP term  \n");
	}
	;
					
term :	
	unary_expression
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("term : unary_expression");
         main->add_child($1);
         
         $$=main;
         fprintf(logout,"term :	unary_expression \n");
	}
    |  
	term MULOP unary_expression
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("MULOP : "+$2->get_name());
            
            p1->declaration_list.push_back($2);
         
         

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("term : term MULOP unary_expression");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;

         fprintf(logout,"term :	term MULOP unary_expression \n");
	}
    ;

unary_expression : 
	ADDOP unary_expression 
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("ADDOP : "+$1->get_name());
            
            p1->declaration_list.push_back($1);

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($2-> get_parse_data());
         main->Production("unary_expression : ADDOP unary_expression");
         main->add_child(p1);
         main->add_child($2);
         $$=main;

         fprintf(logout,"unary_expression\t: ADDOP unary_expression \n");
	} 
	| 
	NOT unary_expression 
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("NOT : !");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($2-> get_parse_data());
         main->Production("unary_expression : NOT unary_expression");
         main->add_child(p1);
         main->add_child($2);
         $$=main;

         fprintf(logout,"unary_expression\t: NOT unary_expression \n");
	}
	|
	factor 
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("unary_expression : factor");
         main->add_child($1);
         main->declaration_list=$1->declaration_list;
         $$=main;
         
         fprintf(logout,"unary_expression : factor \n");
	}
	;
	
factor	: 
	variable
	{
	    Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("factor : variable");
         main->add_child($1);
         $$=main;
         fprintf(logout,"factor\t: variable \n");
        
	}
	| 
	ID LPAREN argument_list RPAREN
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("ID : "+$1->get_name());
         p1->declaration_list.push_back($1);

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@2.first_line);
         p2->set_ends(0);
         p2->Production("LPAREN : (");

         Parse_tree_eachnode* p3=new Parse_tree_eachnode();
         p3->set_start(@4.first_line);
         p3->set_ends(0);
         p3->Production("RPAREN : )");

        
         Function *function=(Function*)symbol_table.Lookup_Symbol($1->get_name());
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         if(function!=nullptr)
         {
            main->set_parse_data(function->get_return_function());
           
         }
        
         
         main->Production("factor : ID LPAREN argument_list RPAREN");
         main->add_child(p1);
         main->add_child(p2);
         main->add_child($3);
         main->add_child(p3);
         $$=main;

         fprintf(logout,"factor	: ID LPAREN argument_list RPAREN  \n");
         

        
         argument_check($1->get_name(),myArgumentList.array,myArgumentList.size,@1.first_line);
         myArgumentList.size=0;


         
	}
	| 
	LPAREN expression RPAREN
	{
	    Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->Production("LPAREN : (");

         Parse_tree_eachnode* p2=new Parse_tree_eachnode();
         p2->set_start(@3.first_line);
         p2->set_ends(0);
         p2->Production("RPAREN : )");

         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($2-> get_parse_data());
         main->Production("factor : LPAREN expression RPAREN");
         main->add_child(p1);
         main->add_child($2);
         main->add_child(p2);
         
         $$=main;

         fprintf(logout,"factor	: LPAREN expression RPAREN   \n");
	}
	| 
	CONST_INT 
	{
         Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data("INT");
         p1->Production("CONST_INT : "+ $1->get_name());
         zero_or_not=$1->get_name();

         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data("INT");
         main->Production("factor : CONST_INT");
         main->add_child(p1);
            
            main->declaration_list.push_back($1);
         
         $$=main;

         fprintf(logout,"factor	: CONST_INT   \n");
	}
	| 
	CONST_FLOAT
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         p1->set_parse_data("FLOAT");
         p1->Production("CONST_FLOAT : "+$1->get_name());

         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data("FLOAT");
         main->Production("factor : CONST_FLOAT");
         main->add_child(p1);
            
            main->declaration_list.push_back($1);
         
         
         $$=main;

         fprintf(logout,"factor	: CONST_FLOAT   \n");
	}
	| 
	variable INCOP 
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("INCOP : "+$2->get_name());
            
            
            p1->declaration_list.push_back($2);
         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("factor : variable INCOP");
         main->add_child($1);
         main->add_child(p1);
         
         $$=main;
         fprintf(logout,"factor\t: variable INCOP \n");
	}
	| 
	variable DECOP
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("DECOP : --");

         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->set_parse_data($1-> get_parse_data());
         main->Production("factor : variable DECOP");
         main->add_child($1);
         main->add_child(p1);
         
         $$=main;
         fprintf(logout,"factor\t: variable DECOP \n");
	}
	;
	
argument_list : 
	arguments
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("argument_list : arguments");
         main->add_child($1);
         
         
         $$=main;
         $$->stack_offset = $1->stack_offset;
         fprintf(logout,"argument_list : arguments  \n");
	}
	|
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("argument_list : ");
         main->stack_offset=0;
         $$=main;
         fprintf(logout,"argument_list\t: ");
	}
	;
	
arguments : 
	arguments COMMA logic_expression
	{
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("COMMA : ,");

         
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("arguments : arguments COMMA logic_expression");
         main->add_child($1);
         main->add_child(p1);
         main->add_child($3);
         $$=main;
         $$->stack_offset = $1->stack_offset+2;
         fprintf(logout,"arguments : arguments COMMA logic_expression \n");
         
         string* newArray = new string[myArgumentList.size+2];
        if(myArgumentList.size>0){
        for (int i = 0; i < myArgumentList.size ; ++i) {
            newArray[i] = myArgumentList.array[i];
        }
        }
        
        newArray[myArgumentList.size] = $3->get_parse_data();
        delete[] myArgumentList.array;
        myArgumentList.size++;
        myArgumentList.array = newArray;
        
        
       



        

        
	}
	| 
	logic_expression
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("arguments : logic_expression");
         main->add_child($1);
         $$=main;
         $$->stack_offset = 2;
         fprintf(logout,"arguments : logic_expression\n");
         
          
         string* newArray = new string[myArgumentList.size+2];
         if(myArgumentList.size>0){
        for (int i = 0; i < myArgumentList.size; ++i) {
            newArray[i] = myArgumentList.array[i];
        }
         }

        
        newArray[myArgumentList.size] = $1->get_parse_data();
        delete[] myArgumentList.array;
        myArgumentList.size++;
        myArgumentList.array = newArray;
       
        
         
       
	}

   
	;
			



%%



int main(int argc, char const *argv[])
{
if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file.c> \n", argv[0]);
        exit(EXIT_FAILURE);
    }

    FILE *input_file = fopen(argv[1], "r");
    if (input_file == NULL) {
        perror("Error opening input file");
        printf("Error");
        exit(EXIT_FAILURE);
    }
    myVarDeclList.array=nullptr;
    myVarDeclList.size=0;
	global_varlist.array=nullptr;
	global_varlist.size=0;
    myArgumentList.array = nullptr;
    myArgumentList.size = 0;
    
    errorout = fopen("error.txt", "w");
    logout=fopen("log.txt","w");
    codeout=fopen("code.asm","w");
    output_file = fopen("parsetree.txt", "w");
     
    yyin = input_file;

    
    freopen("parser.txt", "w", stdout);

     if (yyin == NULL) {
        perror("Error setting input file");
        printf("Error: Unable to set input file\n");
        fclose(input_file);
        fclose(output_file);
        exit(EXIT_FAILURE);
    }

    
    yyparse();
   
    fprintf(logout,"Total Lines: %d\n",line_count);
    fprintf(logout,"Total Errors: %d\n",errors);
    
    fclose(input_file);
    fclose(output_file);

    return 0;

	
		
}
   

    