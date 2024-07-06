import java.util.Scanner;

public class Main {
    public static void main(String[] args) {

        Scanner scanner=new Scanner(System.in);
      while (true) {
          String userInput = scanner.nextLine();

          String[] split = userInput.split(" ");
          if (split[0].equals("login")) {
              String substr = split[1].substring(0, 3);
              if (substr.equals("cre")) {
                  Crewmate crewmate = new Crewmate();
                  crewmate.login();
                  while (true) {
                      String crewInput = scanner.nextLine();
                      if (crewInput.equals("logout")) {
                          crewmate.logout();
                          break;
                      } else if (crewInput.equals("repair")) {
                          crewmate.repair();
                      } else if (crewInput.equals("work")) {
                          crewmate.work();
                      }
                  }
              } else if (substr.equals("imp")) {
                  Working_function working_function = new Crewmate();
                  Imposterdecorator imposterdecorator = new Imposterdecorator(working_function);

                  imposterdecorator.login();
                  while (true) {
                      String crewInput = scanner.nextLine();
                      if (crewInput.equals("logout")) {
                          imposterdecorator.logout();
                          break;
                      } else if (crewInput.equals("repair")) {
                          imposterdecorator.repair();
                      } else if (crewInput.equals("work")) {
                          imposterdecorator.work();
                      }
                  }

              }
          }

      }
    }
}
