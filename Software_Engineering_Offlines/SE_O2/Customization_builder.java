public class Customization_builder {
    private Shakes shakes;

    public Customization_builder(Shakes shakes) {
        this.shakes = shakes;
    }


    public Customization_builder lactose_free() {
        for(int i=0;i<shakes.getIngredients().size();i++)
        {
            if(shakes.getIngredients().get(i).equals("Milk"))
            {
                shakes.getIngredients().remove(i);
            }

        }
        shakes.add_extra_ingredient("Almond milk",60);
        return this;
    }

    public Customization_builder candy_add() {
        shakes.add_extra_ingredient("Candy",50);
        return this;

    }


    public Customization_builder cookies_add() {
        shakes.add_extra_ingredient("Cookies",40);
        return this;

    }


    public Shakes build() {
        return shakes;
    }
}
