import 'package:flutter/material.dart';
import '../models/shopping_list_model.dart';
import '../services/storage_service.dart';
import '../widgets/empty_state.dart';
import '../widgets/shopping_list_card.dart';
import '../widgets/confirm_dialog.dart';
import '../constants/list_category.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import 'list_items_screen.dart';

/// Tela inicial com todas as listas de compras
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ShoppingList> _lists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  /// Carrega todas as listas do armazenamento
  Future<void> _loadLists() async {
    setState(() => _isLoading = true);
    final lists = await StorageService.loadLists();
    setState(() {
      _lists = lists;
      _isLoading = false;
    });
  }

  /// Cria uma nova lista
  Future<void> _createNewList() async {
    final l10n = AppLocalizations.of(context)!;

    // Selecionar categoria
    final category = await showDialog<ListCategory>(
      context: context,
      builder: (context) => _CategorySelectionDialog(),
    );

    if (category == null || !mounted) return;

    // Pedir nome da lista
    final nameController = TextEditingController(
      text: _getCategoryName(category),
    );

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.newList),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.listName,
            hintText: l10n.listName,
          ),
          autofocus: true,
          maxLength: AppConstants.maxListNameLength,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, nameController.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || !mounted) return;

    // Criar lista
    final newList = ShoppingList(
      name: name,
      emoji: category.emoji,
    );

    await StorageService.saveList(newList);
    await _loadLists();

    if (mounted) {
      // Navegar para a nova lista
      _openList(newList);
    }
  }

  /// Abre uma lista para editar itens
  void _openList(ShoppingList list) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListItemsScreen(list: list),
      ),
    );
    // Recarrega ao voltar
    _loadLists();
  }

  /// Edita uma lista existente
  Future<void> _editList(ShoppingList list) async {
    final l10n = AppLocalizations.of(context)!;

    // Selecionar nova categoria
    final category = await showDialog<ListCategory>(
      context: context,
      builder: (context) => _CategorySelectionDialog(
        initialCategory: ListCategory.fromEmoji(list.emoji),
      ),
    );

    if (category == null || !mounted) return;

    // Editar nome
    final nameController = TextEditingController(text: list.name);

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editList),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: l10n.listName,
          ),
          autofocus: true,
          maxLength: AppConstants.maxListNameLength,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, nameController.text.trim());
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || !mounted) return;

    // Atualizar lista
    list.name = name;
    list.emoji = category.emoji;
    list.updatedAt = DateTime.now();

    await StorageService.saveList(list);
    await _loadLists();
  }

  /// Deleta uma lista
  Future<void> _deleteList(ShoppingList list) async {
    final l10n = AppLocalizations.of(context)!;

    final confirm = await ConfirmDialog.show(
      context,
      title: l10n.deleteList,
      message: l10n.confirmDelete,
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirm && mounted) {
      await StorageService.deleteList(list.id);
      await _loadLists();
    }
  }

  /// Retorna o nome da categoria traduzido
  String _getCategoryName(ListCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case ListCategory.supermarket:
        return l10n.supermarket;
      case ListCategory.pharmacy:
        return l10n.pharmacy;
      case ListCategory.market:
        return l10n.market;
      case ListCategory.bakery:
        return l10n.bakery;
      case ListCategory.custom:
        return l10n.custom;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lists.isEmpty
              ? EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: l10n.noLists,
                  subtitle: l10n.noListsSubtitle,
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  itemCount: _lists.length,
                  itemBuilder: (context, index) {
                    final list = _lists[index];
                    return ShoppingListCard(
                      shoppingList: list,
                      onTap: () => _openList(list),
                      onLongPress: () => _showListOptions(list),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewList,
        icon: const Icon(Icons.add),
        label: Text(l10n.newList),
      ),
    );
  }

  /// Mostra opções da lista (editar/deletar)
  void _showListOptions(ShoppingList list) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.editList),
              onTap: () {
                Navigator.pop(context);
                _editList(list);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                l10n.deleteList,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _deleteList(list);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog para seleção de categoria
class _CategorySelectionDialog extends StatelessWidget {
  final ListCategory? initialCategory;

  const _CategorySelectionDialog({this.initialCategory});

  String _getCategoryName(BuildContext context, ListCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case ListCategory.supermarket:
        return l10n.supermarket;
      case ListCategory.pharmacy:
        return l10n.pharmacy;
      case ListCategory.market:
        return l10n.market;
      case ListCategory.bakery:
        return l10n.bakery;
      case ListCategory.custom:
        return l10n.custom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text('Escolha uma categoria'),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      content: SizedBox(
        width: double.maxFinite,
        child: Wrap(
          spacing: AppConstants.paddingMedium,
          runSpacing: AppConstants.paddingLarge,
          alignment: WrapAlignment.center,
          children: ListCategory.values.map((category) {
            final isSelected = category == initialCategory;
            return Material(
              elevation: isSelected ? 4 : 2,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              shadowColor: isSelected
                  ? AppConstants.primaryGreen.withAlpha(100)
                  : Colors.black.withAlpha(40),
              child: InkWell(
                onTap: () => Navigator.pop(context, category),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? AppConstants.primaryGreen
                          : Colors.grey[300]!,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    color: isSelected
                        ? AppConstants.primaryGreen.withAlpha(51)
                        : Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getCategoryName(context, category),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? AppConstants.primaryGreen
                              : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
