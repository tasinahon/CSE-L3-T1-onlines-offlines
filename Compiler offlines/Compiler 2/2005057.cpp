#include<bits/stdc++.h>
using namespace std;
ofstream output("output.txt");
class SymbolInfo
{
private:
    string name;
    string type;
    SymbolInfo *next;
    int position;
public :
    SymbolInfo(string name,string type)
    {
        this->name=name;
        this->type=type;
        this->next=NULL;
    }
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

};


class ScopeTable
{

private:
    SymbolInfo **container;
    ScopeTable *parent_scope;
    int bucket_number;
    string scope_id;
    int count_deleted_scope;
    int fixed_indentation;

public:
    ScopeTable(int bucket_number,ScopeTable *parent_scope)
    {
        if (parent_scope == NULL)
        {
            scope_id = "1";
        }
        else
        {
            scope_id = parent_scope->get_scope_id() + "." + to_string(parent_scope->count_deleted_scope+1);
        }
        this->bucket_number=bucket_number;
        this->parent_scope=parent_scope;
        container=new SymbolInfo*[bucket_number+1];
        for(int i=0; i<bucket_number; i++)
        {

            container[i]=NULL;
        }
        this->count_deleted_scope=0;

        output<<"\tScopeTable# "<<scope_id<<" created"<<endl;


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
    void set_scope_id(string id)
    {
        this->scope_id=id;
    }
    string get_scope_id()
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
    bool Insert(SymbolInfo *symbolinfo, FILE *output) {
    int count = 1;
    int pos = SDBMHash(symbolinfo->get_name()) % bucket_number;
    SymbolInfo *current_node = container[pos];

    while (current_node != NULL) {
        if (current_node->get_name() == symbolinfo->get_name()) {
            fprintf(output, "\t%s already exists in the current ScopeTable\n",
                    symbolinfo->get_name().c_str());
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


    // bool Insert(SymbolInfo *symbolinfo,FILE *output)
    // {
    //     int count=1;
    //     int pos=SDBMHash(symbolinfo->get_name())%bucket_number;
    //     SymbolInfo *current_node=container[pos];
    //     while (current_node!= NULL)
    //     {
    //         if (current_node->get_name() == symbolinfo->get_name())
    //         {

                
    //             output<<"\t\t"<<symbolinfo->get_name()<<" "<<"already exists in the current ScopeTable# "<<scope_id<<endl;
    //             return false;
    //         }
    //         current_node = current_node->get_next();
    //     }
    //     if(container[pos]==NULL)
    //     {
    //         symbolinfo->set_position(count);
    //         container[pos]=symbolinfo;
    //         //output<<"\tInserted  at position <"<<pos+1<<", "<<symbolinfo->get_position()<<"> of ScopeTable# "<<scope_id<<endl;
    //     }
    //     else
    //     {


    //         current_node=container[pos];
    //         while(current_node->get_next()!=NULL)
    //         {
    //             current_node=current_node->get_next();
    //             count++;
    //             symbolinfo->set_position(count);
    //         }
    //         count++;
    //         symbolinfo->set_position(count);
    //         current_node->set_next(symbolinfo);
    //         //output<<"\tInserted  at position <"<<pos+1<<", "<<count<<"> of ScopeTable# "<<scope_id<<endl;
    //     }
    //     return true;
    // }
    SymbolInfo* Lookup(string name)
    {
        int pos=SDBMHash(name)%bucket_number;
        SymbolInfo *node=container[pos];
        while(node!=NULL)
        {
            if(node->get_name()==name)
            {
                output<<"\t'"<<name<<"' found at position <"<<pos+1<<", "<<node->get_position() <<"> of ScopeTable# "<<scope_id<<endl;
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
            output<<"\tNot found in the current ScopeTable# "<<scope_id<<endl;
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
        output<<"\tDeleted '"<<name<<"' from position <"<<pos+1<<", "<<p<<"> of ScopeTable# "<<scope_id<<endl;
        return true;

    }


};

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
            string id=current_scope->get_scope_id();
            current_scope= current_scope->get_parent_scope();
            output<<"\tScopeTable# "<<id<<" deleted"<<endl;
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
            string id=temp->get_scope_id();
            current_scope = current_scope->get_parent_scope();
            current_scope->set_count_deleted_scope(current_scope->get_count_deleted_scope()+1);
            delete temp;
            output<<"\tScopeTable# "<<id<<" deleted"<<endl;
            //current_scope->set_fixed_indentation(current_scope->get_parent_scope()->get_fixed_indentation()+1);

        }
        else
        {
            output<<"\tScopeTable# 1 cannot be deleted"<<endl;
        }
    }
    bool Insert_Symbol(SymbolInfo *symbolinfo,FILE *output)
    {

        if(current_scope!=NULL)
        {

            return current_scope->Insert(symbolinfo,output);
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
        output<<"\t'"<<name<<"' not found in any of the ScopeTables"<<endl;
        return NULL;
    }
    ScopeTable* get_current_scope()
    {
        return current_scope;
    }
    // void Print_all_scopetable(FILE *output)
    // {
        
    //     ScopeTable *curr=current_scope;
    //     while(curr!=NULL)
    //     {
    //         output<<"\tScopeTable# "<<curr->get_scope_id()<<endl;

    //         for(int i=0; i<curr->get_bucket_number(); i++)
    //         {
    //             SymbolInfo **con=curr->get_container();
    //             SymbolInfo *current=con[i];
    //             if(current!=NULL)
    //             {
    //                 output<<"\t"<<i+1;
    //                 while(current!=NULL)
    //                 {
    //                     output<<" --> ("<<current->get_name()<<","<<current->get_type()<<")";
    //                     current=current->get_next();
    //                 }
    //                 output<<endl;
    //             }
    //             else
    //             {
    //                 output<<"\t"<<i+1<<endl;
    //             }
    //         }
    //         curr=curr->get_parent_scope();
    //     }
    // }
    void Print_all_scopetable(FILE *output) {
    ScopeTable *curr = current_scope;
    while (curr != NULL) {
        fprintf(output, "\tScopeTable# %s\n", curr->get_scope_id().c_str());

        for (int i = 0; i < curr->get_bucket_number(); i++) {
            SymbolInfo **con = curr->get_container();
            SymbolInfo *current = con[i];
            if (current != NULL) {
                fprintf(output, "\t%d", i + 1);
                while (current != NULL) {
                    fprintf(output, " --> (%s,%s)", current->get_name().c_str(), current->get_type().c_str());
                    current = current->get_next();
                }
                fprintf(output, "\n");
            } else {
                fprintf(output, "\t%d\n", i + 1);
            }
        }
        curr = curr->get_parent_scope();
    }
}

    void Print_current_scopetable()
    {
        output<<"\t\tScopeTable# "<<current_scope->get_scope_id()<<endl;

        for(int i=0; i<current_scope->get_bucket_number(); i++)
        {
            SymbolInfo **con=current_scope->get_container();
            SymbolInfo *current=con[i];
            if(current!=NULL)
            {
                output<<"\t\t"<<i+1;
                while(current!=NULL)
                {
                    output<<" --> ("<<current->get_name()<<","<<current->get_type()<<")";
                    current=current->get_next();
                }
                output<<endl;
            }
            else
            {
                output<<"\t\t"<<i+1<<endl;
            }
        }

    }





};
// int main()
// {
//     ifstream input("input.txt");



//     int bucket_num;
//     string line;
//     input>> bucket_num;
//     getline(input,line);
//     SymbolTable symbol_table(bucket_num);

//     int command = 1;

//     while (getline(input, line))
//     {
//         output << "Cmd " << command << ": ";

//         istringstream s(line);
//         char a;
//         s >> a;



//         if (a == 'I')
//         {
//             string name,type;
//             if (!(s >> name >> type) || (s >> ws).peek() != EOF)
//             {
//                 output << line << endl;
//                 output << "\tWrong number of arguments for the command I" << endl;
//             }
//             else
//             {
//                 output << "I " << name << " " << type << endl;
//                 SymbolInfo *symbolinfo = new SymbolInfo(name, type);
//                 symbol_table.Insert_Symbol(symbolinfo);
//             }
//         }
//         else if (a == 'L')
//         {
//             string name;
//             if (!(s >> name) || (s >> ws).peek() != EOF)
//             {
//                 output << line << endl;
//                 output << "\tWrong number of arguments for the command L" << endl;
//             }
//             else
//             {
//                 output << "L " << name << endl;
//                 symbol_table.Lookup_Symbol(name);
//             }
//         }
//         else if (a == 'D')
//         {
//             string name;
//             if (!(s >> name) || (s >> ws).peek() != EOF)
//             {
//                 output << line << endl;
//                 output << "\tWrong number of arguments for the command D" << endl;
//             }
//             else
//             {
//                 output << "D " << name << endl;
//                 symbol_table.Remove_Symbol(name);
//             }
//         }
//         else if (a == 'P')
//         {
//             char a;
//             if (!(s >> a) || (s >> ws).peek() != EOF)
//             {
//                 output << line << endl;
//                 output << "\tWrong number of arguments for the command P" << endl;
//             }
//             else
//             {
//                 output << "P " << a << endl;
//                 if (a == 'A')
//                 {
//                     symbol_table.Print_all_scopetable();
//                 }
//                 else if (a == 'C')
//                 {
//                     symbol_table.Print_current_scopetable();
//                 }
//                 else
//                 {
//                     output << "\tInvalid argument for the command P" << endl;
//                 }
//             }
//         }
//         else if (a == 'S')
//         {
//             output << "S" << endl;
//             symbol_table.Enter_Scope();
//         }
//         else if (a == 'E')
//         {
//             output << "E" << endl;
//             symbol_table.Exit_Scope();
//         }
//         else if(a=='Q')
//         {
//             output<<"Q"<<endl;
//         }
//         else
//         {
//             output<<line;
//             output << "\tInvalid command." << endl;
//         }

//         command++;
//     }



//     return 0;
// }

