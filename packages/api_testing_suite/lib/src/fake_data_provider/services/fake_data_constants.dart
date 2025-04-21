/// Constants for the fake data generation service
class FakeDataConstants {
  // Random data generation limits
  static const int defaultMaxRandomNumber = 1000;
  static const int defaultMinRandomNumber = 0;
  
  // Random ID generation
  static const int randomIdDigits = 4;
  static const int randomIdMaxValue = 10000;
  
  // UUID format segments
  static const List<int> uuidSegmentLengths = [8, 4, 4, 4, 12];
  static const String uuidCharacterSet = 'abcdef0123456789';
  
  // Phone number format
  static const int phoneAreaCodeMin = 100;
  static const int phoneAreaCodeMax = 999;
  static const int phoneFirstPartMin = 100;
  static const int phoneFirstPartMax = 999;
  static const int phoneSecondPartMin = 1000;
  static const int phoneSecondPartMax = 9999;
  
  // Date and datetime generation
  static const int randomDateRangeDays = 1000;
  static const int randomDateTimeRangeDays = 100;
  
  // Address generation
  static const int streetNumberMin = 10;
  static const int streetNumberMax = 1000;
  static const int zipCodeMin = 10000;
  static const int zipCodeMax = 99999;
  
  // Random array probability thresholds
  static const int usernameSuffixProbabilityThreshold = 5; // out of 10
}
