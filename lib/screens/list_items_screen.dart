import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../models/shopping_item_model.dart';
import '../services/storage_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/shopping_item_tile.dart';
import '../widgets/confirm_dialog.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

/// Tela que exibe e gerencia os itens de uma lista específica
class ListItemsScreen extends StatefulWidget {
  final ShoppingList list;

  const ListItemsScreen({
    super.key,
    required this.list,
  });

  @override
  State<ListItemsScreen> createState() => _ListItemsScreenState();
}

class _ListItemsScreenState extends State<ListItemsScreen> {
  late ShoppingList _list;
  List<ShoppingItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _list = widget.list;
    _filteredItems = List.from(_list.items);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Salva a lista atual
  Future<void> _saveList() async {
    await StorageService.saveList(_list);
  }

  /// Adiciona um novo item à lista
  Future<void> _addItem() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    final itemName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addItem),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.itemName,
            hintText: l10n.itemName,
          ),
          autofocus: true,
          maxLength: AppConstants.maxItemNameLength,
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, value.trim());
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (itemName != null && itemName.isNotEmpty && mounted) {
      setState(() {
        final newItem = ShoppingItem(name: itemName);
        _list.addItem(newItem);
        _applySearch();
      });
      await _saveList();
    }
  }

  /// Toggle status de um item (comprado/não comprado)
  void _toggleItem(ShoppingItem item) {
    setState(() {
      _list.toggleItem(item.id);
    });
    _saveList();
  }

  /// Remove um item da lista
  void _deleteItem(ShoppingItem item) {
    setState(() {
      _list.removeItem(item.id);
      _applySearch();
    });
    _saveList();
  }

  /// Remove todos os itens comprados da lista
  Future<void> _clearCompletedItems() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: l10n.clearCompleted,
        message: l10n.clearCompletedConfirm,
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _list.items.removeWhere((item) => item.isDone);
        _applySearch();
      });
      await _saveList();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.itemsCleared),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Filtra itens baseado na busca
  void _applySearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_list.items);
      } else {
        _filteredItems = _list.items
            .where((item) => item.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasItems = _list.items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_list.emoji),
            const SizedBox(width: AppConstants.paddingSmall),
            Flexible(
              child: Text(
                _list.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (hasItems && _list.completedItems > 0 && !_isSearching)
            IconButton(
              icon: const Icon(Icons.cleaning_services_outlined),
              tooltip: l10n.clearCompleted,
              onPressed: _clearCompletedItems,
            ),
          if (hasItems)
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _applySearch();
                  }
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Campo de busca
          if (_isSearching && hasItems)
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchItems,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _applySearch();
                          },
                        )
                      : null,
                ),
                autofocus: true,
                onChanged: (_) => _applySearch(),
              ),
            ),

          // Contador de progresso
          if (hasItems)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.completedCount(
                      _list.completedItems,
                      _list.totalItems,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  if (_list.percentComplete > 0)
                    Text(
                      '${(_list.percentComplete * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConstants.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
            ),

          // Lista de itens
          Expanded(
            child: _filteredItems.isEmpty
                ? EmptyState(
                    icon: _searchController.text.isEmpty
                        ? Icons.shopping_bag_outlined
                        : Icons.search_off,
                    title: _searchController.text.isEmpty
                        ? l10n.emptyList
                        : l10n.noResultsFound,
                    subtitle: _searchController.text.isEmpty
                        ? l10n.emptyListSubtitle
                        : null,
                  )
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ShoppingItemTile(
                        item: item,
                        onChanged: (_) => _toggleItem(item),
                        onDelete: () => _deleteItem(item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}
