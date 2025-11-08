import 'package:uuid/uuid.dart';

/// Modelo de dados para um item da lista de compras
class ShoppingItem {
  /// Identificador único do item
  final String id;

  /// Nome do item (produto)
  String name;

  /// Status de conclusão (comprado ou não)
  bool isDone;

  /// Data de criação do item
  final DateTime createdAt;

  /// Cria uma nova instância de [ShoppingItem]
  ///
  /// [name] é obrigatório e representa o nome do produto
  /// [id] é opcional - se não fornecido, será gerado automaticamente
  /// [isDone] é opcional e indica se o item já foi comprado (padrão: false)
  /// [createdAt] é opcional - se não fornecido, usa a data/hora atual
  ShoppingItem({
    String? id,
    required this.name,
    this.isDone = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Cria uma cópia do item com valores opcionalmente modificados
  ShoppingItem copyWith({
    String? id,
    String? name,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converte o item para um Map (para serialização)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Cria um [ShoppingItem] a partir de um Map (para desserialização)
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      isDone: map['isDone'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, isDone: $isDone, createdAt: $createdAt)';
  }
}
