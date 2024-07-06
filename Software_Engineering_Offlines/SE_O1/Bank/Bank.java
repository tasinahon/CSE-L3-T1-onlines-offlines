package Bank;


import account.Account;
import account.Fixed;
import account.Savings;
import account.Student;
import employee.Cashier;
import employee.Employee;
import employee.ManagingDirector;
import employee.Officer;
import employee_work.Approve_Loan;
import employee_work.Change_Interest_Rate;
import employee_work.Lookup;
import employee_work.See_Internal_Fund;

import java.util.ArrayList;
import java.util.Scanner;

public class Bank {
    private ArrayList<Account>Ac_list;

    public ArrayList<Account> getLoan_list() {
        return Loan_list;
    }

    private ArrayList<Employee>Em_list;
    private ArrayList<Account>Loan_list;
    private double initial_fund;
    private int clock;
    Bank()
    {
        this.Ac_list=new ArrayList<>();
        this.Em_list=new ArrayList<>();
        this.Loan_list=new ArrayList<>();
        this.initial_fund=1000000;
        this.clock=0;
        ManagingDirector md = new ManagingDirector("MD");
        Officer o1 = new Officer("S1");
        Officer o2 = new Officer("S2");
        Cashier c1 = new Cashier("C1");
        Cashier c2 = new Cashier("C2");
        Cashier c3 = new Cashier("C3");
        Cashier c4 = new Cashier("C4");
        Cashier c5 = new Cashier("C5");
        Em_list.add(md);
        Em_list.add(o1);
        Em_list.add(o2);
        Em_list.add(c1);
        Em_list.add(c2);
        Em_list.add(c3);
        Em_list.add(c4);
        Em_list.add(c5);
        System.out.println("Bank Created; MD, S1, S2, C1, C2, C3, C4, C5 created");
    }

    public double getInitial_fund() {
        return initial_fund;
    }

    public void setInitial_fund(double initial_fund) {
        this.initial_fund = initial_fund;
    }

    public int getClock() {
        return clock;
    }

    public void setClock(int clock) {
        this.clock = clock;
    }
    public  void Create_Account(String []out)
    {
        for(int i=0;i< this.Ac_list.size();i++)
        {
            if(this.Ac_list.get(i).getAc_name().equals(out[1]))
            {
                System.out.println("Sorry,already an account with this name exists");
                return;
            }
        }
        if(out[2].equals("Fixed"))
        {

            if(Double.valueOf(out[3])<100000)
            {
                System.out.println("Sorry,for fixed account initial deposit must be at least 100000$");
            }
            else{
                Double in_d=Double.valueOf(out[3]);
                this.Ac_list.add(new Fixed(out[1],out[2],in_d));
                System.out.println(out[2]+" " + "account for" + out[1]+ " Created ;"+ "initial balance"+ out[3]+"$");
            }
        }
        else if(out[2].equals("Savings")){
            Double in_d = Double.valueOf(out[3]);
            this.Ac_list.add(new Savings(out[1], out[2], in_d));
            System.out.println(out[2] + " " + "account for " + out[1] + " Created ;" + "initial balance: " + out[3] + "$");
        }
        else{
            Double in_d = Double.valueOf(out[3]);
            this.Ac_list.add(new Student(out[1], out[2], in_d));
            System.out.println(out[2] + " " + "account for " + out[1] + " Created ;" + "initial balance: " + out[3] + "$");
        }
    }
    public void Deposit(String account_holder,String []out)
    {
        for(int i=0;i< this.Ac_list.size();i++)
        {
            if(this.Ac_list.get(i).getAc_name().equals(account_holder) && !this.Ac_list.get(i).getAc_type().equals("Fixed"))
            {

                if(Ac_list.get(i) instanceof Student)
                {
                    ((Student)Ac_list.get(i)).deposit(Double.valueOf(out[1]));
                }
                else{
                    ((Savings)Ac_list.get(i)).deposit(Double.valueOf(out[1]));
                }

            }
            else if(this.Ac_list.get(i).getAc_name().equals(account_holder) && this.Ac_list.get(i) instanceof Fixed) {
                ((Fixed)Ac_list.get(i)).deposit(Double.valueOf(out[1]));
            }
        }
    }
    public void WIthdraw(String account_holder,String [] out)
    {
        for(int i=0;i<this.Ac_list.size();i++)
        {
            if(this.Ac_list.get(i).getAc_name().equals(account_holder) )
            {
                if(this.Ac_list.get(i) instanceof Fixed) {
                    Fixed fixed_ac = (Fixed) this.Ac_list.get(i);
                    if (this.getClock()==0) {
                        System.out.println("You can not withdraw money because 1 year is not passed");
                    }
                    else{
                        fixed_ac.withdraw_money(Double.valueOf(out[1]),this);


                    }
                }
                else if(this.Ac_list.get(i) instanceof Student)
                {
                    ((Student)this.Ac_list.get(i)).withdraw_money(Double.valueOf(out[1]),this);

                }
                else if(this.Ac_list.get(i) instanceof Savings)
                {
                    ((Savings)this.Ac_list.get(i)).withdraw_money(Double.valueOf(out[1]),this);

                }
            }
        }
    }

    public void RequestLoan(String account_holder,String []out)
    {
        for(int i=0;i<this.Ac_list.size();i++)
        {
            if(this.Ac_list.get(i).getAc_name().equals(account_holder))
            {
                if(this.Ac_list.get(i) instanceof Student)
                {
                    ((Student) this.Ac_list.get(i)).loan_request(Double.valueOf(out[1]),Loan_list);
                }
                else if(this.Ac_list.get(i) instanceof Fixed)
                {
                    ((Fixed) this.Ac_list.get(i)).loan_request(Double.valueOf(out[1]),Loan_list);
                }
                if(this.Ac_list.get(i) instanceof Savings)
                {
                    ((Savings) this.Ac_list.get(i)).loan_request(Double.valueOf(out[1]),Loan_list);
                }
            }
        }
    }
    public void Query(String account_holder)
    {
        for(int i=0;i<this.Ac_list.size();i++)
        {
            if(this.Ac_list.get(i).getAc_name().equals(account_holder))
            {
                System.out.print("Current balance: "+this.Ac_list.get(i).getIn_dep()+"$,");
                if(this.Ac_list.get(i).isLoan_approval())
                {
                    System.out.println("loan "+Ac_list.get(i).getLoan_amount()+"$");
                }
                else{
                    System.out.println();
                }
            }

        }


    }
    public void LoanApprove(String employee)
    {
        for(int i=0;i<Em_list.size();i++)
        {
            if(Em_list.get(i).getDesignation().equals(employee))
            {
                if (Em_list.get(i) instanceof Approve_Loan) {

                    ((Approve_Loan) Em_list.get(i)).loan_approval(Loan_list,Ac_list);
                } else {
                    System.out.println("You don't have permission for this operations");
                }
            }
        }
    }
    public void Lookup(String employee,String account_holder)
    {
        Account account=null;
        for(int i=0;i<Ac_list.size();i++)
        {

            if(Ac_list.get(i).getAc_name().equals(account_holder))
            {
                account=Ac_list.get(i);
            }
        }
        for(int i=0;i<Em_list.size();i++)
        {
            if(Em_list.get(i).getDesignation().equals(employee))
            {
                ((Lookup)Em_list.get(i)).deposit_user_account(account);
            }
        }
    }
    public void ChangeRate(String []out,String employee)
    {
        Employee emp=null;
        for(int i=0;i<Em_list.size();i++)
        {
            if(Em_list.get(i).getDesignation().equals(employee))
            {
                emp=Em_list.get(i);
                break;
            }
        }
        if(emp instanceof ManagingDirector)
        {
            ((Change_Interest_Rate)emp).changerate(out[1],Double.valueOf(out[2]));

        }
        else{
            System.out.println("You don’t have permission for this operation");
        }
    }
    public void InternalFund(Bank b,String employee)
    {
        if(employee.equals("MD"))
        {
            for(int i=0;i<Em_list.size();i++)
            {
                if(Em_list.get(i).getDesignation().equals("MD"))
                {
                    ((See_Internal_Fund)Em_list.get(i)).internalfund(b);
                    break;
                }
            }
        }
        else{
            System.out.println("You don’t have permission for this operation");
        }
    }



    public void Year_adjustment()
    {
        for(int i=0;i<Ac_list.size();i++)
        {
            if(Ac_list.get(i) instanceof Savings)
            {
                double d=(((Savings) Ac_list.get(i)).getIn_dep()*Savings.getInterest_rate())/100;
                ((Savings)Ac_list.get(i)).setIn_dep(((Savings) Ac_list.get(i)).getIn_dep()+d);
            }
            else if(Ac_list.get(i) instanceof Student)
            {
                double d=(((Student) Ac_list.get(i)).getIn_dep()*Student.getInterest_rate())/100;
                ((Student)Ac_list.get(i)).setIn_dep(((Student) Ac_list.get(i)).getIn_dep()+d);
            }
            else{
                double d=(((Fixed) Ac_list.get(i)).getIn_dep()*Fixed.getInterest_rate())/100;
                ((Fixed)Ac_list.get(i)).setIn_dep(((Fixed) Ac_list.get(i)).getIn_dep()+d);
            }
        }

        for(int i=0;i<Ac_list.size();i++)
        {
            if(Ac_list.get(i).getLoan_amount()>0)
            {
                double d=(Ac_list.get(i).getLoan_amount()*10)/100;
                Ac_list.get(i).setIn_dep(Ac_list.get(i).getIn_dep()-d);
            }
        }
    }




    public static void main(String[] args) {
        Bank b=new Bank();
        String []emp={"MD","S1","S2","S3","S4","S5"};
        Scanner scanner=new Scanner(System.in);
        String account_holder=null;
        String employee=null;
        while(true) {
            String str = scanner.nextLine();
            String[] out = str.split(" ");

            if (out[0].equals("Create")) {
                account_holder=out[1];
                b.Create_Account(out);
            }
            if(out[0].equals("Deposit"))
            {
                b.Deposit(account_holder,out);
            }
            if(out[0].equals("Withdraw"))
            {
                b.WIthdraw(account_holder,out);
            }
            if(out[0].equals("Request"))
            {
                b.RequestLoan(account_holder,out);
            }
            if(out[0].equals("Query"))
            {
                b.Query(account_holder);
            }
            if(out[0].equals("Close"))
            {
                if(account_holder==null)
                {
                    System.out.println("Operations for "+employee+" closed");
                    employee=null;
                }
                else{
                    System.out.println("Transaction closed for "+account_holder);
                    account_holder=null;
                }

            }
            if(out[0].equals("Open") )
            {

                boolean f=false;
                for(String s:emp)
                {

                    if(s.equals(out[1]))
                    {
                        f=true;
                        break;
                    }
                }
                if(!f)
                {
                    account_holder=out[1];
                    System.out.println("Welcome back "+account_holder);
                }
                else{
                    employee=out[1];
                    System.out.print(employee+" Active ,");
                    if((out[1].equals("S1") || out[1].equals("S2") || out[1].equals("MD")) && b.getLoan_list().size()!=0)
                    {
                        System.out.println("there are loan approvals pending");
                    }
                }
            }
            if(out[0].equals("Approve"))
            {
                if(b.getLoan_list().size()==0)
                {
                    System.out.println("No current loan request");
                }
                else{
                    b.LoanApprove(employee);
                }

            }
            if (out[0].equals("Lookup"))
            {
                b.Lookup(employee, out[1]);
            }
            if(out[0].equals("Change"))
            {
                b.ChangeRate(out,employee);
            }
            if(out[0].equals("See"))
            {
                b.InternalFund(b,employee);
            }
            if(out[0].equals("INC"))
            {
                b.setClock(b.getClock()+1);
                b.Year_adjustment();
                System.out.println(b.getClock()+" year passed ");
            }

        }

    }
}
