import java.io.IOException;
public class ClientReadThread implements Runnable{
    SocketWrapper socketWrapper;
    Thread t;
    public ClientReadThread(SocketWrapper socketWrapper)
    {
        this.socketWrapper=socketWrapper;
        t=new Thread(this);
        t.start();
    }
    @Override
    public void run() {

        while(true) {
            try {

                Object o = socketWrapper.read();
                String read = (String) o;
                System.out.println(read);
            } catch (ClassNotFoundException | IOException e) {
                e.printStackTrace();
            }
        }

    }
}
