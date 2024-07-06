package account;

public class Account {
    private String ac_name;
    private String ac_type;
    private Double in_dep;
    private static double interest_rate;
    private double loan_amount;
    private boolean loan_approval;

    public boolean isLoan_approval() {
        return loan_approval;
    }

    public void setLoan_approval(boolean loan_approval) {
        this.loan_approval = loan_approval;
    }

    public double getLoan_amount() {
        return loan_amount;
    }

    public void setLoan_amount(double loan_amount) {
        this.loan_amount = loan_amount;
    }

    public static double getInterest_rate() {
        return interest_rate;
    }

    public static void setInterest_rate(double interest_rate) {
        Account.interest_rate = interest_rate;
    }

    public Account(String ac_name, String ac_type, Double in_dep) {
        this.ac_name = ac_name;
        this.ac_type = ac_type;
        this.in_dep = in_dep;
        this.loan_approval = false;

    }

    public String getAc_name() {
        return ac_name;
    }



    public String getAc_type() {
        return ac_type;
    }




    public Double getIn_dep() {
        return in_dep;
    }

    public void setIn_dep(Double in_dep) {
        this.in_dep = in_dep;
    }



}
