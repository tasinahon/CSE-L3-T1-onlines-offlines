import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

public class File implements Component{
    private String name;
    private double size;
    private String type;
    private String directory;

    private int component_count;
    private String creation_time;

    public String getName() {
        return name;
    }

    @Override
    public ArrayList<Component> getList_of_component() {
        return null;
    }

    @Override
    public void deleterecursively(String name) {

    }

    @Override
    public String get_directory() {
        return this.directory;
    }

    public String getType() {
        return type;
    }

    public String getDirectory() {
        return directory;
    }

    public int getComponent_count() {
        return component_count;
    }

    public String getCreation_time() {
        return creation_time;
    }

    public File(String name, double size, String directory) {
        this.name = name;
        this.size = size;
        this.type = "File";
        this.directory = directory;
        this.component_count = 0;
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM,yyyy  h:mm a");
        this.creation_time= LocalDateTime.now().format(formatter);
    }

    @Override
    public Component changeDirectory(String name) {
          return null;
    }

    @Override
    public void detail(String name) {
        System.out.println("Name: " + name +
                "\nType: File" +
                "\nSize:" + this.getSize() +"kB" +
                "\nDirectory: \"" + directory + "\"" +
                "\nComponent Count: " + component_count+
                "\nCreation time: " + creation_time);

    }

    @Override
    public void listing() {
        System.out.println( this.getName() +"    "+ this.getSize() +"kb"+"    "+ this.getCreation_time());
    }

    @Override
    public void delete(String name) {

    }

    @Override
    public void recursiveDelete() {

    }


    @Override
    public void makeDir(String name) {
        System.out.println("Can't make folder in file");
    }

    @Override
    public void touch(String names, double size) {
        System.out.println("Can't create file inside file");
    }

    @Override
    public void makeDrive(String name) {
        System.out.println("Can't make drive here");

    }

    @Override
    public double getSize() {
        return this.size;
    }
}
