// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'dart:async';

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superHeroSubject = BehaviorSubject<Superhero>();
  final superHeroPageStateSubject = BehaviorSubject<SuperheroPageState>();
  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
  }

  Stream<Superhero> observeSuperHero() => superHeroSubject.distinct();
  Stream<SuperheroPageState> observeSuperHeroPageState() =>
      superHeroPageStateSubject.distinct();

  StreamSubscription? getFromFavoriteSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeFromFavoriteSubscription;

  Future<Superhero> request() async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/$id'));

    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    } else if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['response'] == 'success') {
        final superhero = Superhero.fromJson(decoded);
        await FavoriteSuperheroesStorage.getInstance()
            .updateIfExistsFavorites(superhero);
        return superhero;
      } else {
        throw ApiException('Client error happened');
      }
    } else {
      throw Exception('Unknown error');
    }
  }

  void getFromFavorites() {
    getFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen((superhero) {
      if (superhero != null) {
        superHeroSubject.add(superhero);
        superHeroPageStateSubject.add(SuperheroPageState.loaded);
      } else {
        superHeroPageStateSubject.add(SuperheroPageState.loading);
      }
      requestSuperHero(superhero != null);
    },
            onError: (error, stack) =>
                log('Error happened in removeFromFavorites: $error, $stack'));
  }

  void addToFavorites() {
    final superhero = superHeroSubject.valueOrNull;
    if (superhero == null) {
      return;
    }

    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen((event) {
      log('Add to favorites: $event');
    },
            onError: (error, stack) =>
                log('Error happened in addToFavorites: $error, $stack'));
  }

  void removeFromFavorites() {
    final superhero = superHeroSubject.valueOrNull;
    if (superhero == null) {
      return;
    }

    removeFromFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeFromFavorites(id)
        .asStream()
        .listen((event) {
      log('Remove from favorites: $event');
    },
            onError: (error, stack) =>
                log('Error happened in removeFromFavorites: $error, $stack'));
  }

  Stream<bool> observeIsFavorites() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperHero(final bool isInFavorites) {
    requestSubscription?.cancel();

    requestSubscription = request().asStream().listen((superhero) {
      superHeroSubject.add(superhero);
      superHeroPageStateSubject.add(SuperheroPageState.loaded);
    }, onError: (e, stack) {
      if (!isInFavorites) {
        superHeroPageStateSubject.add(SuperheroPageState.error);
      }
      log('Error happened in requestSuperHero: $e, $stack');
    });
  }

  void retry() {
    superHeroPageStateSubject.add(SuperheroPageState.loading);
    requestSuperHero(false);
  }

  void dispose() {
    client?.close();

    superHeroSubject.close();
    superHeroPageStateSubject.close();

    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeFromFavoriteSubscription?.cancel();
    getFromFavoriteSubscription?.cancel();
  }
}

enum SuperheroPageState { loading, loaded, error }
