
#include <bits/stdc++.h>
#include "2005057.hpp"
using namespace std;

#ifndef FUNCTION_H
#define FUNCTION_H

class Function {
private:
    SymbolInfo symbol_info;
    string return_function;
    string* params;
    int no_of_parameter;

public:
    Function() ;
    string get_return_function() ;
       
    

    string* get_params()  ;
        
    

    int get_no_of_parameter();  
        
    

    void set_name(string name)  ;
        
        
    string get_name();

    void set_type(string type) ; 
        
        
    

    void set_return_function(string return_function)  ;
        
        
    

   void set_params(string* param_type, int no) ;
    
};
    

#endif