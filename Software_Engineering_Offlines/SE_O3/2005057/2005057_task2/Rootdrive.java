import java.security.cert.CertPath;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Iterator;

public class Rootdrive implements Component{
    private String name;

    private String directory;

    private String creation_time;

    private int component_count;
    private ArrayList<Component> list_of_component;

    public Rootdrive(String name) {
        this.name=name;
        this.directory = "";
        this.component_count=0;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM,yyyy  h:mm a");
        this.creation_time= LocalDateTime.now().format(formatter);
        this.list_of_component = new ArrayList<>();
    }


    public void addComponent(Component component) {

        this.list_of_component.add(component);
        this.component_count++;
    }

    public void removeComponent(Component component) {
        list_of_component.remove(component);
        this.component_count--;
    }



    @Override
    public Component changeDirectory(String name) {
        for(Component c:this.getList_of_component())
        {
            if(c.get_directory().equals(name))
            {
                if(c instanceof File)
                {
                    return null;
                }
                else {
                    return c;
                }
            }
        }
        return null;

    }

    @Override
    public void detail(String name) {
        for(Component c:this.list_of_component)
        {
            if(c.getName().equals(name))
            {
                System.out.println("Name: " + c.getName() +
                        "\nType: Folder" +
                        "\nSize:" + c.getSize() +"kB" +
                        "\nDirectory: \"" + c.get_directory() + "\"" +
                        "\nComponent Count: " + c.getComponent_count()+
                        "\nCreation time: " + c.getCreation_time());
            }
        }

    }

    @Override
    public void listing() {
        for (Component c : this.list_of_component) {
            System.out.println( c.getName() +"    "+ c.getSize() +"kb"+"    "+ c.getCreation_time());
        }

    }

    @Override
    public void delete(String name) {
        for(Component c:this.list_of_component)
        {
            if(c.getList_of_component().isEmpty())
            {
                this.removeComponent(c);
                return;
            }
        }
        System.out.println("Not found in the current directory");

    }

    @Override
    public void deleterecursively(String name) {
        Iterator<Component> iterator = this.list_of_component.iterator();
        while (iterator.hasNext())
        {
            Component c = iterator.next();
            if (c.getName().equals(name))
            {
                c.recursiveDelete();
                break;
            }
        }

    }

    @Override
    public void recursiveDelete() {
        Iterator<Component> iterator = this.list_of_component.iterator();
        while (iterator.hasNext())
        {
            Component c = iterator.next();
            if (c instanceof Folder)
            {
                c.recursiveDelete();
            }
            else if (c instanceof File)
            {
                System.out.println("Warning:file is being deleted");
                iterator.remove();
            }
        }
    }

    @Override
    public String get_directory() {
        return this.directory;
    }

    @Override
    public int getComponent_count() {
        return this.component_count;
    }


    @Override
    public void makeDir(String name) {

        System.out.println("Can't make folder in root drive");

    }

    @Override
    public void touch(String names, double size) {
        System.out.println("Can't create file in root_drive");
    }

    @Override
    public void makeDrive(String name) {
        Drive drive=new Drive(name);
        this.addComponent(drive);

    }

    @Override
    public double getSize() {
        return 0;
    }

    @Override
    public String getName() {
        return null;
    }

    @Override
    public String getCreation_time() {
        return creation_time;
    }

    @Override
    public ArrayList<Component> getList_of_component() {
        return list_of_component;
    }


}
