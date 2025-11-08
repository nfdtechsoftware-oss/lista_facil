/// Categorias predefinidas de listas de compras
enum ListCategory {
  /// Supermercado
  supermarket('🛒', 'supermarket'),

  /// Farmácia
  pharmacy('💊', 'pharmacy'),

  /// Feira
  market('🥬', 'market'),

  /// Padaria
  bakery('🥖', 'bakery'),

  /// Lista personalizada
  custom('📋', 'custom');

  /// Emoji/ícone da categoria
  final String emoji;

  /// Chave de tradução
  final String translationKey;

  const ListCategory(this.emoji, this.translationKey);

  /// Retorna a categoria a partir do emoji
  static ListCategory fromEmoji(String emoji) {
    return ListCategory.values.firstWhere(
      (category) => category.emoji == emoji,
      orElse: () => ListCategory.custom,
    );
  }

  /// Lista de todos os emojis disponíveis
  static List<String> get allEmojis {
    return ListCategory.values.map((c) => c.emoji).toList();
  }
}
