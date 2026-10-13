// Lab 06, S03: 이미지 표시
// 목표: image 필드와 Image.network로 단일 레시피의 사진을 표시한다.
// 직전 단계 편집 후: Hot Restart. 다른 파일을 -t로 실행할 때는 앱을 중지하고 다시 실행한다.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  Recipe? recipe;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/recipes/1'),
      );

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final loadedRecipe = Recipe.fromJson(data);
      if (!mounted) return;
      setState(() {
        recipe = loadedRecipe;
      });
    } catch (error) {
      // 이 단계는 콘솔로 실패를 확인한다. 오류 화면과 재시도는 S08에서 추가한다.
      debugPrint('레시피 요청 실패: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRecipe = recipe;
    return Scaffold(
      appBar: AppBar(title: const Text('레시피 목록')),
      body: currentRecipe == null
          ? const Center(child: Text('레시피를 불러오는 중입니다.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Image.network(
                  currentRecipe.image,
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                Text(
                  currentRecipe.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
    );
  }
}

class Recipe {
  final String name;
  final String image;

  const Recipe({required this.name, required this.image});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}
