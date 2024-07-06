import java.io.IOException;
import java.net.Socket;
import java.util.HashMap;

public class ThreadCreator implements Runnable{
    SocketWrapper socketWrapper;
    Administrator administrator;

    HashMap<String,User>userObject;
    int count;
    Thread t;
    ThreadCreator(SocketWrapper socketWrapper, Administrator administrator, HashMap<String,User>userObject)
    {
        this.socketWrapper=socketWrapper;
        this.administrator=administrator;
        this.userObject=userObject;
        t=new Thread(this);
        t.start();
    }
    @Override
    public void run() {
        User user=null;
        try {
            String clientName=null;
            socketWrapper.write("Enter your name:");
            Object a = socketWrapper.read();
            clientName=(String) a;
            user=new User();
            user.setUserName(clientName);
            user.login=true;
            String socketinfo="Stock List:\n";
            for(int i=0;i<administrator.getStockArrayList().size();i++)
            {
                Stock stock=administrator.getStockArrayList().get(i);
                socketinfo=socketinfo+stock.getStock_name()+" "+stock.getStock_price()+" "+stock.getStock_count()+"\n";

            }
            socketWrapper.write(socketinfo);
            if(!administrator.getUserMap().containsKey(clientName))
            {

                administrator.getUserMap().put(clientName,socketWrapper);
                userObject.put(clientName,user);
            }
            else{
                administrator.getUserMap().put(clientName,socketWrapper);
                User user1=userObject.get(clientName);
                for(int i=0;i<user1.getNotificationList().size();i++)
                {
                    String notificationMessage =user1.getNotificationList().get(i);
                    socketWrapper.write(notificationMessage);
                }
                user1.getNotificationList().clear();


            }


            while (true)
            {
                Object o = socketWrapper.read();
                if (o instanceof Data) {

                    Data obj = (Data) o;
                    String out[]=obj.getCommand().split(" ");



                    if(!out[0].equals("V"))
                    {

                        Stock stock=null;
                        for(int i=0;i<administrator.getStockArrayList().size();i++)
                        {
                            if(administrator.getStockArrayList().get(i).getStock_name().equals(out[1]))
                            {
                                stock=administrator.getStockArrayList().get(i);
                            }
                        }
                        if(out[0].equals("S"))
                        {

                            stock.addUser(user);
                        }
                        else if (out[0].equals("U"))
                        {
                            stock.removeUser(user);
                        }
                    }

                    else
                    {
                        boolean f=false;
                       for(int i=0;i<administrator.getStockArrayList().size();i++)
                       {
                           Stock s=administrator.getStockArrayList().get(i);
                           for(int j=0;j<s.getObserverArrayList().size();j++)
                           {
                               if(s.getObserverArrayList().get(j).getUserName().equals(clientName))
                               {
                                   socketWrapper.write("Stock: "+s.getStock_name()+"\n"+
                                           "Stock Price: "+s.getStock_price()+"\n"+
                                           "Stock Count: "+s.getStock_count());
                                   f=true;
                               }
                           }

                       }
                       if(!f)
                       {
                           socketWrapper.write("No subscribed stock");
                       }
                    }
                }

            }
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            user.login=false;
            try {
                socketWrapper.closeConnection();
            } catch (IOException e) {
                System.out.println(e);
            }
        }

    }
}
