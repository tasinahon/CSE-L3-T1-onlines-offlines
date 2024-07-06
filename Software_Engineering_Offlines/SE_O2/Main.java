import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Order order = null;
        int count=0;



        while (true) {

            System.out.println("Press 'o' to open an order or 'e' to close an order:");
            char choice = scanner.next().charAt(0);

            if (choice == 'o') {
                if (order == null) {
                    order = new Order();
                    System.out.println("Here is the menu,Order please");
                } else {
                    System.out.println("An order is opened already.Please close it before a new order");
                }
            }



            if (order != null) {

                while (true){
                    if(count>0)
                    {
                        System.out.println("Do you want to add more shake?");
                        System.out.println("If yes then press 'y',if no press 'e'");
                        String yesno=scanner.next();
                        if(yesno.equalsIgnoreCase("e"))
                        {
                            order.print_order_details();
                            order=null;
                            count=0;
                            break;
                        }
                    }
                    System.out.println("Select a shake to add :-");
                    System.out.println("1. Chocolate Tk 230");
                    System.out.println("2. Coffee Tk 250");
                    System.out.println("3. Strawberry Tk 200");
                    System.out.println("4. Vanilla Tk 190");
                    System.out.println("5. Zero Tk 240");
                    System.out.println("6. Press 'e' for closing the order");
                    String option=scanner.next();
                    Director director=new Director();


                if(option.equalsIgnoreCase("e"))
                {
                    if (order == null || order.get_ordered_shake().isEmpty()) {
                        System.out.println("At least one item must be added before closing an order");
                        System.out.println("Please order,here is the menu:");
                        System.out.println("Select a shake to add :-");
                        System.out.println("1. Chocolate Tk 230");
                        System.out.println("2. Coffee Tk 250");
                        System.out.println("3. Strawberry Tk 200");
                        System.out.println("4. Vanilla Tk 190");
                        System.out.println("5. Zero Tk 240");
                        System.out.println("6. Press 'e' for closing the order");
                        option=scanner.next();

                    }
                    else{

                        order.print_order_details();
                        order=null;
                        break;
                    }
                }
                if(option.equalsIgnoreCase("1"))
                {
                    Chocolate_shake_builder chocolate_shake_builder=new Chocolate_shake_builder();
                    Shakes shake=director.construct(chocolate_shake_builder);
                    Shakes shakes=Shake_customization.customize(shake,scanner,order);
                    order.add_ordered_shake(shakes);
                    count++;

                }
                else if(option.equalsIgnoreCase("2"))
                {
                    Coffee_shake_builder coffee_shake_builder=new Coffee_shake_builder();
                    Shakes shake=director.construct(coffee_shake_builder);
                    Shakes shakes=Shake_customization.customize(shake,scanner,order);
                    order.add_ordered_shake(shakes);
                    count++;

                }
                else if(option.equalsIgnoreCase("3"))
                {
                     Strawberry_shake_builder strawberry_shake_builder=new Strawberry_shake_builder();
                     Shakes shake=director.construct(strawberry_shake_builder);
                     Shakes shakes=Shake_customization.customize(shake,scanner,order);
                     order.add_ordered_shake(shakes);
                     count++;
                }
                else if(option.equalsIgnoreCase("4"))
                {
                    Vanilla_shake_builder vanilla_shake_builder=new Vanilla_shake_builder();
                    Shakes shake=director.construct(vanilla_shake_builder);
                    Shakes shakes=Shake_customization.customize(shake,scanner,order);
                    order.add_ordered_shake(shakes);
                    count++;
                }
                else if(option.equalsIgnoreCase("5"))
                {
                    Zero_shake_builder zero_shake_builder=new Zero_shake_builder();
                    Shakes shake=director.construct(zero_shake_builder);
                    Shakes shakes=Shake_customization.customize(shake,scanner,order);
                    order.add_ordered_shake(shakes);
                    count++;
                }
                else if(option.equalsIgnoreCase("o"))
                {
                    System.out.println("Already an order is opened");
                    System.out.println("Do you want to add something in the current order?");
                    System.out.println("If yes press 'y' else press 'n'");
                    String yesno=scanner.next();
                    if(yesno.equalsIgnoreCase("y"))
                    {
                        Order.moreOrder(order,scanner);
                    }
                    else{
                        if(order.get_ordered_shake().isEmpty())
                        {
                            System.out.println("At least one item must be added before closing an order");
                            Order.moreOrder(order,scanner);
                        }
                        else{
                            order.print_order_details();
                            order=null;
                            count=0;
                            break;
                        }
                    }
                }


                else{
                    System.out.println("Invalid shake choice. Please select a valid shake.");
                }


            }
            }
        }
    }
}
