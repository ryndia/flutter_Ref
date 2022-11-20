import 'package:flutter/material.dart';

class RowWithCardWidget extends StatelessWidget{
  final int index;
  const RowWithCardWidget({Key? key, required this.index}):super(key:key);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.flight,
          size: 48.0,
          color: Colors.lightBlue,
        ),
        title: Text('Airplane $index'),
        subtitle: const Text('very good'),
        trailing: const Text(
          '(index * 7)%',
          style: TextStyle(color: Colors.lightBlue),
        ),
        onTap: () {
          print('$index');
        },
      ),
    );
  }
}