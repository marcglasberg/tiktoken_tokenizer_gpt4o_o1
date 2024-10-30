// ignore_for_file: unused_element

import 'dart:convert';

import 'package:tiktoken_tokenizer_gpt4o_o1/src/ranks/o200k_base/o200k_base_11.dart';

import 'common/byte_array.dart';
import 'ranks/cl100k_base/cl100k_base_1.g.dart';
import 'ranks/cl100k_base/cl100k_base_10.g.dart';
import 'ranks/cl100k_base/cl100k_base_11.g.dart';
import 'ranks/cl100k_base/cl100k_base_2.g.dart';
import 'ranks/cl100k_base/cl100k_base_3.g.dart';
import 'ranks/cl100k_base/cl100k_base_4.g.dart';
import 'ranks/cl100k_base/cl100k_base_5.g.dart';
import 'ranks/cl100k_base/cl100k_base_6.g.dart';
import 'ranks/cl100k_base/cl100k_base_7.g.dart';
import 'ranks/cl100k_base/cl100k_base_8.g.dart';
import 'ranks/cl100k_base/cl100k_base_9.g.dart';
import 'ranks/o200k_base/o200k_base_1.dart';
import 'ranks/o200k_base/o200k_base_10.dart';
import 'ranks/o200k_base/o200k_base_12.dart';
import 'ranks/o200k_base/o200k_base_13.dart';
import 'ranks/o200k_base/o200k_base_14.dart';
import 'ranks/o200k_base/o200k_base_15.dart';
import 'ranks/o200k_base/o200k_base_16.dart';
import 'ranks/o200k_base/o200k_base_17.dart';
import 'ranks/o200k_base/o200k_base_18.dart';
import 'ranks/o200k_base/o200k_base_19.dart';
import 'ranks/o200k_base/o200k_base_2.dart';
import 'ranks/o200k_base/o200k_base_20.dart';
import 'ranks/o200k_base/o200k_base_3.dart';
import 'ranks/o200k_base/o200k_base_4.dart';
import 'ranks/o200k_base/o200k_base_5.dart';
import 'ranks/o200k_base/o200k_base_6.dart';
import 'ranks/o200k_base/o200k_base_7.dart';
import 'ranks/o200k_base/o200k_base_8.dart';
import 'ranks/o200k_base/o200k_base_9.dart';

const END_OF_TEXT = "<|endoftext|>";
const FIM_PREFIX = "<|fim_prefix|>";
const FIM_MIDDLE = "<|fim_middle|>";
const FIM_SUFFIX = "<|fim_suffix|>";
const END_OF_PROMPT = "<|endofprompt|>";

class CoreBPEConstructor {
  const CoreBPEConstructor._({
    required this.name,
    required this.patternStr,
    required this.mergeableRanks,
    required this.specialTokens,
    this.explicitNVocab,
  });

  static final Map<String, int> _cl100kBase = {};
  static final Map<String, int> _o200kBase = {};

  /// This is the original Python regex:
  /// r"""'(?i:[sdmt]|ll|ve|re)|[^\r\n\p{L}\p{N}]?+\p{L}++|\p{N}{1,3}+| ?[^\s\p{L}\p{N}]++[\r\n]*+|\s++$|\s*[\r\n]|\s+(?!\S)|\s"""
  ///
  /// We cannot replicate this exactly in Dart because the Dart regex engine
  /// (based on JavaScript's regex engine) does not support possessive quantifiers,
  /// like, for example, `*+`, `++` etc. However, Clause thinks it doesn't make any
  /// difference, because: `Even though \p{L}+ can backtrack, there's nothing "competing"
  /// for those letters after it in the pattern. The pattern just says: - Optionally
  /// match one non-letter/non-number. - Then match as many letters as possible. There's
  /// no condition after the letters that would make us want to backtrack and match them
  /// differently. Whether it's possessive \p{L}++ or regular \p{L}+, it will always grab
  /// all the consecutive letters it can find because that's the only way to make a valid
  /// match. This is different from patterns like \w+\d+ vs \w++\d+ trying to
  /// match "abc123", where backtracking might matter because both \w and \d could match
  /// numbers. In our tiktoken regex, each part of the pattern matches mutually exclusive
  /// character types`.
  static const cl100kBase1_Regex =
      r"('s|'S|'t|'T|'re|'RE|'rE|'Re|'ve|'VE|'vE|'Ve|'m|'M|'ll|'LL|'Ll|'lL|'d|'D)"
      r"|[^\r\n\p{L}\p{N}]?\p{L}+|\p{N}{1,3}| ?[^\s\p{L}\p{N}]+[\r\n]*|\s*[\r\n]+|\s+(?!\S)|\s+";

  /// This is the original Python regex:
  /// "|".join(
  ///   [r"""[^\r\n\p{L}\p{N}]?[\p{Lu}\p{Lt}\p{Lm}\p{Lo}\p{M}]*[\p{Ll}\p{Lm}\p{Lo}\p{M}]+(?i:'s|'t|'re|'ve|'m|'ll|'d)?""",
  ///   r"""[^\r\n\p{L}\p{N}]?[\p{Lu}\p{Lt}\p{Lm}\p{Lo}\p{M}]+[\p{Ll}\p{Lm}\p{Lo}\p{M}]*(?i:'s|'t|'re|'ve|'m|'ll|'d)?""",
  ///   r"""\p{N}{1,3}""",
  ///   r""" ?[^\s\p{L}\p{N}]+[\r\n/]*""",
  ///   r"""\s*[\r\n]+""",
  ///   r"""\s+(?!\S)""",
  ///   r"""\s+""", ]
  static const o200kBase_Regex =
      // Match optional non-letter/number character, followed by uppercase or
      // titlecase letters and ending in lowercase letters or marks. Optionally match
      // contractions ('s, 've, etc.) in both lower and uppercase forms.
      r"[^\r\n\p{L}\p{N}]?[\p{Lu}\p{Lt}\p{Lm}\p{Lo}\p{M}]*[\p{Ll}\p{Lm}\p{Lo}\p{M}]+('s|'S|'t|'T|'re|'RE|'rE|'Re|'ve|'VE|'vE|'Ve|'m|'M|'ll|'LL|'Ll|'lL|'d|'D)?"
      r"|"

      // Same as the previous line but ensures that the first letter(s) of the word is
      // uppercase or titlecase and optionally followed by lowercase letters or marks.
      r"[^\r\n\p{L}\p{N}]?[\p{Lu}\p{Lt}\p{Lm}\p{Lo}\p{M}]+[\p{Ll}\p{Lm}\p{Lo}\p{M}]*('s|'S|'t|'T|'re|'RE|'rE|'Re|'ve|'VE|'vE|'Ve|'m|'M|'ll|'LL|'Ll|'lL|'d|'D)?"
      r"|"

      // Match 1 to 3 digit numbers.
      r"\p{N}{1,3}"
      r"|"

      // Match an optional space followed by one or more non-whitespace, non-letter,
      // non-number characters, then zero or more newline characters or slashes.
      r" ?[^\s\p{L}\p{N}]+[\r\n/]*"
      r"|"

      // Match zero or more whitespace characters followed by one or more newline
      // characters.
      r"\s*[\r\n]+"
      r"|"

      // Match one or more whitespace characters that are not followed by a
      // non-whitespace character (i.e., trailing spaces).
      r"\s+(?!\S)"
      r"|"

      // Match one or more whitespace characters.
      r"\s+";

  /// Taken from:
  /// https://github.com/openai/tiktoken/blob/main/tiktoken_ext/openai_public.py
  ///
  /// The maps [cl100kBase1], [cl100kBase2] etc where generated from
  /// "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken",
  /// using the PowerShell commands explained in the README.md.
  ///
  factory CoreBPEConstructor.cl100kBase() {
    //
    if (_cl100kBase.isEmpty) {
      _cl100kBase.addAll(cl100kBase1);
      _cl100kBase.addAll(cl100kBase2);
      _cl100kBase.addAll(cl100kBase3);
      _cl100kBase.addAll(cl100kBase4);
      _cl100kBase.addAll(cl100kBase5);
      _cl100kBase.addAll(cl100kBase6);
      _cl100kBase.addAll(cl100kBase7);
      _cl100kBase.addAll(cl100kBase8);
      _cl100kBase.addAll(cl100kBase9);
      _cl100kBase.addAll(cl100kBase10);
      _cl100kBase.addAll(cl100kBase11);
    }

    assert(_cl100kBase.length == 100256);

    return CoreBPEConstructor._(
      name: 'cl100k_base',
      patternStr: cl100kBase1_Regex,
      mergeableRanks: _cl100kBase.map(
        (k, v) => MapEntry(ByteArray.fromList(base64Decode(k)), v),
      ),
      specialTokens: {
        END_OF_TEXT: 100257,
        FIM_PREFIX: 100258,
        FIM_MIDDLE: 100259,
        FIM_SUFFIX: 100260,
        END_OF_PROMPT: 100276,
      },
    );
  }

  /// Taken from:
  /// https://github.com/openai/tiktoken/blob/main/tiktoken_ext/openai_public.py
  ///
  /// The map [o200kBase1], [o200kBase2] etc where generated from
  /// "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken",
  /// using the PowerShell commands explained in the README.md.
  ///
  factory CoreBPEConstructor.o200kBase() {
    //
    if (_o200kBase.isEmpty) {
      _o200kBase.addAll(o200kBase1);
      _o200kBase.addAll(o200kBase2);
      _o200kBase.addAll(o200kBase3);
      _o200kBase.addAll(o200kBase4);
      _o200kBase.addAll(o200kBase5);
      _o200kBase.addAll(o200kBase6);
      _o200kBase.addAll(o200kBase7);
      _o200kBase.addAll(o200kBase8);
      _o200kBase.addAll(o200kBase9);
      _o200kBase.addAll(o200kBase10);
      _o200kBase.addAll(o200kBase11);
      _o200kBase.addAll(o200kBase12);
      _o200kBase.addAll(o200kBase13);
      _o200kBase.addAll(o200kBase14);
      _o200kBase.addAll(o200kBase15);
      _o200kBase.addAll(o200kBase16);
      _o200kBase.addAll(o200kBase17);
      _o200kBase.addAll(o200kBase18);
      _o200kBase.addAll(o200kBase19);
      _o200kBase.addAll(o200kBase20);
    }

    assert(_o200kBase.length == 199998);

    return CoreBPEConstructor._(
      name: 'o200k_base',
      patternStr: o200kBase_Regex,
      mergeableRanks: _o200kBase.map(
        (k, v) => MapEntry(ByteArray.fromList(base64Decode(k)), v),
      ),
      specialTokens: {
        END_OF_TEXT: 199999,
        END_OF_PROMPT: 200018,
      },
    );
  }

  final String name;
  final String patternStr;
  final Map<ByteArray, int> mergeableRanks;
  final Map<String, int> specialTokens;
  final int? explicitNVocab;
}
