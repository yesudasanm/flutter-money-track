import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import'../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

 const ExpenseChart({super.key, required this.expenses});

 double getTotal(Category category) {
   double total =0;

   for(var expense in expenses) {
     if(expense.category==category) {
       total+=expense.amount;
     }
   }
   return total;
 }
 @override
  Widget build(BuildContext context) {
   final foodTotal = getTotal(Category.food);
   final travelTotal = getTotal(Category.travel);
   final shoppingTotal =getTotal(Category.shopping);
   final billsTotal = getTotal(Category.bills);

   return SizedBox(
     height: 220,
     child: BarChart(
       BarChartData(
         titlesData: FlTitlesData(
         bottomTitles: AxisTitles(
         sideTitles: SideTitles(
         showTitles: true,
           getTitlesWidget: (value, meta){
           switch(value.toInt()){
             case 0:
               return const Text("Food");
             case 1:
               return const Text("Travel");
             case 2:
               return const Text("shopping");
             case 3:
               return const Text("Bills");
             default:
               return const Text(" ");
             }
            },
         ),
         ),
        ),
           barGroups: [
             BarChartGroupData(
           x: 0,
         barRods: [BarChartRodData(
             toY:foodTotal,
             color: Colors.blue,
             width: 18,
         ),
         ],
       ),
         BarChartGroupData(
           x: 1,
           barRods: [BarChartRodData(
               toY:travelTotal,
                color:Colors.grey,
                width: 18,
           ),
           ],
         ),
       BarChartGroupData(
           x: 2,
           barRods: [BarChartRodData(
               toY:shoppingTotal,
             color: Colors.purple,
             width:18,
           ),
           ],
       ),
       BarChartGroupData(
         x: 3,
         barRods: [BarChartRodData(
             toY:billsTotal,
              color: Colors.green,
           width :18,
         ),
         ],
       ),
       ],
     ),
     ),
   );
 }
}