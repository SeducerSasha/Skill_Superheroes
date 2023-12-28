import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_color.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  final http.Client? client;
  const MainPage({super.key, this.client});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc = MainBloc();

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
  }

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
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  late FocusNode textFieldSearchFocusNode;

  @override
  void initState() {
    super.initState();
    textFieldSearchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    textFieldSearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final MainBloc bloc = MainBlocHolder.of(context).bloc;
    //final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Stack(
      children: [
        MainPageStateWidget(textFieldSearchFocusNode: textFieldSearchFocusNode),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          child:
              SearchWidget(textFieldSearchFocusNode: textFieldSearchFocusNode),
        )
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode textFieldSearchFocusNode;
  const SearchWidget({super.key, required this.textFieldSearchFocusNode});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController textSearchingController = TextEditingController();
  bool haveSearchedText = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      textSearchingController.addListener(() {
        bloc.updateText(textSearchingController.text);
        final haveText = textSearchingController.text.isNotEmpty;
        if (haveSearchedText != haveText) {
          setState(() {
            haveSearchedText = haveText;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return TextField(
      focusNode: widget.textFieldSearchFocusNode,
      controller: textSearchingController,
      cursorColor: Colors.white,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      //onChanged: (text) => bloc.updateText(text),
      decoration: InputDecoration(
          filled: true,
          fillColor: SuperHeroesColor.background75,
          isDense: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: haveSearchedText
                ? const BorderSide(
                    color: Colors.white,
                    width: 2,
                  )
                : const BorderSide(
                    color: Colors.white54,
                  ),
          ),
          prefixIcon: const Icon(
            size: 24,
            Icons.search,
            color: Colors.white54,
          ),
          suffix: GestureDetector(
            onTap: () {
              textSearchingController.clear();
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          )),
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: SuperHeroesColor.whiteText),
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
  final FocusNode textFieldSearchFocusNode;
  const NoFavorites({super.key, required this.textFieldSearchFocusNode});

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'No favorites yet',
      subtitle: 'Search and add',
      buttonText: 'Search',
      assetImage: SuperHeroesImages.ironMan,
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
      onTap: () => textFieldSearchFocusNode.requestFocus(),
    );
  }
}

class NothingFound extends StatelessWidget {
  final FocusNode textFieldSearchFocusNode;

  const NothingFound({super.key, required this.textFieldSearchFocusNode});

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Nothing found',
      subtitle: 'Search for something else',
      buttonText: 'Search',
      assetImage: SuperHeroesImages.hulk,
      imageHeight: 112,
      imageWidth: 84,
      imageTopPadding: 16,
      onTap: () => textFieldSearchFocusNode.requestFocus(),
    );
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return InfoWithButton(
      title: 'Error happened',
      subtitle: 'Please, try again',
      buttonText: 'Retry',
      assetImage: SuperHeroesImages.superMan,
      imageHeight: 106,
      imageWidth: 126,
      imageTopPadding: 22,
      onTap: () => bloc.retry(),
    );
  }
}

class SuperHeroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperHeroesList({super.key, required this.title, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final List<SuperheroInfo> superheroes = snapshot.data!;
          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //physics: ClampingScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: superheroes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 90, bottom: 12),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: SuperHeroesColor.whiteText),
                  ),
                );
              }

              final SuperheroInfo item = superheroes[index - 1];
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SuperheroCard(
                    superheroInfo: item,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SuperheroPage(
                            id: item.name,
                          ),
                        ),
                      );
                    },
                  ));
            },
          );
        });
  }
}

class MainPageStateWidget extends StatelessWidget {
  final FocusNode textFieldSearchFocusNode;

  const MainPageStateWidget(
      {super.key, required this.textFieldSearchFocusNode});

  @override
  Widget build(BuildContext context) {
    //final MainBloc bloc = MainBlocHolder.of(context).bloc;
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
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
            return Stack(
              children: [
                NoFavorites(textFieldSearchFocusNode: textFieldSearchFocusNode),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ActionButton(
                      text: 'Remove',
                      onTap: bloc.removeFavorite,
                    ),
                  ),
                ),
              ],
            );
          case MainPageState.minSymbols:
            return const MinSymbols();
          case MainPageState.nothingFound:
            return NothingFound(
              textFieldSearchFocusNode: textFieldSearchFocusNode,
            );
          case MainPageState.loadingError:
            return const LoadingError();
          case MainPageState.searchResults:
            return SuperHeroesList(
              title: 'Search results',
              stream: bloc.observeSearchedSuperheroes(),
            );
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperHeroesList(
                  title: 'Your favorites',
                  stream: bloc.observeFavoriteSuperheroes(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ActionButton(
                      text: 'Remove',
                      onTap: bloc.removeFavorite,
                    ),
                  ),
                ),
              ],
            );
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
