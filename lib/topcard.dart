import 'package:flutter/material.dart';

class Topcard extends StatelessWidget {
  const Topcard(
      {Key? key,
      required this.balance,
      required this.income,
      required this.expense})
      : super(key: key);

  final String balance;
  final String income;
  final String expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(18),
      padding: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
              blurRadius: 15,
              offset: const Offset(4, 4),
              color: Colors.grey.shade500,
              spreadRadius: 1),
          const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1)
        ],
      ),
      child: Column(
        children: [
          Text(
            'BALANCE',
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
          Text(
            balance,
            style: TextStyle(color: Colors.grey[800], fontSize: 40),
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70)),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      )),
                  Column(
                    children: [const Text('Income'), Text(income)],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(70)),
                    child: const Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                    ),
                  ),
                  Column(
                    children: [const Text('Expense'), Text(expense)],
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
