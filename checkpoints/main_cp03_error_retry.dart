// Lab 06, S09: 이미지 오류 분리
// 목표: 데이터 요청 실패와 이미지 표시 실패를 구분한다.
// 직전 단계 편집 후: Hot Reload. 다른 파일을 -t로 실행할 때는 앱을 중지하고 다시 실행한다.

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
  List<Recipe> recipes = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final response = await http.get(
        Uri.parse(
          'https://dummyjson.com/recipes?limit=5'
          '&select=name,image,ingredients,instructions',
        ),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['recipes'] as List<dynamic>;
      final loadedRecipes = items.map((item) {
        return Recipe.fromJson(item as Map<String, dynamic>);
      }).toList();
      if (!mounted) return;
      setState(() {
        recipes = loadedRecipes;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorMessage = '레시피를 불러오지 못했습니다.\n'
            '네트워크 연결과 서버 응답을 확인한 뒤 다시 시도하세요.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _openRecipe(Recipe recipe) async {
    final selectedRecipe = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute<Recipe>(
        builder: (context) => RecipeDetailPage(recipe: recipe),
      ),
    );
    if (!mounted || selectedRecipe == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${selectedRecipe.name} 레시피를 선택했습니다.')),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadRecipes,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    if (recipes.isEmpty) {
      return const Center(child: Text('표시할 레시피가 없습니다.'));
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: recipes.map((recipe) {
        return Card(
          child: ListTile(
            leading: Image.network(
              recipe.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.broken_image_outlined),
                );
              },
            ),
            title: Text(recipe.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openRecipe(recipe),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('레시피 목록')),
      body: _buildBody(),
    );
  }
}

class Recipe {
  final String name;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.name,
    required this.image,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] as String,
      image: json['image'] as String,
      ingredients: List<String>.from(json['ingredients'] as List<dynamic>),
      instructions: List<String>.from(json['instructions'] as List<dynamic>),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('레시피 상세')),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => Navigator.pop<Recipe>(context, recipe),
          child: const Text('이 레시피 선택'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            recipe.image,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 220,
                child: Center(child: Text('이미지를 불러올 수 없습니다.')),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Text('재료', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final ingredient in recipe.ingredients)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('- $ingredient'),
            ),
          const SizedBox(height: 16),
          Text('조리 순서', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (int index = 0; index < recipe.instructions.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('${index + 1}. ${recipe.instructions[index]}'),
            ),
        ],
      ),
    );
  }
}
