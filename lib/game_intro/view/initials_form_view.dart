import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/game_intro/formatters/formatters.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsFormView extends StatefulWidget {
  const InitialsFormView({super.key});

  @override
  State<InitialsFormView> createState() => _InitialsFormViewState();
}

class _InitialsFormViewState extends State<InitialsFormView> {
  final focusNodes = List.generate(3, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<GameIntroBloc, GameIntroState>(
      listener: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.blacklisted) {
          focusNodes.last.requestFocus();
        }
      },
      builder: (context, state) {
        if (state.initialsStatus == InitialsFormStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InitialFormField(
                  0,
                  focusNode: focusNodes[0],
                  key: ObjectKey(focusNodes[0]),
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: 16),
                InitialFormField(
                  1,
                  key: ObjectKey(focusNodes[1]),
                  focusNode: focusNodes[1],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
                const SizedBox(width: 16),
                InitialFormField(
                  2,
                  key: ObjectKey(focusNodes[2]),
                  focusNode: focusNodes[2],
                  onChanged: (index, value) {
                    _onInitialChanged(context, value, index);
                  },
                  onBackspace: (index) {
                    _onInitialChanged(context, '', index, isBackspace: true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.initialsStatus == InitialsFormStatus.blacklisted)
              _ErrorTextWidget(l10n.initialsBlacklistedMessage)
            else if (state.initialsStatus == InitialsFormStatus.invalid)
              _ErrorTextWidget(l10n.initialsErrorMessage)
            else if (state.initialsStatus == InitialsFormStatus.failure)
              _ErrorTextWidget(l10n.initialsSubmissionErrorMessage),
          ],
        );
      },
    );
  }

  void _onInitialChanged(
    BuildContext context,
    String value,
    int index, {
    bool isBackspace = false,
  }) {
    var text = value;
    if (text == emptyCharacter) {
      text = '';
    }

    context
        .read<GameIntroBloc>()
        .add(InitialsUpdated(character: text, index: index));
    if (text.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      }
    } else if (index > 0) {
      if (isBackspace) {
        setState(() {
          focusNodes[index - 1] = FocusNode();
        });

        SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        });
      }
    }
  }
}

class InitialFormField extends StatefulWidget {
  @visibleForTesting
  const InitialFormField(
    this.index, {
    required this.onChanged,
    required this.focusNode,
    required this.onBackspace,
    super.key,
  });

  final int index;
  final void Function(int, String) onChanged;
  final void Function(int) onBackspace;
  final FocusNode focusNode;

  @override
  State<InitialFormField> createState() => _InitialFormFieldState();
}

class _InitialFormFieldState extends State<InitialFormField> {
  late final TextEditingController controller =
      TextEditingController.fromValue(lastValue);

  bool hasFocus = false;
  TextEditingValue lastValue = const TextEditingValue(
    text: emptyCharacter,
    selection: TextSelection.collapsed(offset: 1),
  );

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if (mounted) {
      final hadFocus = hasFocus;
      final willFocus = widget.focusNode.hasPrimaryFocus;

      setState(() {
        hasFocus = willFocus;
      });

      if (!hadFocus && willFocus) {
        final text = controller.text;
        final selection = TextSelection.collapsed(offset: text.length);
        controller.selection = selection;
      }
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(onFocusChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialsStatus =
        context.select((GameIntroBloc bloc) => bloc.state.initialsStatus);
    final blacklisted = initialsStatus == InitialsFormStatus.blacklisted;
    final isFilled = RegExp('[A-Z]').hasMatch(controller.text);

    final mascot =
        context.select((GameIntroBloc bloc) => bloc.state.selectedMascot);

    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: isFilled ? mascot.color : Colors.transparent,
      border: Border.all(
        color: blacklisted
            ? IoCrosswordColors.seedRed
            : widget.focusNode.hasPrimaryFocus
                ? IoCrosswordColors.accessibleBlack
                : mascot.color,
        width: 3,
      ),
    );

    return SizedBox(
      width: 58,
      height: 58,
      child: DecoratedBox(
        decoration: decoration,
        child: TextFormField(
          key: Key('initial_form_field_${widget.index}'),
          controller: controller,
          autofocus: widget.index == 0,
          focusNode: widget.focusNode,
          showCursor: false,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            BackspaceFormatter(
              onBackspace: () => widget.onBackspace(widget.index),
            ),
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
            UpperCaseTextFormatter(),
            JustOneCharacterFormatter((value) {
              widget.onChanged(widget.index, value);
            }),
            EmptyCharacterAtEndFormatter(),
          ],
          style: IoCrosswordTextStyles.gridLetter,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            widget.onChanged(widget.index, value);
          },
        ),
      ),
    );
  }
}

class _ErrorTextWidget extends StatelessWidget {
  const _ErrorTextWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          color: IoCrosswordColors.seedRed,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}