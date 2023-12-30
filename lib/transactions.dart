import 'package:flutter/material.dart';

class Transactions extends StatelessWidget {
  const Transactions(
      {Key? key,
      required this.transactionName,
      required this.money,
      required this.expenOrInco})
      : super(key: key);

  final String transactionName;
  final String money;
  final String expenOrInco;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height * .1,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade400),
                    child: const Center(
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    transactionName,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
              Text(
                '${expenOrInco == 'expense' ? '-' : '+'}\$$money',
                style: TextStyle(
                    fontSize: 17,
                    color:
                        expenOrInco == 'expense' ? Colors.red : Colors.green),
              )
            ],
          ),
        ),
      ),
    );
  }
}
