import 'dart:math';
import 'package:api_testing_suite/src/common/utils/logger.dart';
import 'fake_data_constants.dart';

/// A utility class that provides functions to generate fake data for API testing
class FakeDataProvider {
  static final Random _random = Random();

  static String randomUsername() {
    final prefixes = [
      'user',
      'test',
      'dev',
      'qa',
      'admin',
      'guest',
      'john',
      'jane'
    ];
    final suffixes = ['123', '2023', '_test', '_dev', '_admin', '_guest'];

    final prefix = prefixes[_random.nextInt(prefixes.length)];
    final includeSuffix = _random.nextInt(10) > FakeDataConstants.usernameSuffixProbabilityThreshold;
    final suffix = includeSuffix ? suffixes[_random.nextInt(suffixes.length)] : '';

    return '$prefix$suffix';
  }

  static String randomEmail() {
    final usernames = [
      'john',
      'jane',
      'user',
      'test',
      'dev',
      'admin',
      'info',
      'support'
    ];
    final domains = [
      'example.com',
      'test.com',
      'acme.org',
      'email.net',
      'company.io',
      'service.dev'
    ];

    final username = usernames[_random.nextInt(usernames.length)];
    final randomNum = _random.nextInt(FakeDataConstants.defaultMaxRandomNumber);
    final domain = domains[_random.nextInt(domains.length)];

    return '$username$randomNum@$domain';
  }

  static String randomId() {
    return _random.nextInt(FakeDataConstants.randomIdMaxValue)
        .toString()
        .padLeft(FakeDataConstants.randomIdDigits, '0');
  }

  static String randomUuid() {
    final uuid = FakeDataConstants.uuidSegmentLengths.map((segmentLength) {
      return List.generate(
        segmentLength, 
        (_) => FakeDataConstants.uuidCharacterSet[
          _random.nextInt(FakeDataConstants.uuidCharacterSet.length)
        ]
      ).join();
    }).join('-');

    return uuid;
  }

  static String randomName() {
    final firstNames = [
      'John',
      'Jane',
      'Michael',
      'Emily',
      'David',
      'Sarah',
      'Robert',
      'Lisa'
    ];
    final lastNames = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Miller',
      'Davis',
      'Wilson'
    ];

    final firstName = firstNames[_random.nextInt(firstNames.length)];
    final lastName = lastNames[_random.nextInt(lastNames.length)];

    return '$firstName $lastName';
  }

  static String randomPhone() {
    final areaCode = (FakeDataConstants.phoneAreaCodeMin + 
                     _random.nextInt(FakeDataConstants.phoneAreaCodeMax - 
                                    FakeDataConstants.phoneAreaCodeMin)).toString();
                                    
    final firstPart = (FakeDataConstants.phoneFirstPartMin + 
                      _random.nextInt(FakeDataConstants.phoneFirstPartMax - 
                                     FakeDataConstants.phoneFirstPartMin)).toString();
                                     
    final secondPart = (FakeDataConstants.phoneSecondPartMin + 
                       _random.nextInt(FakeDataConstants.phoneSecondPartMax - 
                                      FakeDataConstants.phoneSecondPartMin)).toString();

    return '+1-$areaCode-$firstPart-$secondPart';
  }

  static String randomAddress() {
    final streetNumbers = List.generate(
      (FakeDataConstants.streetNumberMax - FakeDataConstants.streetNumberMin) ~/ 10,
      (i) => (i + 1) * 10
    );
    
    final streetNames = [
      'Main St',
      'Oak Ave',
      'Park Rd',
      'Maple Dr',
      'Pine Ln',
      'Cedar Blvd'
    ];
    
    final cities = [
      'Springfield',
      'Rivertown',
      'Lakeside',
      'Mountainview',
      'Brookfield'
    ];
    
    final states = ['CA', 'NY', 'TX', 'FL', 'IL', 'WA'];
    
    final zipCodes = List.generate(
      90, 
      (i) => FakeDataConstants.zipCodeMin + 
             (i * 1000) + 
             _random.nextInt(999)
    );

    final streetNumber = streetNumbers[_random.nextInt(streetNumbers.length)];
    final streetName = streetNames[_random.nextInt(streetNames.length)];
    final city = cities[_random.nextInt(cities.length)];
    final state = states[_random.nextInt(states.length)];
    final zipCode = zipCodes[_random.nextInt(zipCodes.length)];

    return '$streetNumber $streetName, $city, $state $zipCode';
  }

  static String randomDate() {
    final now = DateTime.now();
    final randomDays = _random.nextInt(FakeDataConstants.randomDateRangeDays) - 
                       (FakeDataConstants.randomDateRangeDays ~/ 2);
    final date = now.add(Duration(days: randomDays));

    return date.toIso8601String().split('T')[0];
  }

  ///  ISO 8601 format
  static String randomDateTime() {
    final now = DateTime.now();
    final randomDays = _random.nextInt(FakeDataConstants.randomDateTimeRangeDays) - 
                       (FakeDataConstants.randomDateTimeRangeDays ~/ 2);
    final randomHours = _random.nextInt(24);
    final randomMinutes = _random.nextInt(60);
    final randomSeconds = _random.nextInt(60);

    final dateTime = now.add(Duration(
      days: randomDays,
      hours: randomHours,
      minutes: randomMinutes,
      seconds: randomSeconds,
    ));

    return dateTime.toIso8601String();
  }

  static String randomBoolean() {
    return _random.nextBool().toString();
  }

  static String randomNumber({
    int min = FakeDataConstants.defaultMinRandomNumber, 
    int max = FakeDataConstants.defaultMaxRandomNumber
  }) {
    return (_random.nextInt(max - min) + min).toString();
  }

  static String randomJson() {
    return '''
{
  "id": ${randomId()},
  "name": "${randomName()}",
  "email": "${randomEmail()}",
  "active": ${randomBoolean()},
  "created_at": "${randomDateTime()}"
}''';
  }

  /// Registry for mapping tags to fake data generator functions.
  static final Map<String, String Function()> _tagRegistry = {
    'randomusername': randomUsername,
    'randomemail': randomEmail,
    'randomid': randomId,
    'randomuuid': randomUuid,
    'randomname': randomName,
    'randomphone': randomPhone,
    'randomaddress': randomAddress,
    'randomdate': randomDate,
    'randomdatetime': randomDateTime,
    'randomboolean': randomBoolean,
    'randomnumber': randomNumber,
    'randomjson': randomJson,
  };

  static Map<String, String Function()> get tagRegistry => _tagRegistry;
  
  /// Processes a string containing fake data tags and replaces them with generated data
  /// 
  /// Example: "Hello {{randomName}}, your email is {{randomEmail}}"
  /// Returns the input string with all tags replaced with generated values
  static String processFakeDataTags(String input) {
    ApiTestLogger.debug('Processing fake data tags in: $input');
    
    final regex = RegExp(r'\{\{(\w+)(?:\((.*?)\))?\}\}');
    final result = input.replaceAllMapped(regex, (match) {
      final tag = match.group(1)?.toLowerCase();
      
      if (tag != null && _tagRegistry.containsKey(tag)) {
        try {
          return _tagRegistry[tag]!();
        } catch (e) {
          ApiTestLogger.error('Error generating fake data for tag: $tag', e);
          return match.group(0) ?? '';
        }
      }
      
      return match.group(0) ?? '';
    });
    
    return result;
  }
}
