import 'package:flutter/material.dart';
import 'package:tiktoken_tokenizer_gpt4o_o1/tiktoken_tokenizer_gpt4o_o1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List gpt4Tokens = [];
  List gpt4oTokens = [];

  int gpt4TokenCount = 0;
  int gpt4oTokenCount = 0;

  void _updateTokens(String text) {
    setState(() {
      var tiktokenGpt4 = Tiktoken(OpenAiModel.gpt_4);
      var tiktokenGpt4o = Tiktoken(OpenAiModel.gpt_4o);
      
      gpt4Tokens = tiktokenGpt4.encode(text);
      gpt4oTokens = tiktokenGpt4o.encode(text);

      gpt4TokenCount = tiktokenGpt4.count(text);
      gpt4oTokenCount = tiktokenGpt4o.count(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiktoken Tokenizer'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: _updateTokens,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$gpt4TokenCount GPT-4 tokens:\n$gpt4Tokens',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(
              '$gpt4oTokenCount GPT-4o tokens:\n$gpt4oTokens',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
