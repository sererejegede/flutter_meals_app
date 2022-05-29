import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dummy_data.dart';
import '../models/meal.dart';

class Meals with ChangeNotifier {
  final _url = Uri.parse(
      'https://flutter-meal-app-2aee0-default-rtdb.firebaseio.com/meals.json');
  List<Meal> _meals = [];

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

  Future<void> updateMeal(Map<String, dynamic> meal, String mealId) {
    final body = json.encode(meal);
    final url = Uri.parse(
        'https://flutter-meal-app-2aee0-default-rtdb.firebaseio.com/meals/$mealId.json');
    return http.patch(url, body: body).then((value) {
      print(json.decode(value.body));
      // final mealId = json.decode(value.body)['name'] as String;
      // meal['id'] = mealId;
      // var newMeal = Meal.fromJson(meal);
      // _meals.add(newMeal);
    }).catchError((e) => throw e);
  }

  Future<void> getAllMeals() {
    return http.get(_url).then((value) {
      final responseMap = json.decode(value.body) as Map<String, dynamic>;
      _meals = responseMap.entries.map((e) {
        e.value['id'] = e.key;
        return Meal.fromJson(e.value);
      }).toList();
      notifyListeners();
    });
  }

  Future<void> saveAllMeals() async {
    for (var meal in dummyMeals) {
      await addMeal(meal.toMap).then((value) {
        // print('saved ${meal.title}');
      });
    }
  }
}
