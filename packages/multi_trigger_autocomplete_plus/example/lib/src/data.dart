import 'package:example/src/models.dart';

const sahil = User(
  id: 'xsahil03x',
  name: 'Sahil Kumar',
  avatar: 'https://bit.ly/3yEVRrD',
);

const avni = User(
  id: 'avu.saxena',
  name: 'Avni Saxena',
  avatar: 'https://bit.ly/3PbPBii',
);

const trapti = User(
  id: 'trapti2711',
  name: 'Trapti Gupta',
  avatar: 'https://bit.ly/3aDHtba',
);

const gaurav = User(
  id: 'itsmegb98',
  name: 'Gaurav Bhadouriya',
  avatar: 'https://bit.ly/3PmNdES',
);

const amit = User(
  id: 'amitk_15',
  name: 'Amit Kumar',
  avatar: 'https://bit.ly/3P9GPB8',
);

const ayush = User(
  id: 'ayushpgupta',
  name: 'Ayush Gupta',
  avatar: 'https://bit.ly/3Rw61Dv',
);

const shubham = User(
  id: 'someshubham',
  name: 'Shubham Jain',
  avatar: 'https://bit.ly/3Rs3uud',
);

const kUsers = <User>[
  sahil,
  avni,
  gaurav,
  trapti,
  amit,
  ayush,
  shubham,
];

const kHashtags = <Hashtag>[
  Hashtag(
    name: 'dart',
    weight: 1,
    description:
        'Dart is a language for building fast, scalable and maintainable applications.',
    image: 'https://dwglogo.com/wp-content/uploads/2018/03/Dart_logo.png',
  ),
  Hashtag(
    name: 'flutter',
    weight: 2,
    description:
        'Flutter is a framework for building native Android and iOS applications for Google\'s mobile platforms.',
    image:
        'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  ),
  Hashtag(
    name: 'firebase',
    weight: 3,
    description:
        'Firebase is a cloud platform for building mobile and web apps.',
    image:
        'https://firebase.google.com/static/downloads/brand-guidelines/PNG/logo-logomark.png',
  ),
  Hashtag(
    name: 'google',
    weight: 4,
    description:
        'Google is a company that builds products and services for the world\'s users.',
    image: 'https://dwglogo.com/wp-content/uploads/2016/06/G-icon-1068x735.png',
  ),
  Hashtag(
    name: 'apple',
    weight: 5,
    description:
        'Apple is a company that builds products and services for the world\'s users.',
    image:
        'https://dwglogo.com/wp-content/uploads/2016/02/Apple_logo-1068x601.png',
  ),
  Hashtag(
    name: 'microsoft',
    weight: 6,
    description:
        'Microsoft is a company that builds products and services for the world\'s users.',
    image:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/2048px-Microsoft_logo.svg.png',
  ),
  Hashtag(
    name: 'facebook',
    weight: 7,
    description:
        'Facebook is a company that builds products and services for the world\'s users.',
    image: 'https://www.facebook.com/images/fb_icon_325x325.png',
  ),
  Hashtag(
    name: 'twitter',
    weight: 8,
    description:
        'Twitter is a company that builds products and services for the world\'s users.',
    image:
        'https://dwglogo.com/wp-content/uploads/2019/02/Twitter_logo-1024x705.png',
  ),
  Hashtag(
    name: 'instagram',
    weight: 9,
    description:
        'Instagram is a company that builds products and services for the world\'s users.',
    image:
        'https://w7.pngwing.com/pngs/648/943/png-transparent-instagram-logo-logo-instagram-computer-icons-camera-instagram-logo-text-trademark-magenta.png',
  ),
  Hashtag(
    name: 'snapchat',
    weight: 10,
    description:
        'Snapchat is a company that builds products and services for the world\'s users.',
    image:
        'https://dwglogo.com/wp-content/uploads/2016/06/dotted_logo_of_snapchat-1068x601.png',
  ),
  Hashtag(
    name: 'youtube',
    weight: 11,
    description:
        'YouTube is a company that builds products and services for the world\'s users.',
    image:
        'https://dwglogo.com/wp-content/uploads/2020/05/1200px-YouTube_logo-1024x729.png',
  ),
];

const kEmojis = <Emoji>[
  Emoji(
    char: '😀',
    shortName: ':grinning:',
    unicode: '1f600',
  ),
  Emoji(
    char: '😂',
    shortName: ':joy:',
    unicode: '1f602',
  ),
  Emoji(
    char: '😃',
    shortName: ':smiley:',
    unicode: '1f603',
  ),
  Emoji(
    char: '😄',
    shortName: ':smile:',
    unicode: '1f604',
  ),
  Emoji(
    char: '😅',
    shortName: ':sweat_smile:',
    unicode: '1f605',
  ),
  Emoji(
    char: '😆',
    shortName: ':laughing:',
    unicode: '1f606',
  ),
  Emoji(
    char: '😇',
    shortName: ':wink:',
    unicode: '1f609',
  ),
  Emoji(
    char: '😈',
    shortName: ':smirk:',
    unicode: '1f60f',
  ),
  Emoji(
    char: '😉',
    shortName: ':wink2:',
    unicode: '1f609',
  ),
  Emoji(
    char: '😊',
    shortName: ':blush:',
    unicode: '1f60a',
  ),
  Emoji(
    char: '😋',
    shortName: ':yum:',
    unicode: '1f60b',
  ),
  Emoji(
    char: '😌',
    shortName: ':relieved:',
    unicode: '1f60c',
  ),
  Emoji(
    char: '😍',
    shortName: ':heart_eyes:',
    unicode: '1f60d',
  ),
];

final sampleGroupConversation = [
  ChatMessage(
    text: 'Hey there! What\'s up?',
    createdAt: DateTime.now().subtract(const Duration(seconds: 1)),
    sender: sahil,
  ),
  ChatMessage(
    text: 'Nothing. Just chilling and watching YouTube. What about you?',
    createdAt: DateTime.now().subtract(const Duration(seconds: 2)),
    sender: avni,
  ),
  ChatMessage(
    text: 'Yeah I know. I\'m in the same position 😂',
    createdAt: DateTime.now().subtract(const Duration(seconds: 3)),
    sender: sahil,
  ),
  ChatMessage(
    text: 'I\'m just trying to get some sleep',
    createdAt: DateTime.now().subtract(const Duration(seconds: 4)),
    sender: gaurav,
  ),
  ChatMessage(
    text:
        'Same here! Been watching YouTube for the past 5 hours despite of having so much to do! 😅',
    createdAt: DateTime.now().subtract(const Duration(seconds: 5)),
    sender: trapti,
  ),
  ChatMessage(
    text: 'It\'s hard to be productive',
    createdAt: DateTime.now().subtract(const Duration(seconds: 6)),
    sender: avni,
  ),
];
