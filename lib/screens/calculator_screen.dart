import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String userInput = '';
  String result = '0';

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '*',
    '7',
    '8',
    '9',
    '+',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    'C',
    '.',
    '0',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3.2,
              child: resultWidget(),
            ),
            Expanded(child: buttonWidget()),
          ],
        ),
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(userInput, style: const TextStyle(fontSize: 32),),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(result, style: const TextStyle(fontSize: 48),),
          ),
        ],
      ),
    );
  }

  Widget buttonWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color.fromARGB(66, 233, 232, 232),
      child: GridView.builder(
        itemCount: buttonList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
      ),
        itemBuilder: (context, index){
          return button(buttonList[index]);
      },),
    );
  }

  getColor(String text) {
    if(text == '=' || text == 'AC' || text == 'C') {
      return Colors.white;
    }
    return Colors.indigo;
  }

  getBgColor(String text) {
    if(text == '=' || text == 'C' || text == 'AC') {
      return Colors.indigo;
    }
    return Colors.white;
  }

  Widget button(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          handleButtonPress(text);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: getBgColor(text),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(text, style: TextStyle(
            color: getColor(text),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
    );
  }

  handleButtonPress(String text) {
    if(text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }

    if(text == 'C') {
      if(userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      }
      else {
        return null;
      }
    }

    if(text == '=') {
      result = calculate();
      userInput = result;
      if(userInput.endsWith('.0')) {
        userInput = userInput.replaceAll('.0', '');
      }
      if(result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
      }
      return;
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch(e) {
      return 'error';
    }
  }
}
