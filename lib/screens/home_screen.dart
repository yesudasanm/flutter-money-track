import 'package:flutter/material.dart';
import '../widgets/expense_chart.dart';
import '../models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/expense_item.dart';

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight,
  Category.shopping: Icons.shopping_cart,
  Category.bills: Icons.receipt,
};
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen>{

  void _openEditExpenseSheet(Expense expense, int index){
    _titleController.text = expense.title;
    _amountController.text =expense.amount.toString();
    _selectedCategory = expense.category;
    _selectedDate = expense.date;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize:MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: (){
                  setState((){
                    _expenses[index] = Expense(
                      title: _titleController.text,
                      amount: double.parse(_amountController.text),
                      date: _selectedDate!,
                      category: _selectedCategory,
                    );
                  });

                  Navigator.of(context).pop();
                },
                child:const Text("Update Expense"),
              )
            ],
        ),
        );
      },
    );
  }

  Future<void>_loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('expenses');
    if(data==null) return;

    final loadedExpenses = data.map((item){
      final decoded = jsonDecode(item);

      return Expense(
        title: decoded['title'],
        amount: decoded['amount'],
        date: DateTime.parse(decoded['date']),
        category: Category.values[decoded['category']],
      );
    }).toList();

    setState(() {
      _expenses.clear();
      _expenses.addAll(loadedExpenses);
    });

  }

  @override
  void initState(){
    super.initState();
    _loadExpenses();
  }

  //Save expenses function
  Future<void> _saveExpenses() async{
    final prefs = await SharedPreferences.getInstance();

    final List<String> expenseList = _expenses.map((expense){
      return jsonEncode({
        'title': expense.title,
        'amount': expense.amount,
        'date' : expense.date.toIso8601String(),
        'category': expense.category.index,
      });
    }).toList();
    prefs.setStringList('expenses',expenseList);
  }
  double getTotalExpense(){
    double total = 0;
    for(var expense in _expenses){
      total += expense.amount;
    }
    return total;
  }
  Category _selectedCategory = Category.food;
  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
    context: context,
    initialDate: now,
    firstDate: DateTime(now.year - 5),
    lastDate:now,
    );
    setState((){
      _selectedDate = pickedDate;
    });
  }
   final List<Expense> _expenses = [];

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
     //TOTAL GETTER
    double get _totalExpense{
      double total=0;
      for (var expense in _expenses){
        total += expense.amount;
      }
      return total;
    }

    void _addExpense(){
      if (_selectedDate == null){
        return;
      }
      final enteredTitle = _titleController.text;
      final enteredAmount = double.tryParse(_amountController.text);
      final newExpense = Expense(
        title:_titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        category: _selectedCategory,
      );

      if(enteredTitle.isEmpty || enteredAmount ==null || enteredAmount<=0) {
        return;
      }
      setState(() {
        _expenses.add(newExpense);

      });
      _saveExpenses();
      _titleController.clear();
      _amountController.clear();
      _selectedDate = null;

      Navigator.of(context).pop();
    }
    //DELETE EXPENSE
    void _deleteExpense(int index){
      setState((){
        _expenses.removeAt(index);
      });
      _saveExpenses();
    }
      //OPEN BOTTOMSHEET
    void _openAddExpenseSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
        return Padding (
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText:"Amount",
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<Category>(
                value:_selectedCategory,
                items: Category.values.map((category) {
                  return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name.toUpperCase()),
                  );
              }).toList(),
              onChanged: (Category? value) {
              setState(() {
                _selectedCategory= value!;
              });
              },
        ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No date selected"
                          : "Date: ${_selectedDate! .day}/${_selectedDate! .month}/${_selectedDate! .year}",
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text("Choose the Date"),
                  )
                ]
              ),
              ElevatedButton(
                onPressed: _addExpense,
                child: const Text("Save Expenses"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Money Track",
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ExpenseChart(expenses: _expenses),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Total:Rs${_totalExpense.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
     //EXPENSE LIST
       Expanded(
       child: _expenses.isEmpty
        ? const Center(
         child: Text("No Expenses yet ! \nStart Adding some." ,
             textAlign: TextAlign.center,
         ),
        )
       : ListView.builder(
           itemCount: _expenses.length,
           itemBuilder: (context ,index) {
       final expense = _expenses[index];

        return Dismissible(
         key: ValueKey(expense),
         onDismissed: (direction) {
          _deleteExpense(index);
         },
         child: ExpenseItem(expense: expense,
         onTap:(){
          _openEditExpenseSheet(expense , index);
         },
         ),
           );
         },
            ),
          ),
          ],

      ),
      //Floating Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseSheet,
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}