import 'package:flutter/material.dart';

void main() {
  runApp(const LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  const LoanCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      home: const LoanCalculator(),
    );
  }
}

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  LoanCalculatorState createState() => LoanCalculatorState();
}

class LoanCalculatorState extends State<LoanCalculator> {
  // Ensure the controllers are initialized
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  double _months = 1;
  double _monthlyPayment = 0;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is destroyed to free up resources
    _amountController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  void _calculateLoan() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double percent = double.tryParse(_percentController.text) ?? 0;
    if (amount > 0 && percent > 0) {
      setState(() {
        _monthlyPayment = (amount * (1 + (percent / 100) * _months)) / _months;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Loan Calculator',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: _amountController,
              label: 'Enter amount',
              hint: 'Amount',
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter number of months",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Slider(
              value: _months,
              min: 1,
              max: 60,
              divisions: 59,
              activeColor: Colors.greenAccent,
              label: _months.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _months = value;
                });
              },
            ),
            _buildTextField(
              controller: _percentController,
              label: 'Enter % per month',
              hint: 'Percent',
            ),
            const SizedBox(height: 30),
            _buildResultCard(),
            const Spacer(),
            ElevatedButton(
              onPressed: _calculateLoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                'Calculate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'You will pay the approximate amount monthly:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_monthlyPayment.toStringAsFixed(2)}€',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
