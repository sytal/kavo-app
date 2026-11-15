import 'package:kavo/data/menu_item.dart';
import 'package:kavo/services/api_client.dart';
import 'package:kavo/utils/format.dart';
import 'package:kavo/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatRs', () {
    test('adds thousands separators like the website', () {
      expect(formatRs(2650), 'Rs. 2,650');
      expect(formatRs(650), 'Rs. 650');
      expect(formatRs(1234567), 'Rs. 1,234,567');
      expect(formatRs(1250.5), 'Rs. 1,250.50');
    });
  });

  group('parsePrice', () {
    test('reads display prices', () {
      expect(parsePrice('Rs. 650'), 650);
      expect(parsePrice('Rs. 1,200'), 1200);
      expect(parsePrice('abc'), 0);
    });
  });

  group('Validators.phone', () {
    test('matches the backend rule', () {
      expect(Validators.phone('03001234567'), isNull);
      expect(Validators.phone('+92 300 1234567'), isNull);
      expect(Validators.phone('abc'), isNotNull);
      expect(Validators.phone('0112020263001234567'), isNotNull);
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('', optional: true), isNull);
    });
  });

  group('ApiClient.resolveMediaUrl', () {
    test('points server images at the API host the app uses', () {
      final origin = ApiClient.serverOrigin;
      expect(ApiClient.resolveMediaUrl('/uploads/a.jpg'), '$origin/uploads/a.jpg');
      expect(ApiClient.resolveMediaUrl('http://127.0.0.1:8011/images/menu/b.jpg'), '$origin/images/menu/b.jpg');
    });
  });

  test('MenuItem.fromJson parses the API shape', () {
    final item = MenuItem.fromJson({
      'id': 3,
      'name': 'Smoky BBQ Fries',
      'category': 'Loaded Fries',
      'description': 'Smoky.',
      'price': 'Rs. 700',
      'image': 'http://127.0.0.1:8011/images/menu/x.jpg',
      'tags': ['Smoky', 'BBQ'],
      'is_available': true,
    });
    expect(item.id, 3);
    expect(item.tags, ['Smoky', 'BBQ']);
    expect(item.isRemoteImage, isTrue);
  });
}
