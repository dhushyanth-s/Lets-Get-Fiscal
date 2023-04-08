import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        closedBuilder: (context, openPage) => FloatingActionButton(
          onPressed: openPage,
          child: const Icon(Icons.add),
        ),
        openBuilder: (context, closePage) => const AddPage(),
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.primaryContainer,
        openColor: Theme.of(context).colorScheme.surface,
        transitionType: ContainerTransitionType.fadeThrough,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  "Let's get",
                  style: TextStyle(
                    fontFamily: "HelveticaNow",
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Fiscal",
                  style: TextStyle(
                    fontFamily: "HelveticaNow",
                    fontSize: 40,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Card(
                child: Text("Budget"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
