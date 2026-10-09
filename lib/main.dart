import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MortgageApp());
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MortgageV0",
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white,
      ),
      home: const MortgageCalculator(),
    );
  }
}

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});

  @override
  State<MortgageCalculator> createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends State<MortgageCalculator> {
  double _amount = 100000.0;
  int _years = 30;
  double _interestRate = 3.5;

  double _monthlyPayment = 0.0;
  double _totalPayment = 0.0;

  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _calculateMortgage();
  }

  void _calculateMortgage() {
    final principal = _amount;
    final monthlyRate = (_interestRate / 100) / 12;
    final numberOfPayments = _years * 12;

    double monthlyPayment;

    monthlyPayment = principal *
        (monthlyRate * pow(1 + monthlyRate, numberOfPayments)) /
        (pow(1 + monthlyRate, numberOfPayments) - 1);

    final roundedMonthly = double.parse(monthlyPayment.toStringAsFixed(2));
    setState(() {
      _monthlyPayment = monthlyPayment;
      _totalPayment = roundedMonthly * numberOfPayments;
    });
  }

  Future<void> _openModifyData() async {
    final result = await Navigator.push<MortgageData>(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyDataScreen(
          amount: _amount,
          years: _years,
          interestRate: _interestRate,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _amount = result.amount;
        _years = result.years;
        _interestRate = result.interestRate;
      });

      _calculateMortgage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MortgageV0"),
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryRow(
              label: 'Amount',
              value: '\$${_amount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),

            _SummaryRow(
              label: 'Years',
              value: '$_years',
            ),
            const SizedBox(height: 24),

            _SummaryRow(
              label: 'Interest Rate',
              value: '${_interestRate.toStringAsFixed(1)}%',
            ),

            const Padding(
              padding: EdgeInsets.only(top: 18),
              child: Divider(
                color: Colors.black,
                thickness: 6,
              ),
            ),
            const SizedBox(height: 4),

            _SummaryRow(
              label: 'Monthly Payment',
              value: '\$${_monthlyPayment.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),

            _SummaryRow(
              label: 'Total Payment',
              value: '\$${_totalPayment.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),

            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              value: _acceptedTerms,
              activeColor: Colors.pink,
              onChanged: (bool? value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _openModifyData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'MODIFY DATA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 205,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class ModifyDataScreen extends StatefulWidget {
  final double amount;
  final int years;
  final double interestRate;

  const ModifyDataScreen({
    super.key,
    required this.amount,
    required this.years,
    required this.interestRate,
  });

  @override
  State<ModifyDataScreen> createState() => _ModifyDataScreenState();
}

class _ModifyDataScreenState extends State<ModifyDataScreen> {
  late int _years;
  late double _interestRate;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _years = widget.years;
    _interestRate = widget.interestRate;

    _amountController = TextEditingController(
      text: widget.amount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _done() {
    final amount = double.tryParse(_amountController.text.trim()) ?? widget.amount;

    Navigator.pop(
      context,
      MortgageData(
        amount: amount,
        years: _years,
        interestRate: _interestRate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('MortgageV0'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Years',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),

                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 0,
                    children: [
                      _yearRadio(10),
                      _yearRadio(15),
                      _yearRadio(30),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Interest Rate',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: 53,
                      itemBuilder: (context, index) {
                        final rate = 2.0 + index * 0.25;

                        final isSelected = (_interestRate - rate).abs() < 0.001;
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity:
                            const VisualDensity(vertical: -3),
                          leading: Radio<double>(
                            value: rate,
                            groupValue: _interestRate,
                            activeColor: Colors.pink,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _interestRate = value;
                                });
                              }
                            },
                          ),
                          title: Text(
                            '${rate.toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          selected: isSelected,
                          onTap: () {
                            setState(() {
                              _interestRate = rate;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _done,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
  Widget _yearRadio(int year) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: year,
          groupValue: _years,
          activeColor: Colors.pink,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _years = value;
              });
            }
          },
        ),

        Text(
          '$year',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}


class MortgageData {
  final double amount;
  final int years;
  final double interestRate;

  MortgageData({
    required this.amount,
    required this.years,
    required this.interestRate,
  });
}