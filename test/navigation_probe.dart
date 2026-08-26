// Reaches the screens that cannot be constructed from a test at all: the
// private ones (`_FooDetailPage`, unreachable by name from outside their
// library) and the detail pages whose constructors need real domain objects.
//
// Both kinds are opened the same way in the app - by tapping a tile on a parent
// page - so this probe does exactly that: it pumps the parent, taps one
// tappable, and measures whatever screen that opened. Each tap starts from a
// freshly pumped parent so one tap's state cannot leak into the next.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'probe_support.dart';
import 'package:jiyan_learning/view/culture/festival_learning_page.dart';
import 'package:jiyan_learning/view/culture/folk_tales_page.dart';
import 'package:jiyan_learning/view/digital_literacy/computer_awareness_page.dart';
import 'package:jiyan_learning/view/digital_literacy/digital_etiquette_page.dart';
import 'package:jiyan_learning/view/digital_literacy/internet_safety_page.dart';
import 'package:jiyan_learning/view/digital_literacy/keyboard_mouse_page.dart';
import 'package:jiyan_learning/view/early_learning/activity_based_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/kinesthetic_learning_page.dart';
import 'package:jiyan_learning/view/early_learning/play_based_learning_page.dart';
import 'package:jiyan_learning/view/executive_function/goal_setting_page.dart';
import 'package:jiyan_learning/view/executive_function/planning_skills_page.dart';
import 'package:jiyan_learning/view/executive_function/task_sequencing_page.dart';
import 'package:jiyan_learning/view/executive_function/working_memory_page.dart';
import 'package:jiyan_learning/view/knowledge/countries_flags_page.dart';
import 'package:jiyan_learning/view/knowledge/famous_places_page.dart';
import 'package:jiyan_learning/view/knowledge/global_cultures_page.dart';
import 'package:jiyan_learning/view/knowledge/science_basics_page.dart';
import 'package:jiyan_learning/view/knowledge/world_map_page.dart';
import 'package:jiyan_learning/view/learn%20set/rhymes_page.dart';
import 'package:jiyan_learning/view/learn%20set/stories_page.dart';
import 'package:jiyan_learning/view/life_skills/hygiene_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/money_habits_page.dart';
import 'package:jiyan_learning/view/life_skills/safety_skills_page.dart';
import 'package:jiyan_learning/view/life_skills/time_management_page.dart';
import 'package:jiyan_learning/view/poem/poem_page.dart';
import 'package:jiyan_learning/view/projects/diy_learning_page.dart';
import 'package:jiyan_learning/view/stem/design_thinking_page.dart';

/// Which of a parent's target screens are currently mounted.
Set<String> _targetsOnScreen(WidgetTester tester, _Parent parent) {
  final found = <String>{};
  for (final w in tester.allWidgets) {
    final name = w.runtimeType.toString();
    if (parent.reaches.contains(name)) found.add(name);
  }
  return found;
}

/// A page the probe can build, and the screens reachable by tapping through it.
class _Parent {
  const _Parent(this.name, this.build, this.reaches, {this.hints = const []});
  final String name;
  final Widget Function() build;
  final List<String> reaches;

  /// Tile captions to press by name. Index-based crawling misses a tile that
  /// lives behind a tab, because an off-stage tab page is still in the tree but
  /// cannot be tapped where it is drawn.
  final List<String> hints;
}

final List<_Parent> _parents = [
  _Parent('FestivalLearningPage', () => FestivalLearningPage(), [
    'FestivalDetailPage',
  ]),
  _Parent('FolkTalesPage', () => const FolkTalesPage(), [
    'StoryDetailPage',
  ]),
  _Parent('ComputerAwarenessPage', () => ComputerAwarenessPage(), [
    '_ComputerBasicsDetailPage',
  ]),
  _Parent('DigitalEtiquettePage', () => DigitalEtiquettePage(), [
    '_DigitalEtiquetteDetailPage',
  ]),
  _Parent('InternetSafetyPage', () => InternetSafetyPage(), [
    '_InternetSafetyDetailPage',
  ]),
  _Parent('KeyboardMousePage', () => KeyboardMousePage(), [
    '_KeyboardMouseDetailPage',
  ]),
  _Parent('ActivityBasedLearningPage', () => ActivityBasedLearningPage(), [
    '_CountingActivityScreen',
    '_MatchingActivityScreen',
    '_PatternActivityScreen',
  ]),
  _Parent('KinestheticLearningPage', () => KinestheticLearningPage(), [
    '_DragDropScreen',
    '_SwipingScreen',
    '_TappingScreen',
    '_TracingScreen',
  ]),
  _Parent(
    'PlayBasedLearningPage',
    () => PlayBasedLearningPage(),
    ['_ColorPopScreen', '_MemoryGameScreen', '_NumberJumpScreen'],
    hints: ['Color Pop', 'Number Jump', 'Card Match'],
  ),
  _Parent('GoalSettingPage', () => GoalSettingPage(), [
    '_GoalSettingDetailPage',
  ]),
  _Parent('PlanningSkillsPage', () => PlanningSkillsPage(), [
    '_PlanningSkillsDetailPage',
  ]),
  _Parent('TaskSequencingPage', () => TaskSequencingPage(), [
    '_TaskSequencingDetailPage',
  ]),
  _Parent('WorkingMemoryPage', () => WorkingMemoryPage(), [
    '_WorkingMemoryDetailPage',
  ]),
  _Parent('CountriesFlagsPage', () => CountriesFlagsPage(), [
    'CountryDetailPage',
  ]),
  _Parent('FamousPlacesPage', () => FamousPlacesPage(), [
    'PlaceDetailPage',
  ]),
  _Parent('GlobalCulturesPage', () => GlobalCulturesPage(), [
    'CultureDetailPage',
  ]),
  _Parent('ScienceBasicsPage', () => ScienceBasicsPage(), [
    'ScienceTopicDetailPage',
  ]),
  _Parent('WorldMapPage', () => WorldMapPage(), [
    'ContinentDetailPage',
  ]),
  _Parent('RhymesPage', () => RhymesPage(), [
    'RhymeDetailPage',
  ]),
  _Parent('StoriesPage', () => StoriesPage(), [
    'StoryDetailPage',
  ]),
  _Parent('HygieneHabitsPage', () => HygieneHabitsPage(), [
    '_HygieneDetailPage',
  ]),
  _Parent('MoneyHabitsPage', () => MoneyHabitsPage(), [
    '_MoneyHabitsDetailPage',
  ]),
  _Parent('SafetySkillsPage', () => SafetySkillsPage(), [
    '_SafetySkillsDetailPage',
  ]),
  _Parent('TimeManagementPage', () => TimeManagementPage(), [
    '_TimeManagementDetailPage',
  ]),
  _Parent('PoemListPage', () => PoemListPage(), [
    'PoemDetailPage',
  ]),
  _Parent('DiyLearningPage', () => DiyLearningPage(), [
    '_DiyLearningDetailPage',
  ]),
  _Parent('DesignThinkingPage', () => DesignThinkingPage(), [
    '_DesignThinkingDetailPage',
  ]),
];

/// How many tiles to try per parent. A tile can sit anywhere in a long grid or
/// behind a tab, so this is generous; the loop stops as soon as the parent runs
/// out of tappables.
const int _maxTapsPerParent = 40;

/// Tabs to walk per parent, including the one selected on arrival.
const int _maxTabs = 6;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(initProbeBinding);
  setUp(() {
    Get.reset();
    Get.testMode = true;
    registerProbeServices();
  });

  final reached = <String>{};
  final issues = <String>[];
  final crawled = <String>[];

  for (final device in probeDevices) {
    for (final parent in _parents) {
      testWidgets('${device.label} | via ${parent.name}', (tester) async {
        // Named tiles first, then the positional sweep.
        for (final hint in parent.hints) {
          applyDevice(tester, device);
          addTearDown(tester.view.reset);
          final previous = FlutterError.onError;
          final reports = <String>[];
          FlutterError.onError = (d) => reports.add(d.toString());
          try {
            await tester.pumpWidget(probeApp(device, parent.build()));
            await tester.pump(const Duration(milliseconds: 300));
            final label = find.text(hint);
            if (label.evaluate().isEmpty) continue;
            await tester.tap(label.first, warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 400));
            var onScreen = _targetsOnScreen(tester, parent);
            if (onScreen.isEmpty) {
              final confirm = find.text('Play');
              if (confirm.evaluate().isNotEmpty) {
                await tester.tap(confirm.first, warnIfMissed: false);
                await tester.pump(const Duration(milliseconds: 400));
                await tester.pump(const Duration(milliseconds: 400));
                onScreen = _targetsOnScreen(tester, parent);
              }
            }
            if (onScreen.isEmpty) continue;
            reached.addAll(onScreen);
            crawled.add('${device.label} | ${onScreen.join(", ")}');
            for (final view in tester.binding.renderViews) {
              if (hasErrorBox(view)) continue;
              for (final issue in scanOverflow(view)) {
                issues.add('${device.label} | ${onScreen.join(", ")}'
                    '${_where(reports)}  ->  $issue');
              }
            }
          } catch (_) {
            // Not drivable headlessly; not a layout finding.
          } finally {
            FlutterError.onError = previous;
          }
          while (tester.takeException() != null) {}
        }

        for (var tabIndex = 0; tabIndex < _maxTabs; tabIndex++) {
        for (var tap = 0; tap < _maxTapsPerParent; tap++) {
          applyDevice(tester, device);
          addTearDown(tester.view.reset);

          final previous = FlutterError.onError;
          final reports = <String>[];
          FlutterError.onError = (d) => reports.add(d.toString());
          try {
            await tester.pumpWidget(probeApp(device, parent.build()));
            await tester.pump(const Duration(milliseconds: 300));

            // Several parents keep half their tiles behind a tab, so the tab is
            // selected before the tiles underneath it are counted.
            final tabs = find.byType(Tab);
            final tabCount = tabs.evaluate().length;
            if (tabIndex > 0) {
              if (tabIndex >= tabCount) break;
              await tester.tap(tabs.at(tabIndex), warnIfMissed: false);
              await tester.pump(const Duration(milliseconds: 400));
            }

            // Anything a child could press. A tile is as often a Card with an
            // InkWell, or a plain button, as it is a GestureDetector.
            final tappables = find.byWidgetPredicate(
              (w) =>
                  w is GestureDetector ||
                  w is InkResponse ||
                  w is ListTile ||
                  w is ButtonStyleButton ||
                  w is RawMaterialButton ||
                  w is IconButton,
            );
            final count = tappables.evaluate().length;
            if (tap >= count) break;

            final target = tappables.at(tap);
            // A tile further down a grid is off-screen until it is scrolled to.
            try {
              await tester.ensureVisible(target);
              await tester.pump(const Duration(milliseconds: 100));
            } catch (_) {
              // Not inside a scrollable, or already visible.
            }
            await tester.tap(target, warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 400));
            await tester.pump(const Duration(milliseconds: 400));

            var onScreen = _targetsOnScreen(tester, parent);

            // Some tiles open a confirm sheet first ("Play", "Start", "View"),
            // and the screen only appears after that second press.
            if (onScreen.isEmpty) {
              final confirm = find.byWidgetPredicate((w) {
                if (w is! Text) return false;
                final t = (w.data ?? '').trim().toLowerCase();
                return t == 'play' ||
                    t == 'start' ||
                    t == 'view' ||
                    t == 'open' ||
                    t == 'continue' ||
                    t == "let's go!" ||
                    t == 'go';
              });
              if (confirm.evaluate().isNotEmpty) {
                await tester.tap(confirm.first, warnIfMissed: false);
                await tester.pump(const Duration(milliseconds: 400));
                await tester.pump(const Duration(milliseconds: 400));
                onScreen = _targetsOnScreen(tester, parent);
              }
            }
            if (onScreen.isEmpty) continue;
            reached.addAll(onScreen);
            crawled.add('${device.label} | ${onScreen.join(", ")}');

            for (final view in tester.binding.renderViews) {
              if (hasErrorBox(view)) continue;
              for (final issue in scanOverflow(view)) {
                issues.add('${device.label} | ${onScreen.join(", ")}'
                    '${_where(reports)}  ->  $issue');
              }
            }
          } catch (_) {
            // A tile that cannot be driven headlessly is not a layout finding.
          } finally {
            FlutterError.onError = previous;
          }
          while (tester.takeException() != null) {}
        }
        }
      });
    }
  }

  // The three play screens sit behind a named tab and a confirm sheet, which the
  // positional sweep cannot reach: an off-stage tab page is in the tree but
  // cannot be tapped where it is drawn.
  const playTargets = {
    'Memory Games': ['Card Match', '_MemoryGameScreen'],
    'Action Games': ['Color Pop', '_ColorPopScreen'],
    'Action Games ': ['Number Jump', '_NumberJumpScreen'],
  };
  for (final device in probeDevices) {
    for (final entry in playTargets.entries) {
      final tabName = entry.key.trim();
      final tile = entry.value[0];
      final screen = entry.value[1];
      testWidgets('${device.label} | play $tile', (tester) async {
        applyDevice(tester, device);
        addTearDown(tester.view.reset);
        final previous = FlutterError.onError;
        final reports = <String>[];
        FlutterError.onError = (d) => reports.add(d.toString());
        try {
          await tester.pumpWidget(probeApp(device, PlayBasedLearningPage()));
          await tester.pump(const Duration(milliseconds: 300));

          // The tab strip scrolls, so a later tab is off-screen until the
          // strip is scrolled to it.
          final tab = find.widgetWithText(Tab, tabName);
          if (tab.evaluate().isNotEmpty) {
            try {
              await tester.ensureVisible(tab.first);
              await tester.pump(const Duration(milliseconds: 200));
            } catch (_) {
              // Already visible.
            }
            await tester.tap(tab.first, warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 500));
            await tester.pump(const Duration(milliseconds: 500));
          }
          final card = find.text(tile);
          if (card.evaluate().isEmpty) return;
          await tester.ensureVisible(card.first);
          await tester.pump(const Duration(milliseconds: 100));
          await tester.tap(card.first, warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));

          final play = find.text('Play');
          if (play.evaluate().isNotEmpty) {
            await tester.tap(play.first, warnIfMissed: false);
            await tester.pump(const Duration(milliseconds: 500));
            await tester.pump(const Duration(milliseconds: 500));
          }

          final present = tester.allWidgets
              .map((w) => w.runtimeType.toString())
              .contains(screen);
          if (!present) return;
          reached.add(screen);
          for (final view in tester.binding.renderViews) {
            if (hasErrorBox(view)) continue;
            for (final issue in scanOverflow(view)) {
              issues.add('${device.label} | $screen${_where(reports)}'
                  '  ->  $issue');
            }
          }
        } catch (_) {
          // Not drivable headlessly; not a layout finding.
        } finally {
          FlutterError.onError = previous;
        }
        while (tester.takeException() != null) {}
      });
    }
  }

  tearDownAll(() {
    final targets = <String>{
      for (final p in _parents) ...p.reaches,
      for (final v in playTargets.values) v[1],
    };
    debugPrint('\n========== NAVIGATION PROBE ==========');
    debugPrint('target screens      : ${targets.length}');
    debugPrint('reached by tapping  : ${reached.length}');
    debugPrint('overflow findings   : ${issues.length}');
    debugPrint('\n--- NOT REACHED ---');
    for (final t in targets.difference(reached).toList()..sort()) {
      debugPrint('  $t');
    }
    debugPrint('\n--- OVERFLOWING ---');
    for (final i in issues.toSet().toList()..sort()) {
      debugPrint('  $i');
    }
    debugPrint('======================================');
  });
}


/// Source locations harvested from Flutter's own first-frame overflow reports,
/// which are the only place a file:line is available.
String _where(List<String> reports) {
  final seen = <String>{};
  for (final m in RegExp(r'(lib/[^\s:]+\.dart):(\d+)').allMatches(reports.join('\n'))) {
    seen.add('${m.group(1)}:${m.group(2)}');
  }
  return seen.isEmpty ? '' : '  @ ${seen.join(", ")}';
}
