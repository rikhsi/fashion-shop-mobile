import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class OtpInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  const OtpInput({
    super.key,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  static const _length = AppConstants.otpLength;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    final otp = _otp;
    widget.onChanged?.call(otp);
    if (otp.length == _length) widget.onCompleted?.call(otp);
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      widget.onChanged?.call(_otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_length, _buildCell),
    );
  }

  Widget _buildCell(int index) {
    return _FocusAwareBuilder(
      focusNode: _focusNodes[index],
      builder: (hasFocus) {
        final scheme = Theme.of(context).colorScheme;
        final hasValue = _controllers[index].text.isNotEmpty;

        return Container(
          width: 48,
          height: 56,
          margin: EdgeInsets.only(right: index < _length - 1 ? 8 : 0),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _onKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              enabled: widget.enabled,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: AppTextStyles.displayMedium.copyWith(
                color: scheme.onSurface,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: hasValue
                    ? scheme.primaryContainer
                    : scheme.outlineVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: hasFocus
                        ? scheme.primary
                        : hasValue
                            ? scheme.primary.withValues(alpha: 0.3)
                            : scheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: hasValue
                        ? scheme.primary.withValues(alpha: 0.3)
                        : scheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide(
                    color: scheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (v) => _onChanged(index, v),
            ),
          ),
        );
      },
    );
  }
}

class _FocusAwareBuilder extends StatefulWidget {
  final FocusNode focusNode;
  final Widget Function(bool hasFocus) builder;

  const _FocusAwareBuilder({
    required this.focusNode,
    required this.builder,
  });

  @override
  State<_FocusAwareBuilder> createState() => _FocusAwareBuilderState();
}

class _FocusAwareBuilderState extends State<_FocusAwareBuilder> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) =>
      widget.builder(widget.focusNode.hasFocus);
}
