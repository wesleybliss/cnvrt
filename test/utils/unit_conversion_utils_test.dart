import 'package:cnvrt/utils/unit_conversion_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Temperature Conversions', () {
    group('celsiusToFahrenheit', () {
      test('converts freezing point', () {
        expect(celsiusToFahrenheit(0), equals(32));
      });

      test('converts boiling point', () {
        expect(celsiusToFahrenheit(100), equals(212));
      });

      test('converts room temperature', () {
        expect(celsiusToFahrenheit(20), equals(68));
        expect(celsiusToFahrenheit(25), equals(77));
      });

      test('converts negative temperatures', () {
        expect(celsiusToFahrenheit(-40), equals(-40)); // Same in both scales!
        expect(celsiusToFahrenheit(-10), equals(14));
      });

      test('converts high temperatures', () {
        expect(celsiusToFahrenheit(37), equals(98)); // Body temp
        expect(celsiusToFahrenheit(200), equals(392));
      });
    });

    group('fahrenheitToCelsius', () {
      test('converts freezing point', () {
        expect(fahrenheitToCelsius(32), equals(0));
      });

      test('converts boiling point', () {
        expect(fahrenheitToCelsius(212), equals(100));
      });

      test('converts room temperature', () {
        expect(fahrenheitToCelsius(68), equals(20));
        expect(fahrenheitToCelsius(77), equals(25));
      });

      test('converts negative temperatures', () {
        expect(fahrenheitToCelsius(-40), equals(-40));
        expect(fahrenheitToCelsius(14), equals(-10));
      });

      test('converts body temperature', () {
        expect(fahrenheitToCelsius(98), equals(36)); // Rounded
      });
    });

    group('celsiusToKelvin', () {
      test('converts absolute zero', () {
        expect(celsiusToKelvin(-273), equals(0));
      });

      test('converts freezing point', () {
        expect(celsiusToKelvin(0), equals(273));
      });

      test('converts boiling point', () {
        expect(celsiusToKelvin(100), equals(373));
      });

      test('converts room temperature', () {
        expect(celsiusToKelvin(20), equals(293));
        expect(celsiusToKelvin(25), equals(298));
      });
    });

    group('kelvinToCelsius', () {
      test('converts absolute zero', () {
        expect(kelvinToCelsius(0), equals(-273));
      });

      test('converts freezing point', () {
        expect(kelvinToCelsius(273), equals(-0)); // Essentially 0
      });

      test('converts boiling point', () {
        expect(kelvinToCelsius(373), equals(99)); // Rounded
      });

      test('converts room temperature', () {
        expect(kelvinToCelsius(293), equals(19)); // Rounded
        expect(kelvinToCelsius(298), equals(24)); // Rounded
      });
    });

    group('fahrenheitToKelvin', () {
      test('converts absolute zero fahrenheit', () {
        expect(fahrenheitToKelvin(-459), equals(0));
      });

      test('converts freezing point', () {
        expect(fahrenheitToKelvin(32), equals(273));
      });

      test('converts boiling point', () {
        expect(fahrenheitToKelvin(212), equals(373));
      });

      test('converts room temperature', () {
        expect(fahrenheitToKelvin(68), equals(293));
      });
    });

    group('kelvinToFahrenheit', () {
      test('converts absolute zero', () {
        expect(kelvinToFahrenheit(0), equals(-459));
      });

      test('converts freezing point', () {
        expect(kelvinToFahrenheit(273), equals(31)); // Rounded
      });

      test('converts boiling point', () {
        expect(kelvinToFahrenheit(373), equals(211)); // Rounded
      });

      test('converts room temperature', () {
        expect(kelvinToFahrenheit(293), equals(67)); // Rounded
      });
    });
  });

  group('Distance Conversions', () {
    group('kmToMiles', () {
      test('converts zero', () {
        expect(kmToMiles(0), equals(0));
      });

      test('converts short distances', () {
        expect(kmToMiles(1), equals(0)); // Rounds down
        expect(kmToMiles(5), equals(3));
        expect(kmToMiles(10), equals(6));
      });

      test('converts medium distances', () {
        expect(kmToMiles(100), equals(62));
        expect(kmToMiles(160), equals(99)); // ~1 mile per 1.6 km
      });

      test('converts long distances', () {
        expect(kmToMiles(1000), equals(621));
        expect(kmToMiles(5000), equals(3106));
      });
    });

    group('milesToKm', () {
      test('converts zero', () {
        expect(milesToKm(0), equals(0));
      });

      test('converts short distances', () {
        expect(milesToKm(1), equals(1)); // Rounded
        expect(milesToKm(5), equals(8));
        expect(milesToKm(10), equals(16));
      });

      test('converts medium distances', () {
        expect(milesToKm(100), equals(160));
        expect(milesToKm(62), equals(99)); // ~100 km
      });

      test('converts long distances', () {
        expect(milesToKm(1000), equals(1609));
        expect(milesToKm(5000), equals(8046));
      });
    });

    test('roundtrip conversion maintains approximate value', () {
      expect(kmToMiles(milesToKm(100)), closeTo(100, 5));
      expect(milesToKm(kmToMiles(100)), closeTo(100, 5));
    });
  });

  group('Speed Conversions', () {
    group('kphToMph', () {
      test('converts zero', () {
        expect(kphToMph(0), equals(0));
      });

      test('converts low speeds', () {
        expect(kphToMph(10), equals(6));
        expect(kphToMph(50), equals(31));
      });

      test('converts highway speeds', () {
        expect(kphToMph(100), equals(62));
        expect(kphToMph(120), equals(74));
      });

      test('converts high speeds', () {
        expect(kphToMph(200), equals(124));
        expect(kphToMph(300), equals(186));
      });
    });

    group('mphToKph', () {
      test('converts zero', () {
        expect(mphToKph(0), equals(0));
      });

      test('converts low speeds', () {
        expect(mphToKph(10), equals(16));
        expect(mphToKph(30), equals(48));
      });

      test('converts highway speeds', () {
        expect(mphToKph(60), equals(96));
        expect(mphToKph(70), equals(112));
      });

      test('converts high speeds', () {
        expect(mphToKph(100), equals(160));
        expect(mphToKph(200), equals(321));
      });
    });

    test('roundtrip conversion maintains approximate value', () {
      expect(kphToMph(mphToKph(60)), closeTo(60, 3));
      expect(mphToKph(kphToMph(100)), closeTo(100, 3));
    });
  });

  group('Area Conversions', () {
    group('squareMetersToSquareFeet', () {
      test('converts zero', () {
        expect(squareMetersToSquareFeet(0), equals(0));
      });

      test('converts small areas', () {
        expect(squareMetersToSquareFeet(1), equals(10)); // Rounded
        expect(squareMetersToSquareFeet(10), equals(107));
      });

      test('converts room sizes', () {
        expect(squareMetersToSquareFeet(20), equals(215));
        expect(squareMetersToSquareFeet(50), equals(538));
      });

      test('converts large areas', () {
        expect(squareMetersToSquareFeet(100), equals(1076));
        expect(squareMetersToSquareFeet(1000), equals(10763));
      });
    });

    group('squareFeetToSquareMeters', () {
      test('converts zero', () {
        expect(squareFeetToSquareMeters(0), equals(0));
      });

      test('converts small areas', () {
        expect(squareFeetToSquareMeters(10), equals(0)); // Rounds down
        expect(squareFeetToSquareMeters(100), equals(9));
      });

      test('converts room sizes', () {
        expect(squareFeetToSquareMeters(200), equals(18));
        expect(squareFeetToSquareMeters(500), equals(46));
      });

      test('converts large areas', () {
        expect(squareFeetToSquareMeters(1000), equals(92));
        expect(squareFeetToSquareMeters(10000), equals(929));
      });
    });

    test('roundtrip conversion maintains approximate value', () {
      expect(squareMetersToSquareFeet(squareFeetToSquareMeters(1000)), closeTo(1000, 50));
      expect(squareFeetToSquareMeters(squareMetersToSquareFeet(100)), closeTo(100, 5));
    });
  });

  group('Weight Conversions', () {
    group('kilogramsToPounds', () {
      test('converts zero', () {
        expect(kilogramsToPounds(0), equals(0));
      });

      test('converts light weights', () {
        expect(kilogramsToPounds(1), equals(2));
        expect(kilogramsToPounds(5), equals(11));
        expect(kilogramsToPounds(10), equals(22));
      });

      test('converts medium weights', () {
        expect(kilogramsToPounds(50), equals(110));
        expect(kilogramsToPounds(75), equals(165));
      });

      test('converts heavy weights', () {
        expect(kilogramsToPounds(100), equals(220));
        expect(kilogramsToPounds(500), equals(1102));
      });
    });

    group('poundsToKilograms', () {
      test('converts zero', () {
        expect(poundsToKilograms(0), equals(0));
      });

      test('converts light weights', () {
        expect(poundsToKilograms(2), equals(0)); // Rounds down
        expect(poundsToKilograms(10), equals(4));
        expect(poundsToKilograms(20), equals(9));
      });

      test('converts medium weights', () {
        expect(poundsToKilograms(100), equals(45));
        expect(poundsToKilograms(150), equals(68));
      });

      test('converts heavy weights', () {
        expect(poundsToKilograms(200), equals(90));
        expect(poundsToKilograms(1000), equals(453));
      });
    });

    test('roundtrip conversion maintains approximate value', () {
      expect(kilogramsToPounds(poundsToKilograms(150)), closeTo(150, 5));
      expect(poundsToKilograms(kilogramsToPounds(70)), closeTo(70, 3));
    });
  });

  group('Volume Conversions', () {
    group('gallonsToLiters', () {
      test('converts zero', () {
        expect(gallonsToLiters(0), equals(0));
      });

      test('converts small volumes', () {
        expect(gallonsToLiters(1), equals(3));
        expect(gallonsToLiters(5), equals(18));
      });

      test('converts medium volumes', () {
        expect(gallonsToLiters(10), equals(37));
        expect(gallonsToLiters(20), equals(75));
      });

      test('converts large volumes', () {
        expect(gallonsToLiters(50), equals(189));
        expect(gallonsToLiters(100), equals(378));
      });
    });

    group('litersToGallons', () {
      test('converts zero', () {
        expect(litersToGallons(0), equals(0));
      });

      test('converts small volumes', () {
        expect(litersToGallons(1), equals(0)); // Rounds down
        expect(litersToGallons(5), equals(1));
        expect(litersToGallons(10), equals(2));
      });

      test('converts medium volumes', () {
        expect(litersToGallons(20), equals(5));
        expect(litersToGallons(40), equals(10));
      });

      test('converts large volumes', () {
        expect(litersToGallons(100), equals(26));
        expect(litersToGallons(200), equals(52));
      });
    });

    test('roundtrip conversion maintains approximate value', () {
      expect(gallonsToLiters(litersToGallons(100)), closeTo(100, 10));
      expect(litersToGallons(gallonsToLiters(25)), closeTo(25, 2));
    });
  });
}
