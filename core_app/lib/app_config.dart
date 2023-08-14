import 'package:coreapp/http_service/http_service.dart';
import 'package:flutter/material.dart';

class AppConfig {
  final HttpService httpService;
  final Flavor flavor;
  final List<MaterialPage<dynamic>> mobile;
  final List<MaterialPage<dynamic>> tablet;

  const AppConfig({
    required this.httpService,
    required this.flavor,
    required this.tablet,
    required this.mobile,
  });
}

enum Flavor {
  simpson,
  other,
}
