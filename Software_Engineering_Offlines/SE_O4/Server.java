import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;

public class Server {

    public static void main(String[] args) throws IOException, ClassNotFoundException {

        Administrator administrator=new Administrator();
        HashMap<String,SocketWrapper> userMap=new HashMap<>();
        HashMap<String,User>userObject=new HashMap<>();
        administrator.setUserMap(userMap);
        try (BufferedReader reader = new BufferedReader(new FileReader("stock.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] tokens = line.split(" ");
                String stockName = tokens[0];
                int stockCount = Integer.parseInt(tokens[1]);
                double stockPrice = Double.parseDouble(tokens[2]);

                Stock stock = new Stock(stockName, stockCount, stockPrice);
                administrator.addStock(stock);

            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        new AdministratorThread(administrator);
        ServerSocket serverSocket=new ServerSocket(33333);
        while (true)
        {
            Socket socket=serverSocket.accept();
            SocketWrapper socketWrapper = new SocketWrapper(socket);

            new ThreadCreator(socketWrapper,administrator,userObject);
        }
    }
}
