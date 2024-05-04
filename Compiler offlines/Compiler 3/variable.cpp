#include "variable.hpp"
#include<bits/stdc++.h>
using namespace std;

    Variable::Variable()
    {
        
    } 

    string  Variable::get_data_type()  {
        return data_type;
    }

    int Variable::get_array_size()  {
        return array_size;
    }

    string Variable::get_name()
    {
        return symbol_info.get_name();
    }

    void Variable::set_name(string name)  {
        symbol_info.set_name(name);
        
    }

    void Variable::set_type(string type) {
        symbol_info.set_type(type);
        
    }

    void Variable::set_data_type(string data_type) {
        this->data_type = data_type;
        
    }

    void Variable::set_array_size(int array_size)  {
        this->array_size = array_size;
        
    }
