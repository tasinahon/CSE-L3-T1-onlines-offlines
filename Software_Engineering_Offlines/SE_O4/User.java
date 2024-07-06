import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class User  {

      private String userName;

      public boolean login=false;

      private ArrayList<String>notificationList=new ArrayList<>();

      public ArrayList<String> getNotificationList() {
            return notificationList;
      }

      public String getUserName() {
            return userName;
      }

      public void setUserName(String userName) {
            this.userName = userName;
      }

      public void update(String notification)
      {
          notificationList.add(notification);
      }

      public static void main(String[] args) throws IOException, ClassNotFoundException {
            SocketWrapper socketWrapper = new SocketWrapper("127.0.0.1",33333);
            Object o=socketWrapper.read();
            String a=(String)o;
            System.out.println(a);
            Scanner scanner = new Scanner(System.in);
            String s = scanner.nextLine();
            socketWrapper.write(s);




            new ClientWriteThread(socketWrapper);
            new ClientReadThread(socketWrapper);



      }
}
