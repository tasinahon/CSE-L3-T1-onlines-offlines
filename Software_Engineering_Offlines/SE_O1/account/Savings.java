package account;

import Bank.Bank;
import bank_work.Bank_Work;

import java.util.ArrayList;

public class Savings extends Account implements Bank_Work {
    private double max_loan=10000;
    static {
        setInterest_rate(10);
    }

    public Savings(String ac_name, String ac_type, Double in_dep) {
        super(ac_name, ac_type, in_dep);
    }

    public double getMax_loan() {
        return max_loan;
    }



    @Override
    public void loan_request(double loan, ArrayList<Account> Loan_list) {
        if(this.getMax_loan()<loan)
        {
            System.out.println("Higher than maximum allowable loan");
            return;
        }
        else{
            System.out.println("Loan request successful, sent for approval");
            this.setLoan_amount(loan);
            Loan_list.add(this);

        }
    }

    @Override
    public void withdraw_money(double withdraw_amount, Bank b) {
        if(withdraw_amount>this.getIn_dep())
        {
            System.out.println("Invalid transaction; current balance "+this.getIn_dep()+"$");
        }
        Double d=this.getIn_dep()-withdraw_amount;

        if(d<1000)
        {
            System.out.println("Invalid transaction; current balance "+this.getIn_dep()+"$");
        }
        else{
            this.setIn_dep(d);
            b.setInitial_fund(b.getInitial_fund()-withdraw_amount);
            System.out.println("Remaining balance: "+this.getIn_dep());
        }


    }

    @Override
    public void deposit(double deposit_am) {
        this.setIn_dep(this.getIn_dep()+deposit_am);
        System.out.println(deposit_am+"$ deposited; current balance:" + this.getIn_dep()+"$");
    }
}
