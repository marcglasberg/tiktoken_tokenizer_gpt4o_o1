import 'package:characters/characters.dart';

/// Counts the number of words of some text.
/// This only works well for languages that use the Latin script.
///
class WordCounter {
  //
  static const punctuationChars = {
    // All Unicode space variations
    ' ', // Regular space (U+0020)
    '\u00A0', // Non-breaking space
    '\u1680', // Ogham space mark
    '\u2000', // En quad
    '\u2001', // Em quad
    '\u2002', // En space
    '\u2003', // Em space
    '\u2004', // Three-per-em space
    '\u2005', // Four-per-em space
    '\u2006', // Six-per-em space
    '\u2007', // Figure space
    '\u2008', // Punctuation space
    '\u2009', // Thin space
    '\u200A', // Hair space
    '\u200B', // Zero width space
    '\u202F', // Narrow no-break space
    '\u205F', // Medium mathematical space
    '\u3000', // Ideographic space

    // Other whitespace characters
    '\t', '\n', '\r', '\f', '\v', // Tab, newline, return, form feed, vertical tab

    // All types of quotes
    '"', // Regular straight double quote
    "'", // Regular straight single quote
    '\u2018', // Left single quotation mark '
    '\u2019', // Right single quotation mark '
    '\u201A', // Single low-9 quotation mark ‚
    '\u201B', // Single high-reversed-9 quotation mark ‛
    '\u201C', // Left double quotation mark "
    '\u201D', // Right double quotation mark "
    '\u201E', // Double low-9 quotation mark „
    '\u201F', // Double high-reversed-9 quotation mark ‟
    '\u2039', // Single left-pointing angle quotation mark ‹
    '\u203A', // Single right-pointing angle quotation mark ›
    '\u00AB', // Left-pointing double angle quotation mark «
    '\u00BB', // Right-pointing double angle quotation mark »
    '`', // Backtick
    '\u2032', // Prime ′
    '\u2033', // Double prime ″
    '\u2034', // Triple prime ‴
    '\u2035', // Reversed prime ‵
    '\u2036', // Reversed double prime ‶
    '\u2037', // Reversed triple prime ‷

    // Dashes and hyphens
    '-', // Hyphen-minus
    '\u2010', // Hyphen
    '\u2011', // Non-breaking hyphen
    '\u2012', // Figure dash
    '\u2013', // En dash
    '\u2014', // Em dash
    '\u2015', // Horizontal bar
    '\u2212', // Minus sign

    // Other punctuation
    '.', ',', '!', '?', ';', ':', // Basic punctuation
    '(', ')', '[', ']', '{', '}', '<', '>', // Brackets
    '/', '\\', '|', // Slashes
    '@', '#', '\$', '%', '^', '&', '*', '+', '=', // Special characters
    '·', '•', '°', '§', '¶', // Additional symbols
    '…', // Ellipsis
    '‽', // Interrobang
    '※', // Reference mark
    '†', '‡', // Dagger, double dagger
    '‰', '‱', // Per mille, per ten thousand

    // CJK punctuation
    '。', '，', '、', '；', '：', '？', '！', // CJK punctuation
    '「', '」', '『', '』', '【', '】', // CJK brackets
    '〈', '〉', '《', '》', '〔', '〕', '〖', '〗', // Additional CJK brackets
    '〃', '々', // Iteration marks
    '・', // Katakana middle dot
  };

  int count(String text) {
    int wordCount = 0;
    bool lastCharWasPunctuation =
        true; // Start as true to count first word if it starts with normal char

    // Iterate through each character using String.characters for proper Unicode support
    for (final char in text.characters) {
      bool isCurrentCharPunctuation = punctuationChars.contains(char);

      // Count a word when we transition from punctuation to normal character
      if (!isCurrentCharPunctuation && lastCharWasPunctuation) {
        wordCount++;
      }

      lastCharWasPunctuation = isCurrentCharPunctuation;
    }

    return wordCount;
  }
}
