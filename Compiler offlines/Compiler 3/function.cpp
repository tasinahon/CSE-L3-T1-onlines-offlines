#include "function.hpp"
#include<bits/stdc++.h>

using namespace std;

    Function::Function() 
    {
        
    }
    string Function::get_return_function()  {
        return return_function;
    }

    string* Function::get_params()  {
        return params;
    }

    string Function::get_name()
    {
        return symbol_info.get_name();
    }

    int Function::get_no_of_parameter()  {
        return no_of_parameter;
    }

    void Function::set_name(string name)  {
        symbol_info.set_name(name);
        
    }

    void Function::set_type(string type)  {
        symbol_info.set_type(type);
        
    }

    void Function::set_return_function(string return_function)  {
        this->return_function=return_function;
        
    }

   void Function::set_params(string* param_type, int no) {
    this->params = new string[no+1];
    for (int i = 0; i < no; i++) {
        this->params[i] = param_type[i];
    }
    this->no_of_parameter = no;
    
    }
