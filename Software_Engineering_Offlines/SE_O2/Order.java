import java.util.ArrayList;
import java.util.Scanner;

public class Order {
    private ArrayList<Shakes> shakes_list;

    public Order() {
        shakes_list = new ArrayList<>();
    }




    public void add_ordered_shake(Shakes shake) {
        shakes_list.add(shake);
    }

    public ArrayList<Shakes> get_ordered_shake() {
        return shakes_list;
    }

    public void print_order_details()
    {
        double total_price=0;
        System.out.println("Your order details:");
        for(int i=0;i<shakes_list.size();i++)
        {
            System.out.println(i+1+". "+shakes_list.get(i).getName());
            ArrayList<String>main=shakes_list.get(i).getIngredients();
            System.out.println("Base ingredients:");
            for(int j=0;j<main.size();j++)
            {
                System.out.print(main.get(j)+",");
            }
            System.out.println();
            ArrayList<String>added=shakes_list.get(i).getCustomized_item_list();
            if(!added.isEmpty())
            {
                System.out.println("Extra added ingredients:");
                for(int k=0;k<added.size();k++)
                {
                    System.out.print(added.get(k)+",");
                }
                System.out.println();
                for(int m=0;m<added.size();m++)
                {
                    if(added.get(m).equalsIgnoreCase("candy"))
                    {
                        System.out.println("For candy add,extra money:Tk 50");
                    }
                    else if (added.get(m).equalsIgnoreCase("cookies")) {
                        System.out.println("For cookies add,extra money: Tk 40");
                    }
                    else{
                        System.out.println("For almond milk(lactose free) add,extra money: Tk 60");
                    }
                }
            }
            System.out.println();
            total_price+=shakes_list.get(i).getPrice();
        }
        System.out.println("Total price: "+total_price);
    }
    public static void moreOrder(Order order, Scanner scanner)
    {
        while(true) {
            Director director = new Director();
            System.out.println("Please order,here is the menu:");
            System.out.println("Select a shake to add :-");
            System.out.println("1. Chocolate Tk 230");
            System.out.println("2. Coffee Tk 250");
            System.out.println("3. Strawberry Tk 200");
            System.out.println("4. Vanilla Tk 190");
            System.out.println("5. Zero Tk 240");
            System.out.println("6. Press 'e' for closing the order");
            String option = scanner.next();
            if (option.equalsIgnoreCase("1")) {
                Chocolate_shake_builder chocolate_shake_builder = new Chocolate_shake_builder();
                Shakes shake = director.construct(chocolate_shake_builder);
                Shakes shakes = Shake_customization.customize(shake, scanner,order);
                order.add_ordered_shake(shakes);


            } else if (option.equalsIgnoreCase("2")) {
                Coffee_shake_builder coffee_shake_builder = new Coffee_shake_builder();
                Shakes shake = director.construct(coffee_shake_builder);
                Shakes shakes = Shake_customization.customize(shake, scanner,order);
                order.add_ordered_shake(shakes);


            } else if (option.equalsIgnoreCase("3")) {
                Strawberry_shake_builder strawberry_shake_builder = new Strawberry_shake_builder();
                Shakes shake = director.construct(strawberry_shake_builder);
                Shakes shakes = Shake_customization.customize(shake, scanner,order);
                order.add_ordered_shake(shakes);

            } else if (option.equalsIgnoreCase("4")) {
                Vanilla_shake_builder vanilla_shake_builder = new Vanilla_shake_builder();
                Shakes shake = director.construct(vanilla_shake_builder);
                Shakes shakes = Shake_customization.customize(shake, scanner,order);
                order.add_ordered_shake(shakes);

            } else if (option.equalsIgnoreCase("5")) {
                Zero_shake_builder zero_shake_builder = new Zero_shake_builder();
                Shakes shake = director.construct(zero_shake_builder);
                Shakes shakes = Shake_customization.customize(shake, scanner,order);
                order.add_ordered_shake(shakes);

            } else if (option.equalsIgnoreCase("o")) {
                System.out.println("Already an order is opened");
                System.out.println("Do you want to add something in the current order?");
                System.out.println("If yes press 'y' else press 'n'");
                String yesno = scanner.next();
                if (yesno.equalsIgnoreCase("y")) {
                    Order.moreOrder(order, scanner);
                } else {
                    if (order.get_ordered_shake().isEmpty()) {
                        System.out.println("At least one item must be added before closing an order");
                        Order.moreOrder(order, scanner);
                    }
                }
            }
            if(option.equalsIgnoreCase("e"))
            {
                if (order == null || order.get_ordered_shake().isEmpty()) {
                    System.out.println("At least one item must be added before closing an order");
                    Order.moreOrder(order,scanner);

                }
                else{

                    order.print_order_details();
                    order=null;
                    break;
                }
            }

        }

    }


}
