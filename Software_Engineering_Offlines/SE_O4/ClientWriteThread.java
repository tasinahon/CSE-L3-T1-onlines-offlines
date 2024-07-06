import java.io.IOException;
import java.util.Scanner;

public class ClientWriteThread implements Runnable{
    SocketWrapper socketWrapper;
    Thread t;

    public ClientWriteThread(SocketWrapper socketWrapper)
    {
        this.socketWrapper=socketWrapper;
        t=new Thread(this);
        t.start();
    }
    @Override
    public void run() {

        while (true) {
            try {

                Scanner scanner = new Scanner(System.in);
                String s = scanner.nextLine();
                Data d = new Data();
                d.setCommand(s);
                socketWrapper.write(d);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
