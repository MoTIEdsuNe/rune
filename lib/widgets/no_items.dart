import 'package:fluent_ui/fluent_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../widgets/track_list/track_list.dart';

class NoItems extends StatelessWidget {
  final String title;
  final bool hasRecommendation;
  final PagingController pagingController;
  final bool userGenerated;

  const NoItems({
    super.key,
    required this.title,
    required this.hasRecommendation,
    required this.pagingController,
    this.userGenerated = false,
  });

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return SizedBox.expand(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Symbols.select, size: 48),
            const SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: typography.title),
                const SizedBox(height: 4),
                userGenerated
                    ? const Text("Try creating your own collection")
                    : hasRecommendation
                        ? const Text("These actions may help")
                        : const Text("Try scanning new files"),
              ],
            ),
            if (!userGenerated) ...[
              const SizedBox(height: 24),
              ActionButtons(
                pagingController: pagingController,
                hasRecommendation: hasRecommendation,
              ),
            ]
          ],
        ),
      ),
    );
  }
}