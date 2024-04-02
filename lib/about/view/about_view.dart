import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/about/link/about_links.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part 'about_how_to_play.dart';
part 'about_project_details.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  static Future<void> showModal(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const AboutView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Center(
        child: IoCrosswordCard(
          maxHeight: 620,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.aboutCrossword,
                          style: textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CloseButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TabBar(
                  tabs: [
                    Tab(
                      text: l10n.howToPlay,
                    ),
                    Tab(
                      text: l10n.projectDetails,
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      AboutHowToPlayContent(),
                      AboutProjectDetails(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}