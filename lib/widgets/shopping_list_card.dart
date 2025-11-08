import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../constants/app_constants.dart';

/// Card que representa uma lista de compras na tela inicial
class ShoppingListCard extends StatelessWidget {
  /// Lista a ser exibida
  final ShoppingList shoppingList;

  /// Callback ao tocar no card
  final VoidCallback onTap;

  /// Callback ao pressionar e segurar (long press)
  final VoidCallback? onLongPress;

  const ShoppingListCard({
    super.key,
    required this.shoppingList,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final percentComplete = shoppingList.percentComplete;
    final hasItems = shoppingList.totalItems > 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji e Nome
              Row(
                children: [
                  Text(
                    shoppingList.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Text(
                      shoppingList.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Contador de itens
              Text(
                hasItems
                    ? '${shoppingList.completedItems}/${shoppingList.totalItems} comprados'
                    : 'Nenhum item',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),

              // Barra de progresso
              if (hasItems)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentComplete,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentComplete == 1.0
                          ? Colors.green
                          : AppConstants.primaryGreen,
                    ),
                    minHeight: 6,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
