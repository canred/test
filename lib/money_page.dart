import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;

class MoneyPage extends StatefulWidget {
  const MoneyPage({Key? key}) : super(key: key);

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  String money = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchMoney();
  }

  Future<void> fetchMoney() async {
    final response = await http.get(Uri.parse('https://www.cnyes.com/twstock/5347'));
    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final priceElement = document.querySelector('.price'); // 假設價格在 class 為 'stock-price' 的元素中

      setState(() {
        money = priceElement?.text ?? 'Failed to parse';
      });
    } else {
      setState(() {
        money = 'Failed to load';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Azure Entra Id Login'),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Text(
          '目前世界先進的股價：$money',
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
