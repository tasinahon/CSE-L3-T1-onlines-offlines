public class Coffee_shake_builder implements Shake_builder{
    private Shakes shakes;

    public Coffee_shake_builder() {
        shakes=new Shakes("Coffee shake",250);
    }

    @Override
    public Shake_builder basic_ingredients() {
       shakes.add_ingredient("Coffee and jello");
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
