package employee_work;

import account.Account;

public interface Lookup {
    default void deposit_user_account(Account user_account){

        System.out.println(user_account.getAc_name()+"'s current balance "+user_account.getIn_dep()+"$");
    };
}
