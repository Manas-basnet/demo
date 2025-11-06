import 'package:flutter/material.dart';

class AutocompleteDropdown<T> extends StatefulWidget {
  final String label;
  final List<({String text, T value})> items;
  final T? value;
  final void Function(T?)? onChanged;
  final bool enabled;
  final bool isLoading;

  final bool isError;
  final VoidCallback? onRetry;

  const AutocompleteDropdown({
    Key? key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.isLoading = false,
    this.isError = false,
    this.onRetry,
  }) : super(key: key);

  @override
  State<AutocompleteDropdown<T>> createState() =>
      _AutocompleteDropdownState<T>();
}

class _AutocompleteDropdownState<T> extends State<AutocompleteDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String getTextForValue(T? value) {
      if (value == null) return '';
      final item = widget.items
          .where((item) => item.value == value)
          .firstOrNull;
      return item?.text ?? '';
    }

    Widget buildSuffix() {
      if (widget.isError) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'There was a problem',
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: widget.onRetry,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (widget.isLoading) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }

      return Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Autocomplete<({String text, T value})>(
        initialValue: TextEditingValue(text: getTextForValue(widget.value)),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return widget.items;
          }
          return widget.items.where((item) {
            return item.text.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        },
        displayStringForOption: (item) => item.text,
        onSelected: (selection) {
          if (widget.enabled && widget.onChanged != null) {
            widget.onChanged!(selection.value);
          }
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && controller.text != getTextForValue(widget.value)) {
              controller.text = getTextForValue(widget.value);
            }
          });

          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: widget.enabled,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 0.2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              filled: true,
              fillColor: widget.enabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              suffixIcon: buildSuffix(),
              // Allow room for the Retry button in the suffix
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
            onFieldSubmitted: (value) {
              final matchingItem = widget.items
                  .where((item) => item.text == value)
                  .firstOrNull;
              if (matchingItem != null) {
                onFieldSubmitted();
                if (widget.enabled && widget.onChanged != null) {
                  widget.onChanged!(matchingItem.value);
                }
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    controller.clear();
                    if (widget.enabled && widget.onChanged != null) {
                      widget.onChanged!(null);
                    }
                  }
                });
              }
            },
            onChanged: (value) {
              if (!focusNode.hasFocus &&
                  value.isNotEmpty &&
                  !widget.items.any((item) => item.text == value)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    controller.clear();
                    if (widget.enabled && widget.onChanged != null) {
                      widget.onChanged!(null);
                    }
                  }
                });
              }
            },
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                width: MediaQuery.of(context).size.width - 48,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 0.1,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Text(
                          option.text,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
