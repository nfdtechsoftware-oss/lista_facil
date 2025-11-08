/// Modelo de dados para um item da lista de compras
class ShoppingItem {
  /// Nome do item (produto)
  String name;

  /// Status de conclusão (comprado ou não)
  bool isDone;

  /// Cria uma nova instância de [ShoppingItem]
  ///
  /// [name] é obrigatório e representa o nome do produto
  /// [isDone] é opcional e indica se o item já foi comprado (padrão: false)
  ShoppingItem({
    required this.name,
    this.isDone = false,
  });

  /// Converte o item para um Map (para serialização)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isDone': isDone,
    };
  }

  /// Cria um [ShoppingItem] a partir de um Map (para desserialização)
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      name: map['name'] as String,
      isDone: map['isDone'] as bool,
    );
  }
}
