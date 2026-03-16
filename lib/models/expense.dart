import 'package:flutter/material.dart';

enum Category {food, travel, shopping, bills }

const categoryIcons ={
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight,
  Category.shopping: Icons.shopping_cart,
  Category.bills: Icons.receipt,
} ;

class Expense{
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
});
}