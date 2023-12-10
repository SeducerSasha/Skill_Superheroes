// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:async';

import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MainBloc {
  static const minSymbols = 3;
  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  final favoriteSurerheroesSubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.mocked);
  final searchedSurerheroesSubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded('');

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  MainBloc() {
    stateSubject.add(MainPageState.noFavorites);

    textSubscription = currentTextSubject.listen((value) {
      searchSubscription?.cancel();
      if (value.isEmpty) {
        stateSubject.add(MainPageState.favorites);
      } else if (value.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchSuperheroes(value);
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
    return favoriteSurerheroesSubject;
  }

  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() {
    return searchedSurerheroesSubject;
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return SuperheroInfo.mocked;
  }

  Stream<MainPageState> observeMainPageState() {
    return stateSubject;
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
    favoriteSurerheroesSubject.close();
    searchedSurerheroesSubject.close();
    currentTextSubject.close();
    textSubscription?.cancel();
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
