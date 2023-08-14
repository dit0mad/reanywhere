import 'package:flutter/material.dart';
import 'package:simpsonsviewer/pages/mobile/main_screen.dart';
import 'package:simpsonsviewer/pages/tablet/tablet_main.dart';

const List<MaterialPage<dynamic>> mobileStack = [
  MaterialPage(
    child: MobileMainScreen(),
  )
];

const List<MaterialPage<dynamic>> tableStack = [
  MaterialPage(
    child: TabletMainScreen(),
  )
];
