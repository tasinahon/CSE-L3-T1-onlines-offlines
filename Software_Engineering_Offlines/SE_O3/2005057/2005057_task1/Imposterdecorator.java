public class Imposterdecorator implements Working_function{
    private Working_function crewmate;

    public Imposterdecorator(Working_function crewmate) {
        this.crewmate = crewmate;
    }

    @Override
    public void login() {
        crewmate.login();
        System.out.println("We won’t tell anyone; you are an imposter.");
    }

    @Override
    public void repair() {
        crewmate.repair();
        System.out.println("Damaging the spaceship.");
    }

    @Override
    public void work() {
        crewmate.work();
        System.out.println("Trying to kill a crewmate.");
        System.out.println("Successfully killed a crewmate.");
    }

    @Override
    public void logout() {
        crewmate.logout();
        System.out.println("See you again Comrade Imposter.");
    }
}
