
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
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
        child: SingleChildScrollView(
          child: Padding(padding:const EdgeInsets.all(16.0),
            child: Column(
              children: const <Widget> [
                ImageAndIconWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageAndIconWidget extends StatelessWidget
{
const ImageAndIconWidget({Key? key,}): super(key:key);

@override

Widget build(BuildContext context)
{
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget> [
        Image.network(
          'https://c4.wallpaperflare.com/wallpaper/295/163/719/anime-anime-boys-picture-in-picture-kimetsu-no-yaiba-kamado-tanjir%C5%8D-hd-wallpaper-preview.jpg',
          // width: MediaQuery.of(context).size.width/3,
        ),
        const Icon(
          Icons.brush,
          size: 48,
          color: Colors.red,
        ),
        Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.deepOrangeAccent,
          ),
),
            const Padding(padding: EdgeInsets.all(120),),
            TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 16.0,
            ),
            decoration: const InputDecoration(
              labelText: "Notes",
              labelStyle: TextStyle(),
              border: OutlineInputBorder(),
            ),
          ),
          const Divider(),
            const TextField(
            decoration: InputDecoration(
              labelText: 'Enter your notes',
            ),
          ),
        ],
      );
    }
}