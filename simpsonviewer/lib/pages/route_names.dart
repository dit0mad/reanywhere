import 'package:flutter/material.dart';

import 'mobile/main_screen.dart';
import 'tablet/tablet_main.dart';

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
