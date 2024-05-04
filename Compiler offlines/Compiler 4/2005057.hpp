#include<bits/stdc++.h>
using namespace std;
#ifndef _2005057_HPP_
#define _2005057_HPP_


#pragma once
#include<bits/stdc++.h>
using namespace std;
typedef long long int ll;
typedef double db;



class SymbolInfo
{
private:
    string name;
    string type;
    SymbolInfo *next;
    int position;
    int info_type;
    string type_of_data;
    string array_size;
public :
    int stackOffset;
    bool is_Global;
    int arraySize;
    int stackSize;
    SymbolInfo(string name,string type)
    {
        this->name=name;
        this->type=type;
        this->next=NULL;
        this->arraySize=-1;
        this->is_Global=false;
        this->stackSize=0;
    }
    SymbolInfo() : next(nullptr), position(-1), info_type(-1) {}
    void set_position(int pos)
    {
        position=pos;
    }
    int get_position()
    {
        return position;
    }
    void set_name(string name)
    {
        this->name=name;
    }
    string get_name()
    {
        return this->name;
    }
    void set_type(string type)
    {
        this->type=type;
    }
    string get_type()
    {
        return this->type;
    }
    void set_next(SymbolInfo *symbolinfo)
    {
        this->next=symbolinfo;
    }
    SymbolInfo* get_next()
    {
        return this->next;
    }
     void set_info_type(int type)
    {
        this->info_type=type;
    }
    int get_info_type()
    {
        return this->info_type;
    }
    
    bool function_or_not()
    {
        if(this->type=="FUNCTION_DECLARATION" || this->type=="FUNCTION_DEFINITION")
        {
            
            return true;
        }
        return false;
    }
    void set_type_of_data(string type_of_data)
    {
        this->type_of_data=type_of_data;
    }
    string get_type_of_data()
    {
        return type_of_data;
    }

};


class ScopeTable
{

private:
    SymbolInfo **container;
    ScopeTable *parent_scope;
    int bucket_number;
    int scope_id;
    int count_deleted_scope;
    int fixed_indentation;

public:
    int stack_offset=0;
    ScopeTable(int bucket_number,ScopeTable *parent_scope)
    {
        if (parent_scope == NULL)
        {
            scope_id = 1;
        }
        else
        {
            scope_id = parent_scope->get_scope_id() + (parent_scope->count_deleted_scope+1);
        }
        this->bucket_number=bucket_number;
        this->parent_scope=parent_scope;
        container=new SymbolInfo*[bucket_number+1];
        for(int i=0; i<bucket_number; i++)
        {

            container[i]=NULL;
        }
        this->count_deleted_scope=0;

       // output<<"\tScopeTable# "<<scope_id<<" created"<<endl;


    }
    ~ScopeTable()
    {
        for (int i = 0; i < bucket_number; i++)
        {
            SymbolInfo* current = container[i];
            while (current != NULL)
            {
                SymbolInfo* temp = current;
                current = current->get_next();
                delete temp;
            }
        }

        delete[] container;
    }
    SymbolInfo** get_container()
    {
        return container;
    }
    void set_scope_id(int id)
    {
        this->scope_id=id;
    }
    int get_scope_id()
    {
        return this->scope_id;
    }

    void set_parent_scope(ScopeTable *parent_scope)
    {
        this->parent_scope=parent_scope;
    }


    ScopeTable* get_parent_scope()
    {

        return this->parent_scope;
    }

    int get_bucket_number()
    {
        return this->bucket_number;
    }
    int get_count_deleted_scope()
    {
        return count_deleted_scope;
    }
    void set_count_deleted_scope(int scope)
    {
        this->count_deleted_scope=scope;
    }
    void set_fixed_indentation(int indent)
    {
        fixed_indentation = indent;
    }

    int get_fixed_indentation()
    {
        return fixed_indentation;
    }


    static unsigned long long SDBMHash(string str)
    {
        unsigned long long hash = 0;
        unsigned int i = 0;
        unsigned int len = str.length();

        for (i = 0; i < len; i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
        }

        return hash;
    }
    bool Insert(SymbolInfo *symbolinfo) {
    int count = 1;
    int pos = SDBMHash(symbolinfo->get_name()) % bucket_number;
    SymbolInfo *current_node = container[pos];

    while (current_node != NULL) {
        if (current_node->get_name() == symbolinfo->get_name()) {
            // fprintf(output, "\t%s already exists in the current ScopeTable\n",
            //         symbolinfo->get_name().c_str());
            return false;
        }
        current_node = current_node->get_next();
    }

    if (container[pos] == NULL) {
        symbolinfo->set_position(count);
        container[pos] = symbolinfo;
       
    } else {
        current_node = container[pos];
        while (current_node->get_next() != NULL) {
            current_node = current_node->get_next();
            count++;
            symbolinfo->set_position(count);
        }

        count++;
        symbolinfo->set_position(count);
        current_node->set_next(symbolinfo);
       
    }

    return true;
}


    SymbolInfo* Lookup(string name)
    {
        int pos=SDBMHash(name)%bucket_number;
        SymbolInfo *node=container[pos];
        while(node!=NULL)
        {
            if(node->get_name()==name)
            {
               // output<<"\t'"<<name<<"' found at position <"<<pos+1<<", "<<node->get_position() <<"> of ScopeTable# "<<scope_id<<endl;
                return node;
            }
            node=node->get_next();
        }

        return NULL;
    }
    bool Delete(string name)
    {
        int pos=SDBMHash(name)%bucket_number;
        SymbolInfo *current=container[pos];
        SymbolInfo *prev=NULL;
        while(current!=NULL && current->get_name()!=name)
        {

            prev=current;
            current=current->get_next();
        }
        if(current==NULL)
        {
            //output<<"\tNot found in the current ScopeTable# "<<scope_id<<endl;
            return false;
        }
        if (prev != NULL)
        {
            prev->set_next(current->get_next());
        }
        else
        {
            container[pos] = current->get_next();
        }
        int p=current->get_position();
        SymbolInfo *temp=current->get_next();
        while(temp!=NULL)
        {

           temp->set_position(temp->get_position()-1);
           temp=temp->get_next();

        }
        delete current;
       // output<<"\tDeleted '"<<name<<"' from position <"<<pos+1<<", "<<p<<"> of ScopeTable# "<<scope_id<<endl;
        return true;

    }


};

#include "variable.hpp"
#include "function.hpp"

class SymbolTable
{

private:
    ScopeTable *current_scope;


public:
    SymbolTable(int n)
    {
        current_scope=new ScopeTable(n,NULL);
        current_scope->set_fixed_indentation(0);

    }

    ~SymbolTable()
    {
        while (current_scope != NULL)
        {
            ScopeTable* temp = current_scope;
            int id=current_scope->get_scope_id();
            current_scope= current_scope->get_parent_scope();
           //// output<<"\tScopeTable# "<<id<<" deleted"<<endl;
            delete temp;
        }
    }
    void Enter_Scope()
    {
        ScopeTable *new_scope_table=new ScopeTable(current_scope->get_bucket_number(),current_scope);
        current_scope=new_scope_table;
        current_scope->set_fixed_indentation(current_scope->get_parent_scope()->get_fixed_indentation()+1);
    }

    void Exit_Scope()
    {
        if (current_scope->get_parent_scope() != NULL)
        {
            ScopeTable* temp = current_scope;
            int id=temp->get_scope_id();
            current_scope = current_scope->get_parent_scope();
            current_scope->set_count_deleted_scope(current_scope->get_count_deleted_scope()+1);
            delete temp;
          //  output<<"\tScopeTable# "<<id<<" deleted"<<endl;
            //current_scope->set_fixed_indentation(current_scope->get_parent_scope()->get_fixed_indentation()+1);

        }
        else
        {
          //  output<<"\tScopeTable# 1 cannot be deleted"<<endl;
        }
    }
    bool Insert_Symbol(SymbolInfo *symbolinfo)
    {

        if(current_scope!=NULL)
        {

            return current_scope->Insert(symbolinfo);
        }
        return false;

    }
    bool Remove_Symbol(string name)
    {
        if(current_scope!=NULL)
        {
            return current_scope->Delete(name);
        }

    }
    SymbolInfo* Lookup_Symbol(string name)
    {
        for (ScopeTable *scopetable= current_scope; scopetable != NULL; scopetable = scopetable->get_parent_scope())
        {
            SymbolInfo *symbolinfo = scopetable->Lookup(name);
            if (symbolinfo != NULL)
            {
                return symbolinfo;
            }
        }
       // output<<"\t'"<<name<<"' not found in any of the ScopeTables"<<endl;
        return NULL;
    }
    ScopeTable* get_current_scope()
    {
        return current_scope;
    }
    void set_stack_offset(int n)
    {
        current_scope->stack_offset=n;
    }
    int get_stack_offset()
    {
        return current_scope->stack_offset;
    }
    int get_current_scope_id()
    {
        return current_scope->get_scope_id();
    }
   



//     void Print_all_scopetable(FILE *out) {
//     ScopeTable *curr = current_scope;
//     int count=0;
//     while (curr != NULL) {
//         fprintf(out, "\tScopeTable# %d\n", curr->get_scope_id());

//         for (int i = 0; i < curr->get_bucket_number(); i++) {
//             SymbolInfo **con = curr->get_container();
//             SymbolInfo *current = con[i];
//             if (current != NULL) {
//                 fprintf(out, "\t%d", i + 1);
//                 while (current != NULL) {
//                     if(current->get_type()=="function")
//                     {
//                         Function *function=(Function*)current;
//                         fprintf(out, " <%s,FUNCTION,%s>", current->get_name().c_str(), function->get_return_function().c_str());
//                     }
//                     else if(current->get_type()=="variable")
//                     {
//                         Variable *variable=(Variable*)current;
//                          if(variable->get_array_size()<=0)
//                          {
//                              fprintf(out, " <%s,%s>", current->get_name().c_str(), variable->get_data_type().c_str());
//                          }
//                          else{
//                              fprintf(out, " <%s,ARRAY>", current->get_name().c_str());
//                          }
                        
//                     }
//                     else{
//                         fprintf(out, " <%s,%s>", current->get_name().c_str(), current->get_type().c_str());
//                     }
                    
//                     current = current->get_next();
//                 }
//                 fprintf(out, "\n");
//             } 
          
//         }
//         curr = curr->get_parent_scope();
//     }
// }

void Print_all_scopetable(FILE *out) {
    ScopeTable *curr = current_scope;
    int count = 0;
    while (curr != NULL) {
        fprintf(out, "\tScopeTable# %d\n", curr->get_scope_id());

        for (int i = 0; i < curr->get_bucket_number(); i++) {
            SymbolInfo **con = curr->get_container();
            SymbolInfo *current = con[i];
            if (current != NULL) {
                fprintf(out, "\t%d", i + 1);
                bool firstEntry = true;
                while (current != NULL) {
                    if (firstEntry) {
                        fprintf(out, "--> ");
                        firstEntry = false;
                    } else {
                        fprintf(out, " ");
                    }

                    if (current->get_type() == "function") {
                        Function *function = (Function *)current;
                        fprintf(out, "<%s,FUNCTION,%s>", current->get_name().c_str(), function->get_return_function().c_str());
                    } else if (current->get_type() == "variable") {
                        Variable *variable = (Variable *)current;
                        if (variable->get_array_size() <= 0) {
                            fprintf(out, "<%s,%s>", current->get_name().c_str(), variable->get_data_type().c_str());
                        } else {
                            fprintf(out, "<%s,ARRAY>", current->get_name().c_str());
                        }
                    } else {
                        fprintf(out, "<%s,%s>", current->get_name().c_str(), current->get_type().c_str());
                    }

                    current = current->get_next();
                }
                fprintf(out, " \n");
            }
        }
        curr = curr->get_parent_scope();
    }
}


    void Print_current_scopetable()
    {
      //  output<<"\t\tScopeTable# "<<current_scope->get_scope_id()<<endl;

        for(int i=0; i<current_scope->get_bucket_number(); i++)
        {
            SymbolInfo **con=current_scope->get_container();
            SymbolInfo *current=con[i];
            if(current!=NULL)
            {
              //  output<<"\t\t"<<i+1;
                while(current!=NULL)
                {
                  //  output<<" --> ("<<current->get_name()<<","<<current->get_type()<<")";
                    current=current->get_next();
                }
               // output<<endl;
            }
            else
            {
               // output<<"\t\t"<<i+1<<endl;
            }
        }

    }





};
#endif

