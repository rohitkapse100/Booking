public class TemperatureConverter {
    public static Decimal convertFahrenheitToCelsius(Decimal fahrenheit) {
        decimal d = (fahrenheit - 32) * 5 / 9;
        return d;
        
    }
}