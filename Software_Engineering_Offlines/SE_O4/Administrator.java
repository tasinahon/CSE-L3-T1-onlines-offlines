import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;


public class Administrator {
    private ArrayList<Stock>stockArrayList;
    HashMap<String,SocketWrapper> userMap;

    HashMap<Stock,String>notificationList=new HashMap<>();

    public HashMap<String, SocketWrapper> getUserMap() {
        return userMap;
    }

    public HashMap<Stock, String> getNotificationList() {
        return notificationList;
    }

    public void setUserMap(HashMap<String, SocketWrapper> userMap) {
        this.userMap = userMap;
    }


    public ArrayList<Stock> getStockArrayList() {
        return stockArrayList;
    }

    public void setStockArrayList(ArrayList<Stock> stockArrayList) {
        this.stockArrayList = stockArrayList;
    }

    public Administrator()
    {
        stockArrayList=new ArrayList<>();
    }

    public void addStock(Stock stock)
    {
        stockArrayList.add(stock);
    }

    public void increasePrice(Stock stock, double amount) throws IOException {

        stock.setStock_price(amount);
        String notification="Price for stock: "+ stock.getStock_name()+" has been increased";
        stock.notifyUser(userMap,notification);

    }

    public void decreasePrice(Stock stock, double amount) throws IOException {
        stock.setStock_price(amount);
        String notification="Price for stock: "+ stock.getStock_name()+" has been decreased";
        stock.notifyUser(userMap,notification);
    }

    public void changeCount(Stock stock, int newCount) throws IOException {
        stock.setStock_count(newCount);
        String notification="Stock count for stock: "+ stock.getStock_name()+" has been increased";
        stock.notifyUser(userMap,notification);
    }


}
