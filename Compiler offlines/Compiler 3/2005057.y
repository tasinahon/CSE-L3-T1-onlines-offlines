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
    #include "y.tab.h"

     
    extern FILE *yyin;
    extern int line_count;
    extern int errors;
    FILE *output_file;
    FILE *logout;
    int error_f=0;
    FILE *errorout;
    int yylex(void);
    int yyparse(void);


    void yyerror(char *s)
    {

	      fprintf(errorout,"Line# %d: Syntax error ",line_count,s);
          fprintf(logout,"Error at line no %d : %s\n",line_count,s);
          errors++;
          
    }


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

struct VarDeclElement {
    SymbolInfo* symbolInfo;
    int intValue;
};

struct VarDeclNode {
    VarDeclElement data;
    Parse_tree_eachnode* parse_tree_eachnode=nullptr;
};

struct VarDeclList {
    VarDeclNode* array;
    int size;
};

VarDeclList myVarDeclList;



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
void used_void_func()
{

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
%right  NOT
%right  INCOP DECOP
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
		type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
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
	type_specifier ID LPAREN parameter_list RPAREN compound_statement
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
            main->add_child($6);
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
            if(symbolinfo==nullptr)
            {
                
                    symbol_table.Insert_Symbol((SymbolInfo*)function);
                
                 
            }
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
            if(error_f)
            {
                fprintf(errorout,"at parameter list of function definition\n");
                error_f=0;
            }

           

            
            

            
        

                    
            
	}
	| 
	type_specifier ID LPAREN RPAREN compound_statement
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
            main->add_child($5);
            $$=main;

            fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");

            Function *function=new Function();
            function->set_name($2->get_name());
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

        
        symbol_table.Enter_Scope();
        if(!error_f)
        {
             
            
        if(arraySize>0)
        {
            
            for(int i=0;i<arraySize;i++)
            {
                Variable* variable=new Variable();
                variable->set_name(myStringPairs[i].second);
                variable->set_type("variable");
                variable->set_data_type(myStringPairs[i].first);
                SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
                if(symbolinfo==nullptr )
                {
                   symbol_table.Insert_Symbol((SymbolInfo*)variable);
                }
                
            }

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

         if(myVarDeclList.size>=0){
         for(int i=0;i<myVarDeclList.size;i++)
         {
            
            Parse_tree_eachnode *parse_tree_eachnode2=new Parse_tree_eachnode();
            parse_tree_eachnode2->set_parse_data($1->get_parse_data());
            
            myVarDeclList.array[i].parse_tree_eachnode=parse_tree_eachnode2;
            
            Variable* variable=new Variable();
            variable->set_name(myVarDeclList.array[i].data.symbolInfo->get_name());
            variable->set_type("variable");
            variable->set_data_type($1->get_parse_data());
            
            variable->set_array_size(myVarDeclList.array[i].data.intValue);
            SymbolInfo *symbolinfo=symbol_table.get_current_scope()->Lookup(variable->get_name());
            if(variable->get_data_type()=="VOID")
            {    
                 fprintf(errorout,"Line# %d: Variable or field '%s' declared void\n",@1.first_line,myVarDeclList.array[i].data.symbolInfo->get_name().c_str());
                 errors++;
                 
            }
            else if(symbolinfo==nullptr){
                 symbol_table.Insert_Symbol((SymbolInfo*)variable);
            }
            else{
                fprintf(errorout,"Line# %d: Conflicting types for'%s'\n",@1.first_line,variable->get_name().c_str());
                errors++;
            }
            
         }
         }
         myVarDeclList.size=0;
        }

        if(error_f)
        {
            error_f=0;
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

         VarDeclElement newVarDeclElement;
         newVarDeclElement.symbolInfo = $3;
         newVarDeclElement.intValue = -1;

         Parse_tree_eachnode* newParseTreeNode = p2;
         myVarDeclList.size++;
         myVarDeclList.array = (VarDeclNode*)realloc(myVarDeclList.array, myVarDeclList.size * sizeof(VarDeclNode));
         myVarDeclList.array[myVarDeclList.size - 1].data = newVarDeclElement;
         myVarDeclList.array[myVarDeclList.size - 1].parse_tree_eachnode = newParseTreeNode;
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

         VarDeclElement newVarDeclElement;
         newVarDeclElement.symbolInfo = $3;
         newVarDeclElement.intValue = stoi($5->get_name());


        Parse_tree_eachnode* newParseTreeNode = p2;
         myVarDeclList.size++;
         myVarDeclList.array = (VarDeclNode*)realloc(myVarDeclList.array, myVarDeclList.size * sizeof(VarDeclNode));
         myVarDeclList.array[myVarDeclList.size - 1].data = newVarDeclElement;
         myVarDeclList.array[myVarDeclList.size - 1].parse_tree_eachnode = newParseTreeNode;


        
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

         VarDeclElement newVarDeclElement;
         newVarDeclElement.symbolInfo = $1;
         newVarDeclElement.intValue = -1;

         Parse_tree_eachnode* newParseTreeNode = p1;
         myVarDeclList.size++;
         myVarDeclList.array = (VarDeclNode*)realloc(myVarDeclList.array, myVarDeclList.size * sizeof(VarDeclNode));
         myVarDeclList.array[myVarDeclList.size - 1].data = newVarDeclElement;
         myVarDeclList.array[myVarDeclList.size - 1].parse_tree_eachnode = newParseTreeNode;
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

         VarDeclElement newVarDeclElement;
         newVarDeclElement.symbolInfo = $1;
         newVarDeclElement.intValue =  stoi($3->get_name());

         Parse_tree_eachnode* newParseTreeNode = p1;
         myVarDeclList.size++;
         myVarDeclList.array = (VarDeclNode*)realloc(myVarDeclList.array, myVarDeclList.size * sizeof(VarDeclNode));
         myVarDeclList.array[myVarDeclList.size - 1].data = newVarDeclElement;
         myVarDeclList.array[myVarDeclList.size - 1].parse_tree_eachnode = newParseTreeNode;
         
         

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
		 Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@1.first_line);
         p1->set_ends(0);
         Parse_tree_eachnode* main=new Parse_tree_eachnode();
         if(variable!=nullptr)
         {
            
            p1->set_parse_data(variable->get_data_type());
            main->set_parse_data(variable->get_data_type());
         }
         else{
            fprintf(errorout,"Line# %d: Undeclared variable '%s'\n",@1.first_line,$1->get_name().c_str());
            errors++;
         }
         p1->Production("ID : "+$1->get_name());

         
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         
         main->Production("variable : ID");
         main->add_child(p1);
         
         $$=main;

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
         if(variable!=nullptr)
         {
            p1->set_parse_data(variable->get_data_type());
            if(variable->get_array_size()==-1)
            {
                fprintf(errorout,"Line# %d: '%s' is not an array\n",@1.first_line,$1->get_name().c_str());
                errors++;
            }
            if($3->get_parse_data()!="INT")
            {
                fprintf(errorout,"Line# %d: Array subscript is not an integer\n",@1.first_line);
                errors++;
            }
            
            
         }
         else{
            fprintf(errorout,"Line# %d: Undeclared variable '%s'\n",@1.first_line,$1->get_name().c_str());
            errors++;

         }

         
         p1->Production("ID : "+$1->get_name());

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
         $$=main;

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
        

         if($1->get_parse_data()=="INT" && $3->get_parse_data()=="FLOAT")
         {
            fprintf(errorout,"Line# %d: Warning: possible loss of data in assignment of FLOAT to INT\n",@1.first_line);
            errors++;
         }

         if($1->get_parse_data()=="VOID" || $3->get_parse_data()=="VOID")
         {
            fprintf(errorout,"Line# %d: Void cannot be used in expression \n",@1.first_line);
            errors++;
         }

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
         if($1->get_parse_data()=="VOID" || $3->get_parse_data()=="VOID")
         {
            fprintf(errorout,"Line# %d: Void cannot be used in expression \n",@1.first_line);
            errors++;
         }
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

         
         if($2->get_name()=="%")
         {
            if($1->get_parse_data()!="INT" || $3->get_parse_data()!="INT")
            {
                fprintf(errorout,"Line# %d: Operands of modulus must be integers \n",@1.first_line);
                errors++;
            }
         }
         if(zero_or_not=="0")
         {
            fprintf(errorout,"Line# %d: Warning: division by zero i=0f=1Const=0\n",@1.first_line);
            errors++;
         }

          if($1->get_parse_data()=="VOID" || $3->get_parse_data()=="VOID")
         {
            fprintf(errorout,"Line# %d: Void cannot be used in expression \n",@1.first_line);
            errors++;
         }
         

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
         
         
         $$=main;

         fprintf(logout,"factor	: CONST_FLOAT   \n");
	}
	| 
	variable INCOP 
	{
		Parse_tree_eachnode* p1=new Parse_tree_eachnode();
         p1->set_start(@2.first_line);
         p1->set_ends(0);
         p1->Production("INCOP : ++");

         
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
         fprintf(logout,"argument_list : arguments  \n");
	}
	|
	{
		 Parse_tree_eachnode* main=new Parse_tree_eachnode();
         main->set_start(@$.first_line);
         main->set_ends(@$.last_line);
         main->Production("argument_list : ");
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
    myArgumentList.array = nullptr;
    myArgumentList.size = 0;
    
    errorout = fopen("error.txt", "w");
    logout=fopen("log.txt","w");
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





struct VarDeclElement {
    SymbolInfo* symbolInfo;
    int intValue;
};

struct VarDeclNode {
    VarDeclElement data;
    Parse_tree_eachnode* parse_tree_eachnode=nullptr;
};

struct VarDeclList {
    VarDeclNode* array;
    int size;
};

VarDeclList myVarDeclList;

































string newLineProc = "NEWLINE PROC\n\tPUSH AX\n\tPUSH DX\n\tMOV AH,2\n\tMOV DL,CR\n\tINT 21H\n\tMOV AH,2\n\tMOV DL,LF\n\tINT 21H\n\tPOP DX\n\tPOP AX\n\tRET\nNEWLINE ENDP\n";
            string printOutputProc = "PRINTNUMBER PROC  ;PRINT WHAT IS IN AX\n\tPUSH AX\n\tPUSH BX\n\tPUSH CX\n\tPUSH DX\n\tPUSH SI\n\tLEA SI,NUMBER\n\tMOV BX,10\n\tADD SI,4\n\tCMP AX,0\n\tJNGE NEGATE\n\tPRINT:\n\tXOR DX,DX\n\tDIV BX\n\tMOV [SI],DL\n\tADD [SI],'0'\n\tDEC SI\n\tCMP AX,0\n\tJNE PRINT\n\tINC SI\n\tLEA DX,SI\n\tMOV AH,9\n\tINT 21H\n\tPOP SI\n\tPOP DX\n\tPOP CX\n\tPOP BX\n\tPOP AX\n\tRET\n\tNEGATE:\n\tPUSH AX\n\tMOV AH,2\n\tMOV DL,'-'\n\tINT 21H\n\tPOP AX\n\tNEG AX\n\tJMP PRINT\nPRINTNUMBER ENDP\n";
            string header = ";-------\n;\n;-------\n.MODEL SMALL\n.STACK 1000H\n.DATA\n\tCR EQU 0DH\n\tLF EQU 0AH\n\tNUMBER DB \"00000$\"\n";
            fprintf(logout,header.c_str());
            for(int i=0; i<global_varlist.size; i++){
                if(global_varlist.array[i].intValue!=-1){
					fprintf(logout,"\t%s DW %d DUP (0000H)\n",global_varlist.array[i].symbolInfo->get_name().c_str(),global_varlist.size);
                    
                }
                else{
					fprintf(logout,"\t%s DW 1 DUP (0000H)\n",global_varlist.array[i].symbolInfo->get_name().c_str());
                    
                }
            }
			fprintf(logout,".CODE\n");
            Parse_tree_eachnode **child=root->get_child();
            codegeneration(t+1,child[0]);
			fprintf(logout,"%s",newLineProc.c_str());
			fprintf(logout,"%s",printOutputProc.c_str());
			fprintf(logout,"END main\n");
   
 VarDeclNode newVarDeclNode($1, -1);
         myVarDeclList.size++;
         myVarDeclList.array = (VarDeclNode*)realloc(myVarDeclList.array, myVarDeclList.size * sizeof(VarDeclNode));
         myVarDeclList.array[myVarDeclList.size - 1] = newVarDeclNode;
		 $$->setSymbol(myVarDeclList);
    