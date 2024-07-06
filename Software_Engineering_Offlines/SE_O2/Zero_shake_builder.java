public class Zero_shake_builder implements Shake_builder{
    private Shakes shakes;
    public Zero_shake_builder() {
        shakes=new Shakes("Zero shake",240);

    }

    @Override
    public Shake_builder basic_ingredients() {
         shakes.add_ingredient("Sweetener  along with vanilla flavoring and sugar-free jello");
        return this;
    }
    @Override
    public Shake_builder with_or_without_sugar() {

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
