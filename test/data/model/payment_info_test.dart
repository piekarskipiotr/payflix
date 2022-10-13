import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payflix/data/model/payment_info.dart';

void main() {
  group('Next date of payment', () {
    test('Next date should return today date', () {
      final today = DateTime(2022, 9, 23);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 23);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getNextDate(), DateTime(2022, 9, 23));
      });
    });

    test('Next date should return date with same month', () {
      final today = DateTime(2022, 5, 7);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 9);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getNextDate(), DateTime(2022, 5, 9));
      });
    });

    test('Next date should return date in next month', () {
      final today = DateTime(2022, 5, 7);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 6);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getNextDate(), DateTime(2022, 6, 6));
      });
    });

    test('Next date should return 28-02-2022', () {
      final today = DateTime(2022, 2, 1);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 31);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getNextDate(), DateTime(2022, 2, 28));
      });
    });
  });

  group('Days until next payment', () {
    test('Should return 0', () {
      final today = DateTime(2022, 9, 23);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 23);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getDaysUntilNextPayment(), 0);
      });
    });

    test('Should return 7', () {
      final today = DateTime(2022, 9, 16);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 23);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getDaysUntilNextPayment(), 7);
      });
    });

    test('Should return 29', () {
      final today = DateTime(2022, 9, 17);
      final paymentInfo = PaymentInfo(monthlyPayment: 7, dayOfTheMonth: 16);

      withClock(Clock.fixed(today), () {
        expect(paymentInfo.getDaysUntilNextPayment(), 29);
      });
    });
  });
}
