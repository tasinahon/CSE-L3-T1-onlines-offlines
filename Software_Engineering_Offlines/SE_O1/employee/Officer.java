package employee;

import employee_work.Approve_Loan;
import employee_work.Lookup;

public class Officer extends Employee implements Lookup, Approve_Loan {

    public Officer(String designation) {
        super(designation);
    }
}
