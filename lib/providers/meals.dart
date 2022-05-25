import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/meal.dart';

class Meals with ChangeNotifier {
  final _url = Uri.parse(
      'https://flutter-meal-app-2aee0-default-rtdb.firebaseio.com/meals.json');
  final List<Meal> _meals = [];

  List<Meal> get meals {
    return [..._meals];
  }

  Future<void> addMeal(Map<String, dynamic> meal) {
    final body = json.encode(meal);
    return http.post(_url, body: body).then((value) {
      final mealId = json.decode(value.body)['name'] as String;
      meal['id'] = mealId;
      var newMeal = Meal.fromJson(meal);
      _meals.add(newMeal);
    }).catchError((e) => throw e);
  }
}
