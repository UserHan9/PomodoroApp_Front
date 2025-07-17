import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Welcome to Home Screen")),

      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO add timer logic
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  //TODO add home logic
                },
              ),
              const SizedBox(width: 40), // Spacer untuk FAB
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  // TODO add history logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
