#include "Parse_tree_eachnode.hpp"
#include<bits/stdc++.h>

using namespace std;

    vector<SymbolInfo*> Parse_tree_eachnode::globalVariable;

    Parse_tree_eachnode::Parse_tree_eachnode()
    {
        this->start=0;
        this->ends=0;
        this->child = nullptr;
        this->child_no = 0;
        this->Production_rule="";
        this->isCond=false;
        this->lEnd="";
        this->lTrue="";
        this->lFalse="";
        this->is_Global=false;
        this->symbol.addVarDeclNode(nullptr, -1);
    }




    void Parse_tree_eachnode::add_child(Parse_tree_eachnode *child)
    {

        Parse_tree_eachnode **container = new Parse_tree_eachnode *[this->child_no + 1];


        for (int i = 0; i < this->child_no; ++i)
        {
            container[i] = this->child[i];
        }

        container[this->child_no] = child;


        delete[] this->child;

        this->child = container;
        this->child_no += 1;
    }

    Parse_tree_eachnode::~Parse_tree_eachnode()
    {

        delete[] this->child;
    }
    void Parse_tree_eachnode::set_parse_data(string data)
    {
        this->parse_data=data;
    }

    void Parse_tree_eachnode::set_child(Parse_tree_eachnode **child, int child_no)
    {

        delete[] this->child;

        this->child = child;
        this->child_no = child_no;
    }
    void Parse_tree_eachnode::set_start(int start)
    {

        this->start=start;
    }
    void Parse_tree_eachnode::set_ends(int ends)
    {
        this->ends=ends;
    }
    void Parse_tree_eachnode::Production(string p_rule)
    {
        this->Production_rule=p_rule;
    }
    int Parse_tree_eachnode::get_start()
    {
        return start;
    }
    int Parse_tree_eachnode::get_ends()
    {
        return ends;
    }
    string Parse_tree_eachnode::get_productionrule()
    {
        return Production_rule;
    }
    string Parse_tree_eachnode::get_parse_data()
    {
        return parse_data;
    }
    Parse_tree_eachnode** Parse_tree_eachnode::get_child()
    {

        return this->child;
    }
    void Parse_tree_eachnode::setSymbol(VarDeclList s)
    {
        this->symbol=s;
    }
    VarDeclList Parse_tree_eachnode::getSymbol()
    {
        return symbol;
    }
    void Parse_tree_eachnode::set_parameterlist(vector<SymbolInfo*>s)
    {
        this->parameterlist=s;
    }

    void Parse_tree_eachnode::add_parameter(SymbolInfo* s)
    {
        this->parameterlist.push_back(s);
    }

void Parse_tree_eachnode::print_parsetree(FILE *out, Parse_tree_eachnode *main, int level)
{
    if (main == nullptr)
    {
        return;
    }

    for (int i = 0; i < level; i++)
    {
        fprintf(out, " ");
    }

    
    if (main->get_ends() != 0)
    {
        fprintf(out, "%s \t<Line: %d-%d>\n",
                main->get_productionrule().c_str(), main->get_start(), main->get_ends());
    }
    else
    {
        fprintf(out, "%s\t<Line: %d>\n",
                main->get_productionrule().c_str(), main->get_start());
    }

    for (int i = 0; i < main->child_no; ++i)
    {
        print_parsetree(out, main->child[i], level + 1);
    }
}











