import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marvel_app/data/model/character.dart';
import 'package:marvel_app/presentation/viewmodel/detail_character/detail_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  final Character character;
  const DetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return DetailsViewModel.buildWithProvider(
      builder: (_, __) => const DetailsContent(),
      selectedCharacter: character,
    );
  }
}

class DetailsContent extends StatelessWidget {
  const DetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(context.read<DetailsViewModel>().selectedCharacter.name ?? ''),
        centerTitle: true,
        actions: <Widget>[
          ValueListenableBuilder<Box>(
            valueListenable:
                context.read<DetailsViewModel>().characterListenable,
            builder: (_, box, __) => IconButton(
              onPressed: context.read<DetailsViewModel>().handleFavPressed,
              icon: box.containsKey(context
                      .read<DetailsViewModel>()
                      .selectedCharacter
                      .id
                      .toString())
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
            ),
          ),
        ],
      ),
      body: Selector<DetailsViewModel, bool>(
        selector: (_, viewModel) => viewModel.loading,
        builder: (_, loading, __) => loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const _DetailsBody(),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DetailsViewModel viewModel =
        Provider.of<DetailsViewModel>(context, listen: false);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    ValueListenableBuilder<Box<Uint8List>>(
                      valueListenable: viewModel.imageListenable,
                      builder: (BuildContext context, Box<Uint8List> value,
                          Widget? child) {
                        if (value.containsKey(
                            viewModel.selectedCharacter.id.toString())) {
                          return Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(
                                  value.get(viewModel.selectedCharacter.id!
                                      .toString())!,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  viewModel.selectedCharacter.thumb ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    if (viewModel.selectedCharacter.description?.isNotEmpty ==
                        true)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(viewModel.selectedCharacter.description!),
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              sliver: SliverToBoxAdapter(
                child: ExpansionTile(
                  title: const Text('Apparition dans les comics'),
                  children: [
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.comics.length,
                        itemBuilder: (_, index) {
                          final comic = viewModel.comics[index];
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 200,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        comic.thumb ?? '',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    comic.title ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
