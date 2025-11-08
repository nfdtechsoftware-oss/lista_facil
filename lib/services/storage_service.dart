import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_list_model.dart';
import '../constants/app_constants.dart';

/// Serviço responsável pelo armazenamento local das listas
class StorageService {
  /// Carrega todas as listas do armazenamento local
  ///
  /// Retorna uma lista vazia se não houver listas salvas
  static Future<List<ShoppingList>> loadLists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? listsJson = prefs.getString(AppConstants.storageKeyLists);

      if (listsJson == null || listsJson.isEmpty) {
        return [];
      }

      final List<dynamic> listsMaps = jsonDecode(listsJson) as List<dynamic>;
      return listsMaps
          .map((listMap) =>
              ShoppingList.fromMap(listMap as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Em caso de erro, retorna lista vazia
      return [];
    }
  }

  /// Salva todas as listas no armazenamento local
  ///
  /// [lists] - Lista de listas a serem salvas
  /// Retorna true se salvo com sucesso, false caso contrário
  static Future<bool> saveLists(List<ShoppingList> lists) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> listsMaps =
          lists.map((list) => list.toMap()).toList();
      final String listsJson = jsonEncode(listsMaps);

      return await prefs.setString(AppConstants.storageKeyLists, listsJson);
    } catch (e) {
      return false;
    }
  }

  /// Salva uma lista específica
  ///
  /// [list] - Lista a ser salva
  /// Atualiza a lista se já existe, ou adiciona se é nova
  /// Retorna true se salvo com sucesso, false caso contrário
  static Future<bool> saveList(ShoppingList list) async {
    try {
      final lists = await loadLists();
      final index = lists.indexWhere((l) => l.id == list.id);

      if (index != -1) {
        // Atualiza lista existente
        lists[index] = list;
      } else {
        // Adiciona nova lista
        lists.add(list);
      }

      return await saveLists(lists);
    } catch (e) {
      return false;
    }
  }

  /// Deleta uma lista pelo ID
  ///
  /// [listId] - ID da lista a ser deletada
  /// Retorna true se deletado com sucesso, false caso contrário
  static Future<bool> deleteList(String listId) async {
    try {
      final lists = await loadLists();
      final initialLength = lists.length;
      lists.removeWhere((list) => list.id == listId);

      if (lists.length < initialLength) {
        // Se a lista ativa foi deletada, limpa a referência
        final activeListId = await getActiveListId();
        if (activeListId == listId) {
          await clearActiveListId();
        }
        return await saveLists(lists);
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Retorna uma lista específica pelo ID
  ///
  /// [listId] - ID da lista a ser recuperada
  /// Retorna null se a lista não for encontrada
  static Future<ShoppingList?> getList(String listId) async {
    try {
      final lists = await loadLists();
      return lists.firstWhere(
        (list) => list.id == listId,
        orElse: () => throw Exception('List not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Retorna o ID da lista ativa atual
  ///
  /// Retorna null se não houver lista ativa
  static Future<String?> getActiveListId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.storageKeyActiveList);
    } catch (e) {
      return null;
    }
  }

  /// Define o ID da lista ativa
  ///
  /// [listId] - ID da lista a ser marcada como ativa
  /// Retorna true se salvo com sucesso, false caso contrário
  static Future<bool> setActiveListId(String listId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(
          AppConstants.storageKeyActiveList, listId);
    } catch (e) {
      return false;
    }
  }

  /// Limpa a referência da lista ativa
  ///
  /// Retorna true se removido com sucesso, false caso contrário
  static Future<bool> clearActiveListId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(AppConstants.storageKeyActiveList);
    } catch (e) {
      return false;
    }
  }

  /// Limpa todas as listas do armazenamento
  ///
  /// ATENÇÃO: Esta operação é irreversível!
  /// Retorna true se limpo com sucesso, false caso contrário
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.storageKeyLists);
      await prefs.remove(AppConstants.storageKeyActiveList);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Exporta todas as listas para JSON
  ///
  /// Útil para backup ou exportação de dados
  /// Retorna uma String JSON com todas as listas ou null em caso de erro
  static Future<String?> exportToJson() async {
    try {
      final lists = await loadLists();
      final listsMaps = lists.map((list) => list.toMap()).toList();
      return jsonEncode(listsMaps);
    } catch (e) {
      return null;
    }
  }

  /// Importa listas de um JSON
  ///
  /// [jsonString] - String JSON contendo as listas
  /// [merge] - Se true, mescla com listas existentes. Se false, substitui.
  /// Retorna true se importado com sucesso, false caso contrário
  static Future<bool> importFromJson(String jsonString,
      {bool merge = false}) async {
    try {
      final List<dynamic> listsMaps = jsonDecode(jsonString) as List<dynamic>;
      final importedLists = listsMaps
          .map((listMap) =>
              ShoppingList.fromMap(listMap as Map<String, dynamic>))
          .toList();

      if (merge) {
        final existingLists = await loadLists();
        // Remove duplicatas baseado no ID
        final Map<String, ShoppingList> listsMap = {};
        for (var list in existingLists) {
          listsMap[list.id] = list;
        }
        for (var list in importedLists) {
          listsMap[list.id] = list;
        }
        return await saveLists(listsMap.values.toList());
      } else {
        return await saveLists(importedLists);
      }
    } catch (e) {
      return false;
    }
  }
}
