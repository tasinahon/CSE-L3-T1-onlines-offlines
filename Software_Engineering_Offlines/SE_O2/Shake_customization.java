import java.util.Scanner;

public class Shake_customization {

    public static Shakes customize(Shakes shake, Scanner scanner,Order order) {
        System.out.println("Do you want to customize your order?");
        System.out.println("If yes press 'y' else press 'n'");
        String yesno=scanner.next();
        if(yesno.equalsIgnoreCase("n"))
        {
            return shake;
        }
        Customization_builder customization_builder=new Customization_builder(shake);

        boolean choice = true;
        System.out.println("Select additional customization for the shake.");
        System.out.println("If you want to add multiple items,put the item numbers serially" );
        System.out.println("one by one.After finishing press 4 to exit the customization");
        System.out.println("1. Almond milk Tk 60");
        System.out.println("2. Candy Tk 50");
        System.out.println("3. Cookies Tk 40");
        System.out.println("4. Done");
        while (choice) {
            String option = scanner.next();
            if(option.equalsIgnoreCase("1"))
            {
                customization_builder.lactose_free();
            }
            else if (option.equalsIgnoreCase("2")) {
                customization_builder.candy_add();
            }
            else if(option.equalsIgnoreCase("3"))
            {
                customization_builder.cookies_add();
            } else if (option.equalsIgnoreCase("o")) {
                System.out.println("Already an order is opened");
                Order.moreOrder(order,scanner);

            } else{
                choice=false;
                break;
            }


        }
        return customization_builder.build();
    }
}

