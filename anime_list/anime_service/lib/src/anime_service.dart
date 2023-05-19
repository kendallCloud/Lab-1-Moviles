/// {@template anime_service}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
import 'package:graphql_flutter/graphql_flutter.dart';

class AnimeService {
  final GraphQLClient _client;

  AnimeService() : _client = _createGraphQLClient();

  static GraphQLClient _createGraphQLClient() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co/');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<List<dynamic>> getAnimeList() async {
    final query = gql('''
      query FetchAnimeList(\$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media {
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
    ''');

    final options = QueryOptions(
      document: query,
      variables: {'page': 1, 'perPage': 10},
    );

    final result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Failed to fetch anime list: ${result.exception}');
    }

    final animeList = result.data?['Page']['media'] as List<dynamic>?;

    return animeList ?? [];
  }

  Future<List<dynamic>> getCharacterList(int animeId) async {
    final query = r'''
      query GetCharacterList($animeId: Int!) {
        Media(id: $animeId) {
          characters {
            edges {
              node {
                id
                name {
                  full
                }
                image {
                  large
                }
              }
            }
          }
        }
      }
    ''';

    final options = QueryOptions(
      document: gql(query),
      variables: {'animeId': animeId},
    );

    final result = await _client.query(options);

    if (result.hasException) {
      throw Exception('Failed to fetch character list: ${result.exception}');
    }

    final List<dynamic> characterList =
        result.data?['Media']['characters']['edges'] as List<dynamic>;

    return characterList ?? [];
  }
}
