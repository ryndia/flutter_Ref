3import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.play_arrow),
          // icon: Icon(Icons.play_arrow),
          // label: Text('play'),
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.lightGreen.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Icon(Icons.pause),
                Icon(Icons.stop),
                Icon(Icons.access_time),
                Padding(padding: EdgeInsets.all(32.0),),
              ],
            )
        ),


      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),

        ],
        bottom: const PopupMenuButtonWidget(),
        /*PreferredSize(
          child: Container(
            color: Colors.lightGreen.shade100,
            height: 75.0,
            width: double.infinity,
            child: const Center(
              child: Text('Bottom'),
            ),
          ),

          preferredSize: const Size.fromHeight(75.0),),*/
        flexibleSpace: const SafeArea(
          child: Icon(
            Icons.photo_camera,
            size: 75.0,
            color: Colors.white70,
          ),
        ),
        title: const Text('hello world'),
      ),
      body: Padding(padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.all(16),),
                  const ContainerWithBoxDecorationWidget(),
                  const Padding(padding: EdgeInsets.all(16),),
                  Image.network('https://c4.wallpaperflare.com/wallpaper/295/163/719/anime-anime-boys-picture-in-picture-kimetsu-no-yaiba-kamado-tanjir%C5%8D-hd-wallpaper-preview.jpg'),
                  const Padding(padding: EdgeInsets.all(16),),
                  Row(
                    children: <Widget>[
                      Container(
                        color: Colors.yellow,
                        height: 40.0,
                        width: 40.0,
                      ),
                      const Padding(padding: EdgeInsets.all(16.0),),
                      Expanded(
                        child: Container(
                          color: Colors.amber,
                          height: 40.0,
                          width: 40,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(16.0),),
                      Container(
                        color: Colors.brown,
                        height: 40.0,
                        width: 40.0,
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(16.0),),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          const Text('C1'),
                          const Divider(),
                          const Text('C2'),
                          const Divider(),
                          const Text('C3'),
                          const Divider(),
                          const ThreeRow(),
                          const Divider(),
                          Container(
                            color: Colors.yellow,
                            height: 60.0,
                            width: 60.0,
                          ),
                          const Padding(padding: EdgeInsets.all(16.0),),
                          Container(
                            color: Colors.amber,
                            height: 40.0,
                            width: 40.0,
                          ),
                          const Padding(padding: EdgeInsets.all(16.0),),
                          Container(
                            color: Colors.brown,
                            height: 20.0,
                            width: 20.0,
                          ),
                          const Divider(),
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.lightGreen,
                                radius: 100.0,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.yellow,
                                      height: 100.0,
                                      width: 100.0,
                                    ),
                                    const Padding(padding: EdgeInsets.all(16.0),),
                                    Container(
                                      color: Colors.amber,
                                      height: 60.0,
                                      width: 60.0,
                                    ),
                                    const Padding(padding: EdgeInsets.all(16.0),),
                                    Container(
                                      color: Colors.brown,
                                      height: 40.0,
                                      width: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Text("End of line"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContainerWithBoxDecorationWidget extends StatelessWidget
{
  const ContainerWithBoxDecorationWidget({Key? key,}): super(key: key);

  @override

  Widget build(BuildContext context)
  {
    return Column(
        children: <Widget>[
        Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
              bottomRight: Radius.circular(10.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black,
                Colors.lightGreen.shade500,
              ],
            ),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 15.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ThreeRow extends StatelessWidget
{
  const ThreeRow({Key? key,}): super(key:key);
  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: const <Widget>[
      Text('R1'),
      Padding(padding: EdgeInsets.all(16.0),),
      Text('R2'),
      Padding(padding: EdgeInsets.all(16.0),),
      Text('R3'),
      ],
    );
  }
}

class TodoMenuItem{
  final String title;
  final Icon icon;

  TodoMenuItem(this.title, this.icon);
}

List<TodoMenuItem> foodMenuList = [
  TodoMenuItem('Fast Food', const Icon(Icons.fastfood)),
  TodoMenuItem('Remind Me', const Icon(Icons.add_alarm)),
  TodoMenuItem('Flight', const Icon(Icons.flight)),
  TodoMenuItem('Music',const Icon(Icons.audiotrack)),
];


class PopupMenuButtonWidget extends StatelessWidget implements PreferredSizeWidget {
const PopupMenuButtonWidget({Key? key,}) : super(key: key);

@override

Widget build(BuildContext context) {
  return Container(
    color: Colors.lightGreen.shade100,
    height: preferredSize.height,
    width: double.infinity,
    child: Center(
    child: PopupMenuButton<TodoMenuItem>(
      icon: const Icon(Icons.view_list),
      onSelected: ((valueSelected) {
      print('valueSelected: ${valueSelected.title}');
      }),
    itemBuilder: (BuildContext context) {
    return foodMenuList.map((TodoMenuItem todoMenuItem) {
      return PopupMenuItem<TodoMenuItem>(
        value: todoMenuItem,
        child: Row(
          children: <Widget>[
            Icon(todoMenuItem.icon.icon),
            const Padding(padding: EdgeInsets.all(8.0),),
            Text(todoMenuItem.title),
            ],
          ),
        );
      }).toList();
    },
    ),
  ),
);
}
@override
// implement preferredSize
Size get preferredSize => const Size.fromHeight(75.0);
}