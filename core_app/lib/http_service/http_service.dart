import 'dart:convert';

import 'package:http/http.dart';
import 'dart:developer' as developer;

class HttpService {
  final String url;

  const HttpService({required this.url});

  Future<Map<String, List<BaseCharacter>>> getData(param0) async {
    final req = await get(Uri.parse(url));

    final body = json.decode(req.body);

    final String name = body['Heading'];

    //list of maps
    List<dynamic> characters = body['RelatedTopics'];

    //image, title, and description.

    final List<BaseCharacter> resolvedCharcters = [];

    final Map<String, List<BaseCharacter>> nameToCharacter = {
      name: resolvedCharcters
    };

    for (var character in characters) {
      final result = BaseCharacter.fromJson(
        character,
      );

      resolvedCharcters.add(result);
    }

    return nameToCharacter;
  }
}

abstract class BaseCharacter {
  final String image;
  final String title;
  final String description;

  const BaseCharacter({
    required this.description,
    required this.image,
    required this.title,
  });

  static BaseCharacter fromJson(
    Map map,
  ) {
    final String imageUrl = map['Icon']['URL'];
    final String title = resolveTitle(map);
    final String text = map['Text'];

    return ConcreteCharacter(
      image: resolveImage(imageUrl),
      title: title,
      description: text,
    );
  }

  static String resolveImage(String imageUrl) {
    String placeHolderPath = 'assets/noimage.png';

    String resolvedUrl = imageUrl;

    if (imageUrl.isEmpty) {
      return '';
    }

    Uri baseUri = Uri.parse("https://duckduckgo.com");

    Uri modifiedUri = baseUri.replace(path: baseUri.path + resolvedUrl);

    return modifiedUri.toString();
  }

  static String resolveTitle(final Map map) {
    final title = map['FirstURL'];

    String modifiedString = title.replaceAll('_', ' ');

    final RegExp regex = RegExp(r'\/([^\/]*)$');
    final Match? match = regex.firstMatch(modifiedString);
    final String extractedPart = match?.group(1) ?? "";

    //decode url encoded characters
    final String decodedString = Uri.decodeComponent(extractedPart);

    developer.log(decodedString);

    return decodedString;
  }
}

class ConcreteCharacter extends BaseCharacter {
  ConcreteCharacter({
    required super.description,
    required super.image,
    required super.title,
  });
}

class SimpsonCharacter extends BaseCharacter {
  SimpsonCharacter({
    required super.description,
    required super.image,
    required super.title,
  });

  static SimpsonCharacter fromType(BaseCharacter character) {
    return SimpsonCharacter(
      description: character.description,
      image: character.image,
      title: character.title,
    );
  }
}

class WireViewerCharacter extends BaseCharacter {
  WireViewerCharacter({
    required super.description,
    required super.image,
    required super.title,
  });

  static WireViewerCharacter fromType(BaseCharacter character) {
    return WireViewerCharacter(
      description: character.description,
      image: character.image,
      title: character.title,
    );
  }
}
