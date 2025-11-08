import 'package:flutter/material.dart';
import '../models/shopping_item_model.dart';
import '../constants/app_constants.dart';

/// Tile que representa um item individual da lista
class ShoppingItemTile extends StatelessWidget {
  /// Item a ser exibido
  final ShoppingItem item;

  /// Callback ao marcar/desmarcar checkbox
  final ValueChanged<bool?>? onChanged;

  /// Callback ao deletar item
  final VoidCallback? onDelete;

  /// Callback ao editar item (long press)
  final VoidCallback? onEdit;

  const ShoppingItemTile({
    super.key,
    required this.item,
    this.onChanged,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        leading: Checkbox(
          value: item.isDone,
          onChanged: onChanged,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            color: item.isDone ? Colors.grey : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
          color: Colors.grey,
        ),
        onLongPress: onEdit,
      ),
    );
  }
}
