import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../utils/ax_shadow.dart';
import '../../../utils/format_time.dart';
import '../../../utils/fetch_flyout_items.dart';
import '../../../widgets/tile/cover_art.dart';
import '../../../widgets/playback_controller/constants/controller_items.dart';
import '../../../widgets/playback_controller/constants/playback_controller_height.dart';
import '../../../providers/status.dart';
import '../../../providers/volume.dart';
import '../../../providers/playback_controller.dart';
import '../../../providers/responsive_providers.dart';

import 'cover_wall_command_bar.dart';
import 'cover_art_page_progress_bar.dart';

class SmallScreenPlayingTrack extends StatefulWidget {
  const SmallScreenPlayingTrack({super.key});

  @override
  SmallScreenPlayingTrackState createState() => SmallScreenPlayingTrackState();
}

class SmallScreenPlayingTrackState extends State<SmallScreenPlayingTrack> {
  Map<String, MenuFlyoutItem> flyoutItems = {};
  bool initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _fetchFlyoutItems();
  }

  Future<void> _fetchFlyoutItems() async {
    if (initialized) return;
    initialized = true;

    final Map<String, MenuFlyoutItem> itemMap = await fetchFlyoutItems(context);

    if (!context.mounted) {
      return;
    }

    setState(() {
      flyoutItems = itemMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final isDark = theme.brightness.isDark;
    final shadowColor = isDark ? Colors.black : theme.accentColor.lightest;

    final typography = theme.typography;

    final shadows = <Shadow>[
      Shadow(color: shadowColor, blurRadius: 12),
      Shadow(color: shadowColor, blurRadius: 24),
    ];

    final width = MediaQuery.of(context).size.width;

    Provider.of<VolumeProvider>(context);

    return DeviceTypeBuilder(
      deviceType: const [
        DeviceType.car,
        DeviceType.tv,
        DeviceType.zune,
        DeviceType.station
      ],
      builder: (context, activeBreakpoint) {
        final isZune = activeBreakpoint == DeviceType.zune;
        final isCar = activeBreakpoint == DeviceType.car;

        return Selector<PlaybackStatusProvider,
            (String?, String?, String?, String?, double?, String?)>(
          selector: playbackStatusSelector,
          builder: (context, p, child) {
            if (p.$1 == null) return Container();

            final artist = p.$2 ?? "Unknown Artist";
            final album = p.$3 ?? "Unknown Album";

            final result = Container(
              padding: isCar
                  ? const EdgeInsets.fromLTRB(
                      48,
                      12,
                      12,
                      12,
                    )
                  : const EdgeInsets.fromLTRB(
                      12, 12, 12, playbackControllerHeight + 12),
              constraints: isCar
                  ? const BoxConstraints(maxWidth: 240 + 34)
                  : const BoxConstraints(maxWidth: 240),
              child: Column(
                crossAxisAlignment: isCar
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (!isZune && !isCar)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: axShadow(9),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CoverArt(
                            hint: (
                              p.$3 ?? "",
                              p.$2 ?? "",
                              'Total Time ${formatTime(p.$5 ?? 0)}'
                            ),
                            key: p.$1 != null ? Key(p.$1.toString()) : null,
                            path: p.$1,
                            size: (width - 20).clamp(0, 240),
                          ),
                        ),
                      ),
                    ),
                  if (!isZune && !isCar)
                    Transform.translate(
                      offset: const Offset(0, -16),
                      child: SizedBox(
                        height: 80,
                        child: CoverArtPageProgressBar(shadows: shadows),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    p.$4 ?? "Unknown Track",
                    style: typography.subtitle?.apply(shadows: shadows),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$artist · $album',
                    style: typography.body
                        ?.apply(shadows: shadows, heightFactor: 2),
                    textAlign: TextAlign.center,
                  ),
                  if (isZune || isCar) const SizedBox(height: 12),
                  if (isZune || isCar)
                    Selector<PlaybackControllerProvider,
                        (List<ControllerEntry>, List<ControllerEntry>)>(
                      selector: playbackControllerSelector,
                      builder: (context, entries, child) {
                        return CoverWallCommandBar(
                          entries: entries,
                          flyoutItems: flyoutItems,
                          shadows: shadows,
                        );
                      },
                    ),
                ],
              ),
            );

            return result;
          },
        );
      },
    );
  }

  (String?, String?, String?, String?, double?, String?) playbackStatusSelector(
          context, playbackStatusProvider) =>
      (
        playbackStatusProvider.playbackStatus?.coverArtPath,
        playbackStatusProvider.playbackStatus?.artist,
        playbackStatusProvider.playbackStatus?.album,
        playbackStatusProvider.playbackStatus?.title,
        playbackStatusProvider.playbackStatus?.duration,
        playbackStatusProvider.playbackStatus?.state,
      );

  (List<ControllerEntry>, List<ControllerEntry>) playbackControllerSelector(
      context, controllerProvider) {
    final entries = controllerProvider.entries;
    final hiddenIndex = entries.indexWhere((entry) => entry.id == 'hidden');
    final List<ControllerEntry> visibleEntries =
        hiddenIndex != -1 ? entries.sublist(0, hiddenIndex) : entries;
    final List<ControllerEntry> hiddenEntries =
        hiddenIndex != -1 ? entries.sublist(hiddenIndex + 1) : [];

    return (visibleEntries, hiddenEntries);
  }
}
