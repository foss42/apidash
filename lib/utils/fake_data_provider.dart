import 'dart:math';

/// A utility class that provides functions to generate fake data for API testing
class FakeDataProvider {
  static final Random _random = Random();
  
  static String randomUsername() {
    final prefixes = ['user', 'test', 'dev', 'qa', 'admin', 'guest', 'john', 'jane'];
    final suffixes = ['123', '2023', '_test', '_dev', '_admin', '_guest'];
    
    final prefix = prefixes[_random.nextInt(prefixes.length)];
    final suffix = _random.nextInt(10) > 5 ? suffixes[_random.nextInt(suffixes.length)] : '';
    
    return '$prefix$suffix';
  }
  
  static String randomEmail() {
    final usernames = ['john', 'jane', 'user', 'test', 'dev', 'admin', 'info', 'support'];
    final domains = ['example.com', 'test.com', 'acme.org', 'email.net', 'company.io', 'service.dev'];
    
    final username = usernames[_random.nextInt(usernames.length)];
    final randomNum = _random.nextInt(1000);
    final domain = domains[_random.nextInt(domains.length)];
    
    return '$username$randomNum@$domain';
  }
  
  static String randomId() {
    return _random.nextInt(10000).toString().padLeft(4, '0');
  }
  
  static String randomUuid() {
    const chars = 'abcdef0123456789';
    final segments = [8, 4, 4, 4, 12]; //standard length of different segments of uuid
    
    final uuid = segments.map((segment) {
      return List.generate(segment, (_) => chars[_random.nextInt(chars.length)]).join();
    }).join('-');
    
    return uuid;
  }
  
  static String randomName() {
    final firstNames = ['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Lisa'];
    final lastNames = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Wilson'];
    
    final firstName = firstNames[_random.nextInt(firstNames.length)];
    final lastName = lastNames[_random.nextInt(lastNames.length)];
    
    return '$firstName $lastName';
  }
  
  static String randomPhone() {
    final areaCode = (100 + _random.nextInt(900)).toString();
    final firstPart = (100 + _random.nextInt(900)).toString();
    final secondPart = (1000 + _random.nextInt(9000)).toString();
    
    return '+1-$areaCode-$firstPart-$secondPart';
  }
  
  static String randomAddress() {
    final streetNumbers = List.generate(100, (i) => (i + 1) * 10);
    final streetNames = ['Main St', 'Oak Ave', 'Park Rd', 'Maple Dr', 'Pine Ln', 'Cedar Blvd'];
    final cities = ['Springfield', 'Rivertown', 'Lakeside', 'Mountainview', 'Brookfield'];
    final states = ['CA', 'NY', 'TX', 'FL', 'IL', 'WA'];
    final zipCodes = List.generate(90, (i) => 10000 + (i * 1000) + _random.nextInt(999));
    
    final streetNumber = streetNumbers[_random.nextInt(streetNumbers.length)];
    final streetName = streetNames[_random.nextInt(streetNames.length)];
    final city = cities[_random.nextInt(cities.length)];
    final state = states[_random.nextInt(states.length)];
    final zipCode = zipCodes[_random.nextInt(zipCodes.length)];
    
    return '$streetNumber $streetName, $city, $state $zipCode';
  }

  static String randomDate() {
    final now = DateTime.now();
    final randomDays = _random.nextInt(1000) - 500; 
    final date = now.add(Duration(days: randomDays));
    
    return date.toIso8601String().split('T')[0]; 
  }

  static String randomDateTime() {
    final now = DateTime.now();
    final randomDays = _random.nextInt(100) - 50;
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

  static String randomNumber({int min = 0, int max = 1000}) {
    return (_random.nextInt(max - min) + min).toString();
  }

  static String randomJson() {
    return '{"id": ${randomId()}, "name": "${randomName()}", "email": "${randomEmail()}", "active": ${randomBoolean()}}';
  }

  static String processFakeDataTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'randomusername':
        return randomUsername();
      case 'randomemail':
        return randomEmail();
      case 'randomid':
        return randomId();
      case 'randomuuid':
        return randomUuid();
      case 'randomname':
        return randomName();
      case 'randomphone':
        return randomPhone();
      case 'randomaddress':
        return randomAddress();
      case 'randomdate':
        return randomDate();
      case 'randomdatetime':
        return randomDateTime();
      case 'randomboolean':
        return randomBoolean();
      case 'randomnumber':
        return randomNumber();
      case 'randomjson':
        return randomJson();
      default:
        return '{{$tag}}'; 
    }
  }
}
