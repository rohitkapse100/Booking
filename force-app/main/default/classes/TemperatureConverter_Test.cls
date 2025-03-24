@isTest
public class TemperatureConverter_Test {
    @isTest
    public static void testConvertFahrenheitToCelsius() {
        Decimal fahrenheit = 32; 
        Decimal expectedCelsius = 0;
        Decimal actualCelsius = TemperatureConverter.convertFahrenheitToCelsius(fahrenheit);
        System.assertEquals(expectedCelsius, actualCelsius);
    }
}