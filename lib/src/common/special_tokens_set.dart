import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

/// Convenient and type-safe way to represent and manipulate BPE special tokens.
///
/// See [TiktokenEncoder.encode] for more details on usage of special tokens.
class SpecialTokensSet {
  const SpecialTokensSet.empty() : _val = const {};

  const SpecialTokensSet.all() : _val = const {"all"};

  SpecialTokensSet.custom(Set<String> tokens) : _val = Set.of(tokens);

  final Set<String> _val;

  bool get isAll => _val.length == 1 && _val.first == "all";

  Set<String> get set => _val;
}
