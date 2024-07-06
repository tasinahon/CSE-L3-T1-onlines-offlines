import java.util.ArrayList;

public interface Component {
    Component changeDirectory(String name);
    void detail(String name);
    void listing();
    void delete(String name);
    void recursiveDelete();
    void makeDir(String name);
    void touch(String names, double size);
    void makeDrive(String name);

    double getSize();
    String getName();
    String getCreation_time();
    ArrayList<Component> getList_of_component();


    void deleterecursively(String name);

    String get_directory();

    int getComponent_count();
}
