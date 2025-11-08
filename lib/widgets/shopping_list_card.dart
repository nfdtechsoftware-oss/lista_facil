import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

/// Card que representa uma lista de compras na tela inicial
class ShoppingListCard extends StatelessWidget {
  /// Lista a ser exibida
  final ShoppingList shoppingList;

  /// Callback ao tocar no card
  final VoidCallback onTap;

  /// Callback ao editar a lista
  final VoidCallback? onEdit;

  /// Callback ao deletar a lista
  final VoidCallback? onDelete;

  const ShoppingListCard({
    super.key,
    required this.shoppingList,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentComplete = shoppingList.percentComplete;
    final hasItems = shoppingList.totalItems > 0;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji, Nome e Menu
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
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.editList),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 20, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(l10n.deleteList, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              // Contador de itens
              Text(
                hasItems
                    ? l10n.completedCount(shoppingList.completedItems, shoppingList.totalItems)
                    : l10n.emptyList,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),

              // Barra de progresso (altura fixa para manter cards uniformes)
              SizedBox(
                height: 6,
                child: hasItems
                    ? ClipRRect(
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
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
