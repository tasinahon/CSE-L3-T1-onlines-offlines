package bank_work;

import Bank.Bank;
import account.Account;

import java.util.ArrayList;

public interface Bank_Work {
    void loan_request(double loan, ArrayList<Account> Loan_list);
    void withdraw_money(double withdraw_amount, Bank b);
    void deposit(double deposit_am);
}
