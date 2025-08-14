import 'package:flutter/material.dart';

void main() {
  runApp(ExpensePlannerApp());
}

class ExpensePlannerApp extends StatelessWidget {
  const ExpensePlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: ExpenseHomePage(),
    );
  }
}

class Expense {
  final String title;
  final double amount;
  final String category;

  Expense({required this.title, required this.amount, required this.category});
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<Expense> _expenses = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = "Food";
  String _selectedFilter = "All";

  final List<String> _categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Other"
  ];

  final Map<String, IconData> _categoryIcons = {
    "Food": Icons.fastfood,
    "Transport": Icons.directions_bus,
    "Shopping": Icons.shopping_bag,
    "Bills": Icons.receipt_long,
    "Entertainment": Icons.movie,
    "Other": Icons.more_horiz,
  };

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _addExpense() {
    if (_titleController.text.isEmpty || _amountController.text.isEmpty) return;

    final newExpense = Expense(
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0,
      category: _selectedCategory,
    );

    setState(() {
      _expenses.insert(0, newExpense);
    });
    _listKey.currentState?.insertItem(0, duration: Duration(milliseconds: 400));

    _titleController.clear();
    _amountController.clear();
    Navigator.of(context).pop();
  }

  void _openAddExpenseDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add Expense",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => SizedBox(),
      transitionBuilder: (context, anim, _, child) {
        return Transform.scale(
          scale: anim.value,
          child: Opacity(
            opacity: anim.value,
            child: StatefulBuilder(
              builder: (ctx, setStateDialog) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Row(
                  children: [
                    SizedBox(width: 8),
                    Text("Add Expense"),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
                          prefixIcon: Icon(Icons.title),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(_categoryIcons[_selectedCategory], color: Colors.blue),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedCategory,
                              items: _categories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(cat),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setStateDialog(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addExpense,
                    icon: Icon(Icons.check),
                    label: Text("Add"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseItem(Expense expense, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(
              _categoryIcons[expense.category],
              color: Colors.blue.shade900,
            ),
          ),
          title: Text(
            expense.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(expense.category),
          trailing: Text(
            "₹${expense.amount.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  double get _totalExpense {
    final filtered = _selectedFilter == "All"
        ? _expenses
        : _expenses.where((e) => e.category == _selectedFilter).toList();
    return filtered.fold(0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _selectedFilter == "All"
        ? _expenses
        : _expenses.where((e) => e.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Planner"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Total Expense Card
          AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: Card(
              key: ValueKey("${_totalExpense.toStringAsFixed(2)}-$_selectedFilter"),
              margin: EdgeInsets.all(12),
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.blue),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedFilter == "All"
                            ? "Total Expenses"
                            : "Total Expenses for $_selectedFilter",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "₹${_totalExpense.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text("All"),
                  selected: _selectedFilter == "All",
                  onSelected: (_) => setState(() => _selectedFilter = "All"),
                ),
                ..._categories.map((cat) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedFilter == cat,
                    onSelected: (_) => setState(() => _selectedFilter = cat),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
              child: Text(
                "No expenses yet for this category!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (ctx, index) {
                final expense = filteredExpenses[index];
                return _buildExpenseItem(expense, kAlwaysCompleteAnimation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
