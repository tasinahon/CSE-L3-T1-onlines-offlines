public class Chocolate_shake_builder implements Shake_builder{
    private Shakes shakes;

    public Chocolate_shake_builder() {
        shakes=new Shakes("Chocolate shake",230);
    }

    @Override
    public Shake_builder basic_ingredients() {
        shakes.add_ingredient("syrup and chocolate ice cream");

        return this;
    }

    @Override
    public Shake_builder with_or_without_sugar() {
        shakes.add_ingredient("sugar");
        return this;
    }

    @Override
    public Shake_builder milk() {
        shakes.add_ingredient("milk");
        return this;
    }


    @Override
    public Shakes getResult() {
        return shakes;
    }
}
