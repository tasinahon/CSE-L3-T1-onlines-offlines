package employee;

import Bank.Bank;
import account.Fixed;
import account.Savings;
import account.Student;
import employee_work.Approve_Loan;
import employee_work.Change_Interest_Rate;
import employee_work.Lookup;
import employee_work.See_Internal_Fund;

public class ManagingDirector extends Employee implements Lookup, Approve_Loan, Change_Interest_Rate, See_Internal_Fund {

    public ManagingDirector(String designation) {
        super(designation);
    }

    @Override
    public void changerate(String account_type,double new_rate) {

        if(account_type.equals("Savings"))
        {
            Savings.setInterest_rate(new_rate);
            System.out.println("New interest rate for Savings "+new_rate);
        }
        else if(account_type.equals("Student"))
        {
            Student.setInterest_rate(new_rate);
            System.out.println("New interest rate for Student "+new_rate);
        }
        else{
            Fixed.setInterest_rate(new_rate);
            System.out.println("New interest rate for Fixed "+new_rate);
        }

    }

    @Override
    public void internalfund(Bank b) {
        System.out.println("Internal fund of the bank: "+b.getInitial_fund()+"$");

    }
}
