
#include <bits/stdc++.h>
#include "2005057.hpp"
#include "myVar.hpp"
using namespace std;
#ifndef PARSE_TREE_EACHNODE_H
#define PARSE_TREE_EACHNODE_H


class Parse_tree_eachnode{
    private:


    string Production_rule;
    string parse_data="ahon";
    Parse_tree_eachnode **child;
    
    int child_no;
    int start,ends;
    
    
    
    
public:
    VarDeclList symbol;
    string funcname;
    static vector<SymbolInfo*> globalVariable;
    
    vector<SymbolInfo*> declaration_list; 
    vector<SymbolInfo*> parameterlist;
    vector<string>function_name;
    vector<int>arglist_stack;
    int stack_offset;
    bool is_Global;
    int symbolsize=0;
    bool isCond;
    string lTrue;
    string lFalse;
    string lEnd;

    Parse_tree_eachnode();
   




    void add_child(Parse_tree_eachnode *child);
    
    ~Parse_tree_eachnode();
   
    void set_parse_data(string data);
    

    void set_child(Parse_tree_eachnode **child, int child_no);
   
    void set_start(int start);
  
    void set_ends(int ends);

    void set_parameterlist(vector<SymbolInfo*> s);

    void add_parameter(SymbolInfo* s);
   
    void Production(string p_rule);
    
    int get_start();
    
    int get_ends();
    
    string get_productionrule();
   
    string get_parse_data();
    
    Parse_tree_eachnode** get_child();
    void setSymbol(VarDeclList s);
    VarDeclList getSymbol();
    

    void print_parsetree(FILE *_output_file, Parse_tree_eachnode *_root, int _depth);

};
#endif