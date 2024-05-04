#include <bits/stdc++.h>
#include "2005057.hpp"
using namespace std;
#ifndef VARIABLE_H
#define VARIABLE_H

class Variable {
private:
    SymbolInfo symbol_info;
    string data_type;
    int array_size;

public:
    Variable();
     

    string  get_data_type()  ;
   

    int get_array_size()  ;

    string get_name();
   

    void set_name(string name)  ;
   

    void set_type(string type) ;
    

    void set_data_type(string data_type) ;
    

    void set_array_size(int array_size)  ;
    
};


#endif