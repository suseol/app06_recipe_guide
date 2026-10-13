// Lab 06, S00: 시작 화면
// 목표: 앱의 실행 환경을 확인한다.
// 직전 단계 편집 후: 실행. 다른 파일을 -t로 실행할 때는 앱을 중지하고 다시 실행한다.

import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 06 Recipe',
      home: RecipeListPage(),
    );
  }
}

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('레시피 목록')),
      body: const Center(child: Text('레시피 앱을 시작합니다.')),
    );
  }
}
