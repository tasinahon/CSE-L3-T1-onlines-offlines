import java.io.IOException;
import java.util.Scanner;

public class AdministratorThread implements Runnable{
    Thread t;
    Administrator administrator;
    public AdministratorThread(Administrator administrator)
    {
        this.administrator=administrator;
        t=new Thread(this);
        t.start();
    }

    @Override
    public void run() {
        while (true)
        {
            Scanner scanner=new Scanner(System.in);
            String s=scanner.nextLine();
            String out[]=s.split(" ");
            Stock stock=null;
            for(int i=0;i<administrator.getStockArrayList().size();i++)
            {
                if(administrator.getStockArrayList().get(i).getStock_name().equals(out[1]))
                {
                    stock=administrator.getStockArrayList().get(i);
                }
            }
            if(out[0].equals("I"))
            {

                try {
                    administrator.increasePrice(stock,Double.parseDouble(out[2]));
                } catch (IOException e) {
                    System.out.println(e);
                }
            }
            else if (out[0].equals("D")) {
                try {
                    administrator.decreasePrice(stock,Double.parseDouble(out[2]));
                } catch (IOException e) {
                    System.out.println(e);
                }

            }
            else{
                try {
                    administrator.changeCount(stock,Integer.parseInt(out[2]));
                } catch (IOException e) {
                    System.out.println(e);
                }
            }
        }

    }
}
