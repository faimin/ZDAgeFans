import 'package:flutter/material.dart';

class CartoonDetailPage extends StatefulWidget {
  const CartoonDetailPage({super.key});

  @override
  State<CartoonDetailPage> createState() => _CartoonDetailPageState();
}

class _CartoonDetailPageState extends State<CartoonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动漫详情'),
      ),
      body: Center(
        child: Container(
            color: Colors.orange,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("关闭"))),
      ),
    );
  }
}
