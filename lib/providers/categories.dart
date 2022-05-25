import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];
  final _url = Uri.parse(
      'https://flutter-meal-app-2aee0-default-rtdb.firebaseio.com/categories.json');

  List<Category> get categories {
    return [..._categories];
  }

  Future<void> addCategory(String title, String color) {
    var _body = {'title': title, 'color': color};
    return http.post(_url, body: json.encode(_body)).then((value) {
      final categoryId = json.decode(value.body)['name'] as String;
      final newCategory = Category(
        id: categoryId,
        title: title,
        color: Color(
          int.parse(color),
        ),
      );
      _categories.add(newCategory);
      notifyListeners();
    }).catchError((e) => throw e);
  }

  Future<void> getAllCategories() {
    return http.get(_url).then((value) {
      final responseMap = json.decode(value.body) as Map<String, dynamic>;
      _categories = responseMap.entries
          .map(
            (e) => Category(
              id: e.key,
              title: e.value['title'],
              color: Color(int.parse(e.value['color'])),
            ),
          )
          .toList();
      notifyListeners();
    }).catchError((error) => throw error);
  }
}
