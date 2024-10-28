import 'package:flutter_test/flutter_test.dart';
import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

void main() {
  var gpt4 = Tiktoken(OpenAiModel.gpt_4);
  var gpt4o = Tiktoken(OpenAiModel.gpt_4o);
  var wordCounter = WordCounter();

  /// This is compared against the online Tiktokenizer:
  /// https://tiktokenizer.vercel.app/?model=gpt-4o
  group('Tokens', () {
    test('Values taken from the tiktoken test code', () {
      expect(gpt4.encode("rer"), [38149]);
      expect(gpt4.encode("'rer"), [2351, 81]);
      expect(gpt4.encode("today\n "), [31213, 198, 220]);
      expect(gpt4.encode("today\n \n"), [31213, 27907]);
      expect(gpt4.encode("today\n  \n"), [31213, 14211]);
      expect(gpt4.encode("hello world"), [15339, 1917]);
      expect(gpt4.encode("\ud83d\udc4d"), [9468, 239, 235]);
      expect(gpt4.encode("\ud83d"), gpt4.encode("�"));
      expect(gpt4.encode("hello world"), [15339, 1917]);
    });

    test('Encoding some larger texts', () {
      //
      var text = "Hello, Hola, שלום, Привет, 你好, こんにちは, مرحبا, 안녕하세요, "
          "स्वागत हे, γειά σου, नमस्ते, ሰላም, สวัสดี, שלום עליכם, வணக்கம், ਸਤ ਸ੍ਰੀ ਅਕਾਲ, سلام";

      var encodedGpt4 = gpt4.encode(text);
      expect(gpt4.decode(encodedGpt4), text);

      expect(encodedGpt4, [
        9906,
        11,
        473,
        8083,
        11,
        88898,
        50391,
        37769,
        251,
        11,
        80584,
        28089,
        8341,
        11,
        220,
        57668,
        53901,
        11,
        220,
        90115,
        11,
        24252,
        11318,
        30925,
        22071,
        5821,
        11,
        96270,
        75265,
        243,
        92245,
        11,
        69258,
        31584,
        113,
        32511,
        245,
        80338,
        85410,
        35470,
        11,
        63127,
        31243,
        30862,
        75234,
        48823,
        73986,
        11,
        15272,
        101,
        88344,
        79468,
        31584,
        97,
        35470,
        11,
        87189,
        230,
        108,
        157,
        230,
        233,
        157,
        230,
        251,
        11,
        220,
        36748,
        38313,
        24152,
        36748,
        38133,
        29419,
        11,
        88898,
        50391,
        37769,
        251,
        17732,
        95,
        50391,
        43336,
        249,
        147,
        251,
        11,
        71697,
        113,
        20627,
        96,
        20627,
        243,
        64500,
        243,
        20627,
        106,
        47454,
        11,
        70133,
        116,
        40417,
        97,
        70133,
        116,
        66977,
        235,
        40417,
        108,
        66977,
        222,
        70133,
        227,
        40417,
        243,
        40417,
        122,
        40417,
        110,
        11,
        60942,
        8700,
        50488
      ]);

      var encodedGpt4o = gpt4o.encode(text);
      expect(gpt4o.decode(encodedGpt4o), text);

      expect(encodedGpt4o, [
        13225,
        11,
        157464,
        11,
        173283,
        11,
        14917,
        131903,
        11,
        220,
        177519,
        11,
        220,
        95839,
        11,
        60397,
        26537,
        11,
        24497,
        171731,
        11,
        136389,
        40244,
        11,
        8558,
        4969,
        2132,
        79060,
        11,
        100793,
        14681,
        628,
        11,
        220,
        57048,
        108,
        57048,
        233,
        57048,
        251,
        11,
        6152,
        187986,
        21883,
        2293,
        11,
        173283,
        9147,
        148751,
        11,
        5946,
        8670,
        102411,
        11,
        13740,
        12478,
        13740,
        38370,
        6952,
        25586,
        14193,
        32196,
        11,
        66746
      ]);

      // ---

      text = "Amanhã de manhã o avião irá decolar.";

      encodedGpt4 = gpt4.encode(text);
      expect(gpt4.decode(encodedGpt4), text);

      expect(encodedGpt4, [
        32,
        1543,
        71,
        3282,
        409,
        893,
        71,
        3282,
        297,
        1860,
        78428,
        6348,
        1995,
        1654,
        7569,
        13
      ]);

      encodedGpt4o = gpt4o.encode(text);
      expect(gpt4o.decode(encodedGpt4o), text);

      expect(encodedGpt4o,
          [32, 2309, 46160, 334, 53333, 293, 183049, 50869, 334, 173589, 13]);

      // ---

      expect(gpt4o.encode("ä"), [450]);
      expect(gpt4o.encode("häuser"), [106369]);
      expect(gpt4o.encode("Tannhäuser"), [51, 934, 106369]);

      text = "I've seen things you people wouldn't believe. "
          "Attack ships on fire off (the) shoulder of Orion. "
          "I watched C-beams glitter in the dark near the Tannhäuser Gate. "
          "All those moments will be lost in time, like tears in rain. Time to die.";

      encodedGpt4 = gpt4.encode(text);
      expect(gpt4.decode(encodedGpt4), text);

      expect(encodedGpt4, [
        40,
        3077,
        3970,
        2574,
        499,
        1274,
        8434,
        956,
        4510,
        13,
        21453,
        18198,
        389,
        4027,
        1022,
        320,
        1820,
        8,
        17308,
        315,
        69773,
        13,
        358,
        15746,
        356,
        15502,
        4214,
        55251,
        304,
        279,
        6453,
        3221,
        279,
        350,
        1036,
        71,
        2357,
        882,
        30343,
        13,
        2052,
        1884,
        14269,
        690,
        387,
        5675,
        304,
        892,
        11,
        1093,
        24014,
        304,
        11422,
        13,
        4212,
        311,
        2815,
        13
      ]);

      encodedGpt4o = gpt4o.encode(text);
      expect(gpt4o.decode(encodedGpt4o), text);

      expect(encodedGpt4o, [
        30754,
        6177,
        3283,
        481,
        1665,
        24791,
        6423,
        13,
        55008,
        33610,
        402,
        6452,
        1277,
        350,
        3086,
        8,
        28224,
        328,
        124370,
        13,
        357,
        25301,
        363,
        20772,
        2247,
        68780,
        306,
        290,
        8883,
        5862,
        290,
        353,
        934,
        106369,
        47325,
        13,
        2545,
        2617,
        17938,
        738,
        413,
        8803,
        306,
        1058,
        11,
        1299,
        37095,
        306,
        13873,
        13,
        6688,
        316,
        1076,
        13
      ]);
    });

    test('Empty string returns 0 tokens', () {
      expect(gpt4.encode(''), []);
      expect(gpt4.count(''), 0);

      expect(gpt4o.encode(''), []);
      expect(gpt4o.count(''), 0);
    });

    test('Single char 1 tokens', () {
      expect(gpt4.encode('x'), [87]);
      expect(gpt4.count('x'), 1);

      expect(gpt4o.encode('x'), [87]);
      expect(gpt4o.count('x'), 1);
    });

    test('Single word returns 2 tokens', () {
      expect(gpt4.encode('hello'), [15339]);
      expect(gpt4.count('hello'), 1);

      expect(gpt4o.encode('hello'), [24912]);
      expect(gpt4o.count('hello'), 1);
    });

    test('Word with punctuation returns 3 tokens', () {
      expect(gpt4.encode('hello!'), [15339, 0]);
      expect(gpt4.count('hello!'), 2);

      expect(gpt4o.encode('hello!'), [24912, 0]);
      expect(gpt4o.count('hello!'), 2);
    });

    test('Multiple words with spaces return 5 tokens', () {
      expect(gpt4.encode('hello world'), [15339, 1917]);
      expect(gpt4o.count('hello world'), 2);

      expect(gpt4o.encode('hello world'), [24912, 2375]);
      expect(gpt4o.count('hello world'), 2);
    });

    test('Long word returns 9 tokens', () {
      //
      expect(gpt4.encode('supercalifragilisticexpialidocious'),
          [13066, 3035, 278, 333, 4193, 321, 4633, 4683, 532, 307, 78287]);
      expect(gpt4.count('supercalifragilisticexpialidocious'), 11);

      expect(gpt4o.encode('supercalifragilisticexpialidocious'),
          [17789, 5842, 366, 17764, 311, 6207, 8067, 563, 315, 170661]);
      expect(gpt4o.count('supercalifragilisticexpialidocious'), 10);
    });

    test('String with only punctuation returns 10 tokens', () {
      expect(gpt4.encode('!@#\$%^&*()'), [0, 31, 49177, 46999, 5, 9, 368]);
      expect(gpt4.count('!@#\$%^&*()'), 7);

      expect(gpt4o.encode('!@#\$%^&*()'), [0, 31, 108156, 108254, 5, 9, 416]);
      expect(gpt4o.count('!@#\$%^&*()'), 7);
    });

    test('String with numbers returns 5 tokens', () {
      expect(gpt4.encode('12345 67890'), [4513, 1774, 220, 17458, 1954]);
      expect(gpt4.count('12345 67890'), 5);

      expect(gpt4o.encode('12345 67890'), [7633, 2548, 220, 30833, 2744]);
      expect(gpt4o.count('12345 67890'), 5);
    });

    test('String with mixed characters returns 5 tokens', () {
      expect(gpt4.encode('abc123!@#'), [13997, 4513, 0, 31, 2]);
      expect(gpt4.count('abc123!@#'), 5);

      expect(gpt4o.encode('abc123!@#'), [26682, 7633, 0, 31, 2]);
      expect(gpt4o.count('abc123!@#'), 5);
    });

    test('Mixed words and punctuation return 6 tokens', () {
      expect(gpt4.encode('Hello, world!'), [9906, 11, 1917, 0]);
      expect(gpt4.count('Hello, world!'), 4);

      expect(gpt4o.encode('Hello, world!'), [13225, 11, 2375, 0]);
      expect(gpt4o.count('Hello, world!'), 4);
    });
  });

  group('Words', () {
    test('Empty string returns 0 words', () {
      expect(wordCounter.count(''), 0);
    });

    test('Single char 1 word', () {
      expect(wordCounter.count('x'), 1);
    });

    test('Single word returns 1 word', () {
      expect(wordCounter.count('hello'), 1);
    });

    test('Word with punctuation returns 1 word', () {
      expect(wordCounter.count('hello!'), 1);
    });

    test('Multiple words with spaces return 2 words', () {
      expect(wordCounter.count('hello world'), 2);
    });

    test('Long word returns 1 word', () {
      expect(wordCounter.count('supercalifragilisticexpialidocious'), 1);
    });

    test('String with only punctuation returns 0 tokens', () {
      expect(wordCounter.count('!@#\$%^&*()'), 0);
    });

    test('String with numbers returns 2 tokens', () {
      expect(wordCounter.count('12345 67890'), 2);
    });

    test('String with mixed characters returns 1 word', () {
      expect(wordCounter.count('abc123!@#'), 1);
    });

    test('Mixed words and punctuation return 2 tokens', () {
      expect(wordCounter.count('Hello, world!'), 2);
    });
  });
}
