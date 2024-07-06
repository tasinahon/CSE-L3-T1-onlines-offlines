public class Vanilla_shake_builder implements Shake_builder{
    Shakes shakes;

    public Vanilla_shake_builder() {
        shakes=new Shakes("Vanilla shake",190);
    }

    @Override
    public Shake_builder basic_ingredients() {
        shakes.add_ingredient("Flavoring and jello");
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
