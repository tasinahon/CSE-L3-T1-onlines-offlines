import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class Stock {
    private String stock_name;
    private double stock_price;
    private int stock_count;

    private ArrayList<User>UserArrayList;


    public Stock(String stock_name,int stock_count,double stock_price)
    {
        this.stock_name=stock_name;
        this.stock_count=stock_count;
        this.stock_price=stock_price;
        this.UserArrayList=new ArrayList<>();
    }

    public String getStock_name() {
        return stock_name;
    }

    public double getStock_price() {
        return stock_price;
    }

    public void setStock_price(double stock_price) {
        this.stock_price = stock_price;
    }

    public int getStock_count() {
        return stock_count;
    }

    public void setStock_count(int stock_count) {
        this.stock_count = stock_count;
    }

    public ArrayList<User> getObserverArrayList() {
        return UserArrayList;
    }

    public void addUser(User user) {
        this.UserArrayList.add(user);
    }


    public void removeUser(User user) {
         this.UserArrayList.remove(user);
    }

    public void notifyUser(HashMap<String, SocketWrapper>userMap,String notification) throws IOException {

          for(int i=0;i<this.UserArrayList.size();i++)
          {
              String userName = this.UserArrayList.get(i).getUserName();

              if (userMap.containsKey(userName)) {

                  SocketWrapper userSocketWrapper = userMap.get(userName);
                  if(userSocketWrapper != null && this.UserArrayList.get(i).login)
                  {

                      userSocketWrapper.write("Your subscribed stock " + this.stock_name+" 's state has been changed");


                  }
                  if(!this.UserArrayList.get(i).login)
                  {

                      this.UserArrayList.get(i).update(notification);
                  }



              }

          }
    }
}
