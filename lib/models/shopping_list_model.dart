import 'package:uuid/uuid.dart';
import 'shopping_item_model.dart';

/// Modelo de dados para uma lista de compras completa
class ShoppingList {
  /// Identificador único da lista
  final String id;

  /// Nome da lista (ex: "Supermercado", "Farmácia")
  String name;

  /// Emoji/ícone da lista
  String emoji;

  /// Itens da lista
  List<ShoppingItem> items;

  /// Data de criação da lista
  final DateTime createdAt;

  /// Data da última atualização
  DateTime updatedAt;

  /// Cria uma nova instância de [ShoppingList]
  ///
  /// [name] é obrigatório e representa o nome da lista
  /// [emoji] é o ícone/emoji da lista (padrão: 📋)
  /// [id] é opcional - se não fornecido, será gerado automaticamente
  /// [items] é opcional - se não fornecido, inicia com lista vazia
  /// [createdAt] é opcional - se não fornecido, usa a data/hora atual
  /// [updatedAt] é opcional - se não fornecido, usa a data/hora atual
  ShoppingList({
    String? id,
    required this.name,
    this.emoji = '📋',
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        items = items ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Retorna o número total de itens na lista
  int get totalItems => items.length;

  /// Retorna o número de itens completos (comprados)
  int get completedItems => items.where((item) => item.isDone).length;

  /// Retorna o número de itens pendentes (não comprados)
  int get pendingItems => items.where((item) => !item.isDone).length;

  /// Retorna a porcentagem de conclusão (0.0 a 1.0)
  double get percentComplete {
    if (items.isEmpty) return 0.0;
    return completedItems / totalItems;
  }

  /// Verifica se a lista está vazia
  bool get isEmpty => items.isEmpty;

  /// Verifica se todos os itens estão completos
  bool get isAllComplete => items.isNotEmpty && completedItems == totalItems;

  /// Adiciona um item à lista
  void addItem(ShoppingItem item) {
    items.add(item);
    updatedAt = DateTime.now();
  }

  /// Remove um item da lista pelo ID
  bool removeItem(String itemId) {
    final initialLength = items.length;
    items.removeWhere((item) => item.id == itemId);
    if (items.length < initialLength) {
      updatedAt = DateTime.now();
      return true;
    }
    return false;
  }

  /// Atualiza um item na lista
  bool updateItem(ShoppingItem updatedItem) {
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      updatedAt = DateTime.now();
      return true;
    }
    return false;
  }

  /// Alterna o status de um item (comprado/não comprado)
  bool toggleItem(String itemId) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      items[index].isDone = !items[index].isDone;
      updatedAt = DateTime.now();
      return true;
    }
    return false;
  }

  /// Remove todos os itens completos
  void clearCompleted() {
    items.removeWhere((item) => item.isDone);
    updatedAt = DateTime.now();
  }

  /// Remove todos os itens da lista
  void clearAll() {
    items.clear();
    updatedAt = DateTime.now();
  }

  /// Cria uma cópia da lista com valores opcionalmente modificados
  ShoppingList copyWith({
    String? id,
    String? name,
    String? emoji,
    List<ShoppingItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      items: items ?? List.from(this.items),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converte a lista para um Map (para serialização)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Cria uma [ShoppingList] a partir de um Map (para desserialização)
  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] as String,
      name: map['name'] as String,
      emoji: map['emoji'] as String? ?? '📋',
      items: (map['items'] as List<dynamic>?)
              ?.map((itemMap) =>
                  ShoppingItem.fromMap(itemMap as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingList && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ShoppingList(id: $id, name: $name, emoji: $emoji, items: ${items.length}, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
