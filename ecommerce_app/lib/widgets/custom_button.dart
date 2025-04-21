import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidget = isOutlined 
      ? OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
          ),
          child: _buildButtonContent(),
        ) 
      : ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: isFullWidth ? const Size(double.infinity, 56) : null,
          ),
          child: _buildButtonContent(),
        );
        
    return buttonWidget;
  }
  
  Widget _buildButtonContent() {
    return isLoading
      ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
          ),
        )
      : icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: AppTheme.spacingS),
              Text(text),
            ],
          )
        : Text(text);
  }
}