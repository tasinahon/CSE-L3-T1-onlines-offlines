import java.util.ArrayList;

public class Shakes {
    private String name;
    private ArrayList<String> shake_ingredient_list;
    private ArrayList<String>customized_ingredient_list;
    private double price;

    public Shakes(String name,double price) {
        this.name = name;
        this.shake_ingredient_list = new ArrayList<>();
        this.customized_ingredient_list=new ArrayList<>();
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public ArrayList<String> getCustomized_item_list() {
        return customized_ingredient_list;
    }

    public ArrayList<String> getIngredients() {
        return shake_ingredient_list;
    }
    public void add_ingredient(String ingredient) {
        shake_ingredient_list.add(ingredient);

    }
    public void add_extra_ingredient(String ingredient, double cost)
    {
        customized_ingredient_list.add(ingredient);
        price += cost;
    }

    public double getPrice() {
        return price;
    }
}
