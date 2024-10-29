# Tiktoken

This is a partial Dart port from the
original [tiktoken](https://github.com/openai/tiktoken) library from OpenAI,
written in Rust/Python.

For these OpenAI models:

* gpt_4
* gpt_4o
* chatgpt_4o
* gpt_4o_mini
* o1
* o1_mini
* o1_preview

What's the Relationship Between Words and Tokens?
Every language has a different word-to-token ratio. Here are a few general rules:

* For English: 1 word is about 1.3 tokens
* For Spanish and French: 1 word is about 2 tokens
* How Many Tokens Are Punctuation Marks, Special Characters, and Emojis?
  Each punctuation mark (like ,:;?!) counts as 1 token. Special characters (like ∝√∅°¬)
  range from 1 to 3 tokens, and emojis (like 😁🙂🤩) range from 2 to 3 tokens.

Based upon: https://pub.dev/packages/langchain_tiktoken
