package employee_work;

import account.Account;

import java.util.ArrayList;

public interface Approve_Loan {
    default void loan_approval(ArrayList<Account> loan_list, ArrayList<Account>ac_list)
    {
        for(int i=0;i<loan_list.size();i++)
        {
            System.out.println("Loan for "+loan_list.get(i).getAc_name()+" approved" );
            loan_list.get(i).setIn_dep(loan_list.get(i).getIn_dep()+loan_list.get(i).getLoan_amount());
            loan_list.get(i).setLoan_approval(true);
            loan_list.remove(i);

        }

    }
}
