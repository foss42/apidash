import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileBottomNavBar extends ConsumerStatefulWidget {
  const MobileBottomNavBar({super.key});

  @override
  ConsumerState<MobileBottomNavBar> createState() => _MobileBottomNavBarState();
}

class _MobileBottomNavBarState extends ConsumerState<MobileBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_mosaic_outlined),
          label: "request",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.north_east_rounded),
          label: "response",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code),
          label: "code",
        ),
      ],
      currentIndex: ref.read(mobileBottomNavIndexStateProvider),
      onTap: (value) {
        setState(() {
          ref.watch(mobileBottomNavIndexStateProvider.notifier).state = value;
        });
      },
    );
  }
}
