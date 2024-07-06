import java.util.Scanner;

public class Client {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Rootdrive root_drive=new Rootdrive("root");
        Component currentDirectory = root_drive;

        while (true) {

            String userInput = scanner.nextLine();

            String[] split = userInput.split(" ");
            String first = split[0].toLowerCase();


             if (first.equals("cd")) {
                  if(split[1].equals("~"))
                  {
                      currentDirectory=root_drive;
                  }
                  else {

                      Component receive = currentDirectory.changeDirectory(split[1]);
                      if (receive == null) {
                          System.out.println("Can't change the directory");

                      }
                      else{
                          currentDirectory=receive;
                      }
                  }

             }
             else if (first.equals("mkdir"))
             {

                 currentDirectory.makeDir(split[1]);
             }
             else if(first.equals("list"))
             {

                currentDirectory.listing();
             }
             else if(first.equals("touch"))
             {

                 currentDirectory.touch(split[1],Double.parseDouble(split[2]));

             }
            else if(first.equals("mkdrive"))
             {

                    currentDirectory.makeDrive(split[1]);

             }
            else if(first.equals("delete"))
             {
                 if(split[1].equals("-r"))
                 {
                     currentDirectory.deleterecursively(split[2]);
                 }
                 else{
                     currentDirectory.delete(split[1]);
                 }

             }
            else if(first.equals("ls"))
             {
                 currentDirectory.detail(split[1]);
             }

        }

    }
}
