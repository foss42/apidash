import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileDashboard extends StatelessWidget {
  const MobileDashboard({super.key, required this.page, required this.title});
  final Widget page;
  final String title;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
               Expanded(
                  child: page
              ),
            ],
          )
      ),
    );
  }
}
