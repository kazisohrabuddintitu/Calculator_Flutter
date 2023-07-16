import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';
  double _result = 0.0;

  void _handleButtonPressed(String value) {
    setState(() {
      if (value == '=') {
        _calculateResult();
      } else if (value == 'C') {
        _clearDisplay();
      } else {
        _display += value;
      }
    });
  }

  void _calculateResult() {
    try {
      final parser = Parser();
      final expression = parser.parse(_display);
      final context = ContextModel();
      _result = expression.evaluate(EvaluationType.REAL, context);
      _display = _result.toString();
    } catch (exception) {
      _display = 'Error';
    }
  }

  void _clearDisplay() {
    _display = '';
    _result = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                _display,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Divider(),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            children: [
              ..._buildNumberButtons(),
              ..._buildOperatorButtons(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNumberButtons() {
    return List.generate(
      10,
          (index) => CalculatorButton(
        text: index.toString(),
        onPressed: () => _handleButtonPressed(index.toString()),
      ),
    );
  }

  List<Widget> _buildOperatorButtons() {
    final operators = ['+', '-', '*', '/', '=', 'C'];
    return operators
        .map(
          (operator) => CalculatorButton(
        text: operator,
        onPressed: () => _handleButtonPressed(operator),
        backgroundColor: Colors.white,
      ),
    )
        .toList();
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const CalculatorButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}



