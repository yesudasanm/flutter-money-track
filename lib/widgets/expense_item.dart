import'package:flutter/material.dart';
import'../models/expense.dart';

class ExpenseItem extends StatelessWidget{
  final Expense expense;
  final VoidCallback onTap;
  const ExpenseItem({super.key, required this.expense,required this.onTap});

  @override
  Widget build(BuildContext context){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal:10, vertical:5),
      child: ListTile(
        onTap:onTap,
        leading:Icon(categoryIcons[expense.category]),
        title:Text( expense.title),
        subtitle:Text("Rs${expense.date.day}/${expense.date.month}/${expense.date.year}"),

      trailing: Text("Rs${expense.amount.toStringAsFixed(2)}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      ),
    ),
    );
  }
}