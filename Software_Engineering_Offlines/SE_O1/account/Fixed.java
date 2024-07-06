package account;

import Bank.Bank;
import bank_work.Bank_Work;

import java.util.ArrayList;

public class Fixed extends Account implements Bank_Work {

    private double max_loan=100000;
    private double interest_rate=15;
    static {
        setInterest_rate(15);
    }

    public Fixed(String ac_name, String ac_type, Double in_dep) {
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

        if(this.getIn_dep()<withdraw_amount)
        {
            System.out.println("Invalid transaction; current balance "+this.getIn_dep()+"$");
        }
        if(b.getClock()==0)
        {
            System.out.println("Invalid transaction; current balance "+this.getIn_dep()+"$");
        }
        else{
            this.setIn_dep(this.getIn_dep()-withdraw_amount);
            b.setInitial_fund(b.getInitial_fund()-withdraw_amount);
            System.out.println("Remaining balance: "+this.getIn_dep());
        }
    }

    @Override
    public void deposit(double deposit_am) {
        if(deposit_am<50000)
        {
            System.out.println("Deposited money must be atleast: 50,000$");
        }
        else{
            this.setIn_dep(this.getIn_dep()+deposit_am);
            System.out.println(deposit_am+"$ deposited; current balance:" + this.getIn_dep()+"$");
        }
    }
}