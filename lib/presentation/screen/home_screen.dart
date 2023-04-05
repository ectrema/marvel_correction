import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:marvel_app/presentation/screen/detail_character/detail_screen.dart';
import 'package:marvel_app/presentation/viewmodel/home_viewmodel.dart';
import 'package:marvel_app/presentation/widget/shimmer_loader.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personnage'),
        centerTitle: true,
      ),
      body: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeViewModel viewModel = Provider.of<HomeViewModel>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 24,
                  mainAxisExtent: 200,
                ),
                itemBuilder: (_, int index) {
                  if (index >= viewModel.characters.length) {
                    return ShimmerLoading(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final character = viewModel.characters[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DetailsScreen(character: character))),
                    child: Column(
                      children: <Widget>[
                        if (character.thumbnail != null)
                          ValueListenableBuilder<Box<Uint8List>>(
                            valueListenable: viewModel.imageListenable,
                            builder: (BuildContext context,
                                Box<Uint8List> value, Widget? child) {
                              return Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: value.containsKey(
                                            character.id.toString())
                                        ? MemoryImage(value
                                            .get(character.id!.toString())!)
                                        : NetworkImage(
                                            character.thumb ?? '',
                                          ) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(character.name ?? ''),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: viewModel.loading
                    ? viewModel.characters.length + 2
                    : viewModel.characters.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
