import 'package:flutter_test/flutter_test.dart';
import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

void main() {
  group('TiktokenEncodingType', () {
    //
    test('toJson and fromJson', () {
      expect(TiktokenEncodingType.fromJson({'name': 'cl100k_base'}),
          equals(TiktokenEncodingType.cl100k_base));

      expect(TiktokenEncodingType.fromJson({'name': 'o200k_base'}),
          equals(TiktokenEncodingType.o200k_base));

      for (var type in TiktokenEncodingType.values) {
        var json = type.toJson();
        var fromJson = TiktokenEncodingType.fromJson(json);
        expect(fromJson, equals(type));
      }
    });

    test('from and toString', () {
      for (var type in TiktokenEncodingType.values) {
        var fromString = TiktokenEncodingType.from(type.name);
        expect(fromString, equals(type));
      }
    });
  });

  group('OpenAiModel', () {
    test('toJson and fromJson', () {
      expect(OpenAiModel.fromJson({'name': 'gpt_4'}), equals(OpenAiModel.gpt_4));

      expect(OpenAiModel.fromJson({'name': 'gpt_4o'}), equals(OpenAiModel.gpt_4o));

      for (var model in OpenAiModel.values) {
        var json = model.toJson();
        var fromJson = OpenAiModel.fromJson(json);
        expect(fromJson, equals(model));
      }
    });

    test('from and toString', () {
      for (var model in OpenAiModel.values) {
        var fromString = OpenAiModel.from(model.name);
        expect(fromString, equals(model));
      }
    });
  });
}
