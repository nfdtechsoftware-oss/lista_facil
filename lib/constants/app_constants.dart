import 'package:flutter/material.dart';

/// Constantes da aplicação
class AppConstants {
  // Cores
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF4CAF50);

  // Limites
  static const int maxListNameLength = 30;
  static const int maxItemNameLength = 50;
  static const int maxListsCount = 20;

  // Durações de animação
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Espaçamentos
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Ícones de tamanho
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;

  // Keys de armazenamento
  static const String storageKeyLists = 'shopping_lists';
  static const String storageKeyActiveList = 'active_list_id';

  // Construtor privado para evitar instanciação
  AppConstants._();
}
