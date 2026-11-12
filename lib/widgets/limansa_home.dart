import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../widgets/limansa_footer.dart';
import '../widgets/limansa_bar.dart';
import '../widgets/limansa_feed.dart';
import '../models/feed_type.dart';

class HomeState {
  final FeedType currentFeed;
  final Set<FeedType> initializedFeeds;

  const HomeState({
    this.currentFeed = FeedType.newF,
    this.initializedFeeds = const {FeedType.newF},
  });
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectFeed(FeedType newFeed) {
    emit(HomeState(
      currentFeed: newFeed,
      initializedFeeds: {...state.initializedFeeds, newFeed},
    ));
  }
}

class LimansaHome extends StatelessWidget {
  const LimansaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const LimansaBar(),
            body: IndexedStack(
              index: state.currentFeed.index,
              children: FeedType.values.map((type) {
                if (!state.initializedFeeds.contains(type)) {
                  return const SizedBox.shrink();
                }
                return LimansaFeed(type: type);
              }).toList(),
            ),
            bottomNavigationBar: LimansaFooter(
              feed: state.currentFeed,
              onSelect: (newFeed) {
                context.read<HomeCubit>().selectFeed(newFeed);
              },
            ),
          );
        },
      ),
    );
  }
}
