public class Director {
    public Shakes construct(Shake_builder builder) {

        return builder.basic_ingredients().with_or_without_sugar()
                .milk().getResult();
    }
}
