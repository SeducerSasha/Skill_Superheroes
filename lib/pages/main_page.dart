import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// class MainBlocHolder extends InheritedWidget {
//   final MainBloc bloc;

//   MainBlocHolder({super.key, required final Widget child, required this.bloc})
//       : super(child: child);

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

//   static MainBlocHolder of(final BuildContext context) {
//     final InheritedElement element =
//         context.getElementForInheritedWidgetOfExactType<MainBlocHolder>()!;
//     return element.widget as MainBlocHolder;
//   }
// }

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperHeroesColor.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
    // )
    // return MainBlocHolder(
    //   bloc: bloc,
    //   child: const Scaffold(
    //     backgroundColor: SuperHeroesColor.background,
    //     body: SafeArea(
    //       child: MainPageContent(),
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  const MainPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    //final MainBloc bloc = MainBlocHolder.of(context).bloc;
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Stack(
      children: [
        const MainPageStateWidget(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ActionButton(
                text: 'Next state',
                onTap: () {
                  bloc.nextState();
                },
              ),
            ))
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperHeroesColor.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

class MinSymbols extends StatelessWidget {
  const MinSymbols({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 134, left: 16, right: 16),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Enter at least 3 symbols',
          style: TextStyle(
              color: SuperHeroesColor.whiteText,
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class NoFavorites extends StatelessWidget {
  const NoFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
        title: 'No favorites yet',
        subtitle: 'Search and add',
        buttonText: 'Search',
        assetImage: SuperHeroesImages.ironMan,
        imageHeight: 119,
        imageWidth: 108,
        imageTopPadding: 9);
  }
}

class NothingFound extends StatelessWidget {
  const NothingFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
        title: 'Nothing found',
        subtitle: 'Search for something else',
        buttonText: 'Search',
        assetImage: SuperHeroesImages.hulk,
        imageHeight: 119,
        imageWidth: 108,
        imageTopPadding: 9);
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoWithButton(
        title: 'Error happened',
        subtitle: 'Please, try again',
        buttonText: 'Retry',
        assetImage: SuperHeroesImages.superMan,
        imageHeight: 119,
        imageWidth: 108,
        imageTopPadding: 9);
  }
}

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 114,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your favorites',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: SuperHeroesColor.whiteText),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SuperheroPage(
                    name: 'Batman',
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(
                        name: 'Ironman',
                      )));
            },
          ),
        ),
      ],
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 114,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Search results',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: SuperHeroesColor.whiteText),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SuperheroCard(
              name: 'Batman',
              realName: 'Bruce Wayne',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SuperheroPage(
                          name: 'Batman',
                        )));
              },
            )),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SuperheroCard(
            name: 'Venom',
            realName: 'Eddie Brock',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SuperheroPage(
                        name: 'Venom',
                      )));
            },
          ),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  const MainPageStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //final MainBloc bloc = MainBlocHolder.of(context).bloc;
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }

        final MainPageState state = snapshot.data!;

        switch (state) {
          case MainPageState.loading:
            return const LoadingIndicator();
          case MainPageState.noFavorites:
            return const NoFavorites();
          case MainPageState.minSymbols:
            return const MinSymbols();
          case MainPageState.nothingFound:
            return const NothingFound();
          case MainPageState.loadingError:
            return const LoadingError();
          case MainPageState.searchResults:
            return const SearchResult();
          case MainPageState.favorites:
            return const Favorites();
          default:
            return Center(
              child: Text(
                state.toString(),
                style: const TextStyle(
                    fontSize: 20, color: SuperHeroesColor.whiteText),
              ),
            );
        }
      },
    );
  }
}
