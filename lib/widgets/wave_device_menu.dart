import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:md_ui_kit/_core/colors.dart';
import 'package:md_ui_kit/_core/precached_icons.dart';
import 'package:md_ui_kit/md_ui_kit.dart';

class WaveDeviceMenu extends StatefulWidget {
  const WaveDeviceMenu({
    Key? key,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  final List<String> items;
  final VoidCallback? onChanged;

  @override
  State<WaveDeviceMenu> createState() => _WaveDeviceMenuState();
}

class _WaveDeviceMenuState extends State<WaveDeviceMenu>
    with SingleTickerProviderStateMixin {
  static const double height = 50;
  static const double borderRadius = 12;
  static const double borderWidth = 2;
  static const EdgeInsets padding =
      EdgeInsets.only(left: 16, top: 11, bottom: 11);
  static const EdgeInsets dividerPadding = EdgeInsets.symmetric(horizontal: 16);

  bool _isOpen = false;
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.items.isNotEmpty ? widget.items.first : '';
  }

  void _toggleDropdown() => setState(() => _isOpen = !_isOpen);

  void _selectItem(String item) {
    setState(() {
      _selectedItem = item;
      _isOpen = false;
    });
    widget.onChanged;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        _isOpen ? MdColors.textButtonHover : MdColors.notificationsSelectedBg;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: WaveText(
                    _selectedItem,
                    type: WaveTextType.subtitle,
                    color: MdColors.textButtonDefault,
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    PrecachedIcons.deviceMenuArrow,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(
                      MdColors.textButtonDefault,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOpen) const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: _isOpen ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: _isOpen
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: MdColors.textButtonHover,
                      width: borderWidth,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < widget.items.length; i++) ...[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _selectItem(widget.items[i]),
                          child: Padding(
                            padding: padding,
                            child: WaveText(
                              widget.items[i],
                              type: WaveTextType.subtitle,
                              color: MdColors.textButtonDefault,
                            ),
                          ),
                        ),
                        if (i != widget.items.length - 1)
                          const Padding(
                            padding: dividerPadding,
                            child: Divider(
                              height: 1,
                              thickness: 1,
                              color: MdColors.textButtonHover,
                            ),
                          ),
                      ],
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
