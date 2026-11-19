import 'package:test/test.dart';
import 'package:tiktoken_tokenizer_gpt4o_o1/src/common/byte_array.dart';

void main() {
  test('byte-array equality requires the same length and every byte', () {
    for (final bytes in [<int>[], [1], [0, 127, 255]]) {
      final first = ByteArray.fromList(bytes);
      final second = ByteArray.fromList(bytes);
      expect(first, second);
      expect(first.hashCode, second.hashCode);
      expect({first: 'value'}[second], 'value');
      expect(first == Object(), isFalse);
    }
    expect(ByteArray.fromList([1]) == ByteArray.fromList([1, 2]), isFalse);
    expect(ByteArray.fromList([1, 2]) == ByteArray.fromList([1]), isFalse);
    expect(ByteArray.fromList([]) == ByteArray.fromList([0]), isFalse);
    expect(ByteArray.fromList([1, 2]) == ByteArray.fromList([1, 3]), isFalse);
  });
}
