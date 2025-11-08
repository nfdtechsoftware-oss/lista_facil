import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget para exibir estado vazio de forma amigável
class EmptyState extends StatelessWidget {
  /// Ícone a ser exibido
  final IconData icon;

  /// Título principal
  final String title;

  /// Subtítulo opcional
  final String? subtitle;

  /// Tamanho do ícone (padrão: extraLarge)
  final double? iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? AppConstants.iconSizeExtraLarge * 2,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
