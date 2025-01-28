import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer_tile.dart';
import 'package:flutter_application_1/pages/saved_forecast.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // drawer header
          Column(
            children: [
              DrawerHeader(child: Icon(Icons.wb_sunny)),

              //shop title
              MyListTile(
                  text: 'Home',
                  icon: Icons.home,
                  OnTap: () {
                    Navigator.pop(context);
                  }),
              //cart tile

              MyListTile(
                  text: 'Saved forecast',
                  icon: Icons.save,
                  OnTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SavedWeatherScreen()));
                  }),
            ],
          ),

          //exit
        ],
      ),
    );
  }
}
