import 'package:flutter/material.dart';
import 'package:chapter_9/header.dart';
import 'package:chapter_9/row_with_card.dart';
import 'package:chapter_9/row.dart';

class Home extends StatefulWidget{
  const Home({Key? key}):super(key:key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index)
              {
                if (index == 0)
                {
                  return HeaderWidget(index :index);
                }
                else if (index>= 1 && index<= 3)
                {
                  return RowWithCardWidget(index:index);
                }
                else
                {
                  return RowWidget(index:index);
                }
              }
          )
      ),
    );
  }
}