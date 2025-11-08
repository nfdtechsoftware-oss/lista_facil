import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_item_model.dart';

/// Serviço responsável pelo armazenamento local dos itens
class StorageService {
  static const String _itemsKey = 'shopping_items';

  /// Carrega a lista de itens do armazenamento local
  ///
  /// Retorna uma lista vazia se não houver itens salvos
  static Future<List<ShoppingItem>> loadItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? itemsData = prefs.getStringList(_itemsKey);

      if (itemsData == null || itemsData.isEmpty) {
        return [];
      }

      return itemsData.map((itemString) {
        final parts = itemString.split('|');
        return ShoppingItem(
          name: parts[0],
          isDone: parts[1] == 'true',
        );
      }).toList();
    } catch (e) {
      // Em caso de erro, retorna lista vazia
      return [];
    }
  }

  /// Salva a lista de itens no armazenamento local
  ///
  /// [items] - Lista de itens a serem salvos
  static Future<bool> saveItems(List<ShoppingItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> itemsData = items
          .map((item) => '${item.name}|${item.isDone}')
          .toList();

      return await prefs.setStringList(_itemsKey, itemsData);
    } catch (e) {
      // Em caso de erro, retorna false
      return false;
    }
  }

  /// Limpa todos os itens do armazenamento local
  static Future<bool> clearItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_itemsKey);
    } catch (e) {
      return false;
    }
  }
}
