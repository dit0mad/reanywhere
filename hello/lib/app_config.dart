import 'package:flutter/material.dart';
import 'package:hello/http_service/http_service.dart';

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
