// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Lista Fácil';

  @override
  String get addItem => 'Adicionar Item';

  @override
  String get itemName => 'Nome do item';

  @override
  String get delete => 'Excluir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get emptyList => 'Sua lista está vazia';

  @override
  String get emptyListSubtitle => 'Toque em + para adicionar seu primeiro item';

  @override
  String get searchItems => 'Buscar itens...';

  @override
  String get supermarket => 'Supermercado';

  @override
  String get pharmacy => 'Farmácia';

  @override
  String get market => 'Feira';

  @override
  String get bakery => 'Padaria';

  @override
  String get custom => 'Personalizada';

  @override
  String get newList => 'Nova Lista';

  @override
  String get editList => 'Editar Lista';

  @override
  String get deleteList => 'Excluir Lista';

  @override
  String get confirmDelete => 'Tem certeza que deseja excluir?';

  @override
  String get allLists => 'Todas as Listas';

  @override
  String get listName => 'Nome da lista';

  @override
  String get noLists => 'Nenhuma lista criada';

  @override
  String get noListsSubtitle => 'Crie sua primeira lista de compras';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Nenhum item',
    );
    return '$_temp0';
  }

  @override
  String completedCount(int completed, int total) {
    return '$completed de $total comprados';
  }

  @override
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get enterItemName => 'Digite o nome do item';

  @override
  String get clearCompleted => 'Limpar comprados';

  @override
  String get clearCompletedConfirm =>
      'Deseja remover todos os itens já comprados?';

  @override
  String get itemsCleared => 'Itens comprados removidos';
}
