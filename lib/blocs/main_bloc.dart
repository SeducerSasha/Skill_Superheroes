// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:async';

import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/exception.dart';
import 'package:superheroes/model/superhero.dart';

class MainBloc {
  static const minSymbols = 3;
  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  final favoriteSuperheroesSubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.mocked);
  final searchedSurerheroesSubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded('');

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  http.Client? client;

  MainBloc({this.client}) {
    stateSubject.add(MainPageState.noFavorites);

    textSubscription = Rx.combineLatest2(
        currentTextSubject
            .distinct()
            .debounceTime(const Duration(milliseconds: 500)),
        favoriteSuperheroesSubject,
        (searhedText, favorites) => MainPageInfo(
            searchText: searhedText,
            haveFavorites: favorites.isNotEmpty)).listen((value) {
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        if (value.haveFavorites) {
          stateSubject.add(MainPageState.favorites);
        } else {
          stateSubject.add(MainPageState.noFavorites);
        }
      } else if (value.searchText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchSuperheroes(value.searchText);
      }
    });
  }

  void searchSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);

    searchSubscription = search(text).asStream().listen((result) {
      if (result.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        searchedSurerheroesSubject.add(result);
        stateSubject.add(MainPageState.searchResults);
      }
    }, onError: (e, stack) {
      stateSubject.add(MainPageState.loadingError);
    });
  }

  Stream<List<SuperheroInfo>> observeFavoriteSuperheroes() {
    return favoriteSuperheroesSubject;
  }

  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() {
    return searchedSurerheroesSubject;
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/search/$text'));

    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    } else if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['response'] == 'error') {
        if (decoded['error'] == 'character with given name not found') {
          return [];
        } else {
          throw ApiException('Client error happened');
        }
      } else {
        final List<dynamic> results = decoded['results'];
        final List<Superhero> superheroes =
            results.map((element) => Superhero.fromJson(element)).toList();
        final List<SuperheroInfo> found = superheroes.map((element) {
          return SuperheroInfo(
              name: element.name,
              realName: element.biography.fullName,
              imageURL: element.image.url);
        }).toList();
        return found;
      }
    } else {
      throw Exception('Unknown error');
    }

    // if (decoded['response'] == 'success') {
    //   final List<dynamic> results = decoded['results'];
    //   final List<Superhero> superheroes =
    //       results.map((element) => Superhero.fromJson(element)).toList();
    //   final List<SuperheroInfo> found = superheroes.map((element) {
    //     return SuperheroInfo(
    //         name: element.name,
    //         realName: element.biography.fullName,
    //         imageURL: element.image.url);
    //   }).toList();
    //   return found;
    // } else {
    //   if (decoded['response'] == 'error') {
    //     if (decoded['error'] == 'character with given name not found') {
    //       return [];
    //     }
    //   }
    // }
    //throw Exception('Unknown error');
  }

  Stream<MainPageState> observeMainPageState() {
    return stateSubject;
  }

  void removeFavorite() {
    final List<SuperheroInfo> currentListFavorites =
        favoriteSuperheroesSubject.value;
    if (currentListFavorites.isEmpty) {
      favoriteSuperheroesSubject.add(SuperheroInfo.mocked);
    } else {
      currentListFavorites.removeLast();
      favoriteSuperheroesSubject.add(currentListFavorites);
      // favoriteSuperheroesSubject.add(
      //     currentListFavorites.sublist(0, currentListFavorites.length - 1));
    }
  }

  void retry() {
    final currentSearchText = currentTextSubject.value;
    searchSuperheroes(currentSearchText);
  }

  void nextState() {
    final currentState = stateSubject.value;

    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  void dispose() {
    stateSubject.close();
    favoriteSuperheroesSubject.close();
    searchedSurerheroesSubject.close();
    currentTextSubject.close();
    textSubscription?.cancel();
    client?.close();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}

class SuperheroInfo {
  final String name;
  final String realName;
  final String imageURL;

  SuperheroInfo(
      {required this.name, required this.realName, required this.imageURL});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SuperheroInfo &&
        other.name == name &&
        other.realName == realName &&
        other.imageURL == imageURL;
  }

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageURL.hashCode;

  @override
  String toString() =>
      'SuperheroInfo(name: $name, realName: $realName, imageURL: $imageURL)';

  static List<SuperheroInfo> mocked = [
    SuperheroInfo(
        name: 'Batman',
        realName: 'Bruce Wayne',
        imageURL:
            'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg'),
    SuperheroInfo(
        name: 'Ironman',
        realName: 'Tony Stark',
        imageURL:
            'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg'),
    SuperheroInfo(
        name: 'Venom',
        realName: 'Eddie Brock',
        imageURL:
            'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg'),
  ];
}

class MainPageInfo {
  final String searchText;
  final bool haveFavorites;

  const MainPageInfo({required this.searchText, required this.haveFavorites});

  @override
  String toString() =>
      'MainPageInfo(searchText: $searchText, haveFavorites: $haveFavorites)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MainPageInfo &&
        other.searchText == searchText &&
        other.haveFavorites == haveFavorites;
  }

  @override
  int get hashCode => searchText.hashCode ^ haveFavorites.hashCode;
}
