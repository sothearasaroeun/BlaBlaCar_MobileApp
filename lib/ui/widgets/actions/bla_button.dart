import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class BlaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary; 
  final IconData? icon; 

  const BlaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(
                icon,
                size: 20,
                color: isPrimary ? BlaColors.white : BlaColors.primary,
              )
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: BlaTextStyles.button.copyWith(
            color: isPrimary ? BlaColors.white : BlaColors.primary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? BlaColors.primary : BlaColors.white,
          foregroundColor: isPrimary ? BlaColors.white : BlaColors.primary,
          disabledBackgroundColor: BlaColors.disabled,
          disabledForegroundColor: BlaColors.textLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: BlaColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
