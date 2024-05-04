
#include <bits/stdc++.h>
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


    Parse_tree_eachnode();
   




    void add_child(Parse_tree_eachnode *child);
    
    ~Parse_tree_eachnode();
   
    void set_parse_data(string data);
    

    void set_child(Parse_tree_eachnode **child, int child_no);
   
    void set_start(int start);
  
    void set_ends(int ends);
   
    void Production(string p_rule);
    
    int get_start();
    
    int get_ends();
    
    string get_productionrule();
   
    string get_parse_data();
    
    Parse_tree_eachnode** get_child();
    

    void print_parsetree(FILE *_output_file, Parse_tree_eachnode *_root, int _depth);

};
#endif