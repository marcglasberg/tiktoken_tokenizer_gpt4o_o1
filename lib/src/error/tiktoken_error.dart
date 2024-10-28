/// An error raised by Tiktoken.
class TiktokenError extends Error {
  TiktokenError(this.message);

  final String message;

  @override
  String toString() => "TiktokenError: $message";
}
