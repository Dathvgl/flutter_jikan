import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jikan_api/jikan_api.dart';

abstract class JikanRoot {
  static onClick({required BuildContext context, required int id}) {
    context.push("/detail-jikan/$id");
  }

  static List<TextButton> listTextButton({required BuiltList<Meta> list}) {
    return list
        .map((item) => TextButton(
              onPressed: () {},
              child: Text(item.name),
            ))
        .toList();
  }

  static Text infoString({required BuiltList<Meta> list}) {
    return Text(
      list.map((item) => item.name).join(", "),
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
    );
  }

  static Text titleString({required String title}) {
    return Text(
      title,
      maxLines: 2,
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static AspectRatio imageBase({required String url}) {
    return AspectRatio(
      aspectRatio: 0.75,
      // child: Image.network(
      //   fit: BoxFit.cover,
      //   url,
      //   errorBuilder: (context, error, stackTrace) {
      //     return const Center(
      //       child: Text(
      //         "Error Image",
      //         style: TextStyle(
      //           color: Color(0xFFC62828),
      //           fontSize: 20,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     );
      //   },
      // ),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        progressIndicatorBuilder: (context, url, progress) {
          return CircularProgressIndicator(
            value: progress.progress,
          );
        },
        errorWidget: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

abstract class JikanAnime {
  static Future<Response> _httpUri({required String url}) async {
    final allUrl = baseUrl + url;
    return await http.get(Uri.parse(allUrl));
  }

  static String _enumStr<T extends Enum>(T type) => type.name;

  static Future<List<Anime>> getSeason({
    int? year,
    SeasonType? season,
    int page = 1,
  }) async {
    var url = "/seasons";
    if (year != null && season != null) {
      url += '/$year/${_enumStr(season)}?page=$page';
    } else {
      url += '/now?page=$page';
    }

    final response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Anime.fromJson(item)).toList();
  }

  static Future<List<Archive>> getSeasonsList() async {
    const url = '/seasons';

    final response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Archive.fromJson(item)).toList();
  }

  static Future<List<Anime>> getTopAnime({
    TopType? type,
    TopSubtype? subtype,
    int page = 1,
  }) async {
    var url = '/top/anime?page=$page';
    url += type == null ? '' : '&type=${_enumStr(type)}';
    url += subtype == null ? '' : '&filter=${_enumStr(subtype)}';

    final response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Anime.fromJson(item)).toList();
  }

  static Future<Anime> getAnime({
    required int id,
  }) async {
    final url = '/anime/$id/full';
    final response = await _httpUri(url: url);
    return Anime.fromJson(jsonDecode(response.body)["data"]);
  }

  static Future<List<Picture>> getAnimePictures({
    required int id,
  }) async {
    final url = '/anime/$id/pictures';

    final response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Picture.fromJson(item)).toList();
  }

  static Future<List<CharacterMeta>> getAnimeCharacters({
    required int id,
  }) async {
    var url = '/anime/$id/characters';

    var response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => CharacterMeta.fromJson(item)).toList();
  }

  static Future<List<PersonMeta>> getAnimeStaff({
    required int id,
  }) async {
    var url = '/anime/$id/staff';

    var response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => PersonMeta.fromJson(item)).toList();
  }

  static Future<List<Recommendation>> getAnimeRecommendations({
    required int id,
  }) async {
    var url = '/anime/$id/recommendations';

    var response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Recommendation.fromJson(item)).toList();
  }

  static Future<List<Review>> getAnimeReviews({
    required int id,
    int page = 1,
  }) async {
    var url = '/anime/$id/reviews?page=$page';

    var response = await _httpUri(url: url);
    final code = response.statusCode;

    final list = code == 200 ? jsonDecode(response.body)["data"] as List : [];
    return list.map((item) => Review.fromJson(item)).toList();
  }

  static Future<Stats> getAnimeStatistics({
    required int id,
  }) async {
    var url = '/anime/$id/statistics';
    var response = await _httpUri(url: url);
    return Stats.fromJson(jsonDecode(response.body)["data"]);
  }
}
