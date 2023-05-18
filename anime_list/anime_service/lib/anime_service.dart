/// A Very Good Project created by Very Good CLI.
library anime_service;

import 'package:http/http.dart' as http;
import 'dart:convert';
export 'src/anime_service.dart';

class AnimeService {
  final String apiUrl = 'https://anilist-graphql.p.rapidapi.com/';
  final String rapidApiKey =
      'c43f51fadfmsh684fa3bb53df5f0p1616abjsn319fdd49a1aa';
  final String rapidApiHost = 'anilist-graphql.p.rapidapi.com';

  Future<List<dynamic>?> getAnime(String query) async {
    final url = Uri.parse('YOUR_API_ENDPOINT_URL');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      'query': '''
      query (\$page: Int, \$perPage: Int, \$search: String) {
        Page(page: \$page, perPage: \$perPage) {
          pageInfo {
            total
            perPage
          }
          media(search: \$search, type: ANIME}) {
            id
            title {
              romaji
              english
              native
            }
            type
            genres
          }
        }
      }
    ''',
      'variables': {
        'search': query,
        'page': 1,
        'perPage': 3,
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Parse and process the data as needed
      // Return the relevant information
      return data;
    } else {
      throw Exception('Failed to fetch anime');
    }
  }
}
