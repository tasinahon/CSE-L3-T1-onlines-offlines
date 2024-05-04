#ifndef VAR_DECL_NODE_HPP
#define VAR_DECL_NODE_HPP

#include<bits/stdc++.h>
#include "2005057.hpp"
using namespace std;

class VarDeclNode {
public:
    SymbolInfo* symbolInfo;
    int intValue;
    bool is_Global;
    int stackSize;
    

    
    VarDeclNode() : symbolInfo(new SymbolInfo()), intValue(-1) {}

    VarDeclNode(SymbolInfo* symbolInfo, int intValue)
    {
        this->symbolInfo=new SymbolInfo();
        this->symbolInfo=symbolInfo;
        this->intValue=intValue;
        this->is_Global=false;
        this->stackSize=0;
    }
       

    
   

    
};
class VarDeclList {
public:
    VarDeclNode* array;
    int size;

    
    VarDeclList() : array(nullptr), size(0) {}

    
   

    
    void addVarDeclNode(SymbolInfo* symbolInfo, int intValue) {
        array=nullptr;
        size=0;
        VarDeclNode newVarDeclNode(symbolInfo, intValue);
      
        // size++;
        // array = (VarDeclNode*)realloc(array, size * sizeof(VarDeclNode));
        // array[size - 1] = newVarDeclNode;
    }

   
};
#endif