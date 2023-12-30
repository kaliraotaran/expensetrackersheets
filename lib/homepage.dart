import 'dart:async';

import 'package:expensetrackersheets/gsheets.dart';
import 'package:expensetrackersheets/loading_circle.dart';
import 'package:expensetrackersheets/plus_button.dart';
import 'package:expensetrackersheets/topcard.dart';
import 'package:expensetrackersheets/transactions.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isIncome = false;
  final _formkey = GlobalKey<FormState>();
  final _textcontrollerAmount = TextEditingController();
  final _textcontrollerItem = TextEditingController();

  void _enterTransaction() {
    GoogleSheetsApi.insert(
        _textcontrollerItem.text, _textcontrollerAmount.text, _isIncome);
    setState(() {});
  }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('New Transaction'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('expense'),
                        Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            }),
                        const Text('Income')
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Form(
                          key: _formkey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Enter amount",
                                border: OutlineInputBorder()),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Enter your amount';
                              }
                              return null;
                            },
                            controller: _textcontrollerAmount,
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'For what?'),
                          controller: _textcontrollerItem,
                        ))
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.grey[600],
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      _enterTransaction();
                      Navigator.of(context).pop();
                    }
                  },
                  color: Colors.grey[600],
                  child: const Text(
                    'Enter',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          });
        });
  }

  bool timerhasStarted = false;
  void startLoading() {
    timerhasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetsApi.loading == true && timerhasStarted == false) {
      startLoading();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Topcard(
              balance: '\$20,000',
              income: '\$200',
              expense: '\$300',
            ),
            Expanded(
                child: Container(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? const LoadingCircle()
                            : ListView.builder(
                                itemCount:
                                    GoogleSheetsApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return Transactions(
                                      transactionName: GoogleSheetsApi
                                          .currentTransactions[index][0],
                                      money: GoogleSheetsApi
                                          .currentTransactions[index][1],
                                      expenOrInco: GoogleSheetsApi
                                          .currentTransactions[index][2]);
                                }))
                  ],
                ),
              ),
            )),
            PlusButton(
              function: _newTransaction,
            )
          ],
        ),
      ),
    );
  }
}
