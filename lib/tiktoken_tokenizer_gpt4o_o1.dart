import 'dart:typed_data';

import 'src/core_bpe_constructor.dart';
import 'src/tiktoken_encoder.dart';

export 'src/common/special_tokens_set.dart';
export 'src/tiktoken_encoder.dart';
export 'src/word_counter.dart';

/// Supported Tiktoken encodings.
enum TiktokenEncodingType {
  //
  // Encoder for Gpt-4.
  cl100k_base,
  //
  // Encoder for Gpt-4o, ChatGpt-4o, Gpt-4o-mini and o1, o1-mini and o1-preview.
  o200k_base;

  /// Returns the model from the given [name].
  /// For example: `TiktokenEncodingType.from('cl100k_base')`
  /// returns [TiktokenEncodingType.cl100k_base].
  factory TiktokenEncodingType.from(String name) {
    for (var encType in TiktokenEncodingType.values) {
      if (encType.name == name) {
        return encType;
      }
    }
    throw ArgumentError('Unknown encoding type: $name');
  }

  /// Returns the encoding type from the given [json].
  factory TiktokenEncodingType.fromJson(Map<String, Object?> json) =>
      TiktokenEncodingType.from(json['name'] as String);

  /// Returns the encoding type as a json object.
  Map<String, Object?> toJson() => {'name': name};
}

/// Supported OpenAI models.
enum OpenAiModel {
  gpt_4(TiktokenEncodingType.cl100k_base),
  gpt_4o(TiktokenEncodingType.o200k_base),
  chatgpt_4o(TiktokenEncodingType.o200k_base),
  gpt_4o_mini(TiktokenEncodingType.o200k_base),
  o1(TiktokenEncodingType.o200k_base),
  o1_mini(TiktokenEncodingType.o200k_base),
  o1_preview(TiktokenEncodingType.o200k_base);

  final TiktokenEncodingType encoding;

  const OpenAiModel(this.encoding);

  /// Returns the model from the given [name].
  /// For example: `OpenAiModel.from('gpt_4')` returns [OpenAiModel.gpt_4].
  factory OpenAiModel.from(String name) {
    for (var model in OpenAiModel.values) {
      if (model.name == name) {
        return model;
      }
    }
    throw ArgumentError('Unknown model: $name');
  }

  /// Returns the model from the given [json].
  factory OpenAiModel.fromJson(Map<String, Object?> json) =>
      OpenAiModel.from(json['name'] as String);

  /// Returns the model as a json object.
  Map<String, Object?> toJson() => {'name': name};
}

/// Will encode, decode, and calculate the number of tokens in a text string.
///
/// It implements the Tiktoken tokeniser,
/// a [BPE](https://en.wikipedia.org/wiki/Byte_pair_encoding) used by OpenAI's models.
///
/// The supported models are:
///
/// - Gpt-4
/// - Gpt-4o
/// - Gpt-4o-mini
/// - o1
/// - o1-mini
/// - o1-preview
///
/// Splitting text strings into tokens is useful because GPT models see text in the form
/// of tokens. Knowing how many tokens are in a text string can tell you whether:
///
/// - Some text is too long for a text model to process.
/// - How much an OpenAI API call costs (as usage is priced by token).
///
/// Note different models use different encodings. See [TiktokenEncodingType]
///
/// Example usage of [encode], [decode] and [count] methods:
///
/// ```dart
/// var tiktoken = Tiktoken(OpenAiModel.gpt_4);
/// var encoded = tiktoken.encode("hello world");
/// var decoded = tiktoken.decode(encoded);
/// int numberOfTokens = tiktoken.count("hello world");
/// ```
///
/// Alternatively, you can use the static helper functions [getEncoder]
/// and [getEncoderForModel] to get a [TiktokenEncoder] first:
///
/// ```dart
/// var encoder = Tiktoken.getEncoder(TiktokenEncodingType.o200k_base);
/// var encoder = Tiktoken.getEncoderForModel(OpenAiModel.gpt_4o);
/// ```
/// Note the [TiktokenEncoder] gives you more fine-grained control over the encoding
/// process.
///
/// Visit the online Tiktokenizer:
/// https://tiktokenizer.vercel.app/?model=gpt-4o
///
class Tiktoken {
  static final _CACHE = <TiktokenEncodingType, TiktokenEncoder>{};

  final OpenAiModel model;

  Tiktoken(this.model);

  Uint32List encode(String text) {
    final encoder = Tiktoken.getEncoderForModel(model);
    return encoder.encode(text);
  }

  String decode(Uint32List encoded) {
    final encoder = Tiktoken.getEncoderForModel(model);
    return encoder.decode(encoded);
  }

  int count(String text) => encode(text).length;

  /// Returns the tiktoken encoding used by a model.
  static TiktokenEncoder getEncoderForModel(OpenAiModel model) =>
      getEncoder(model.encoding);

  /// Returns the tiktoken encoding for the given [encodingType].
  static TiktokenEncoder getEncoder(TiktokenEncodingType encodingType) {
    if (_CACHE.containsKey(encodingType)) {
      return _CACHE[encodingType]!;
    }

    CoreBPEConstructor constructor = switch (encodingType) {
      TiktokenEncodingType.cl100k_base => CoreBPEConstructor.cl100kBase(),
      TiktokenEncodingType.o200k_base => CoreBPEConstructor.o200kBase(),
    };

    final enc = TiktokenEncoder(
      name: constructor.name,
      patternStr: constructor.patternStr,
      mergeableRanks: constructor.mergeableRanks,
      explicitNVocab: constructor.explicitNVocab,
      specialTokens: constructor.specialTokens,
    );

    _CACHE[encodingType] = enc;

    return enc;
  }
}
