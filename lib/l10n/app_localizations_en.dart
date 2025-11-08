// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Easy List';

  @override
  String get addItem => 'Add Item';

  @override
  String get itemName => 'Item name';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get emptyList => 'Your list is empty';

  @override
  String get emptyListSubtitle => 'Tap + to add your first item';

  @override
  String get searchItems => 'Search items...';

  @override
  String get supermarket => 'Supermarket';

  @override
  String get pharmacy => 'Pharmacy';

  @override
  String get market => 'Farmers Market';

  @override
  String get bakery => 'Bakery';

  @override
  String get custom => 'Custom';

  @override
  String get newList => 'New List';

  @override
  String get editList => 'Edit List';

  @override
  String get deleteList => 'Delete List';

  @override
  String get confirmDelete => 'Are you sure you want to delete?';

  @override
  String get allLists => 'All Lists';

  @override
  String get listName => 'List name';

  @override
  String get noLists => 'No lists created';

  @override
  String get noListsSubtitle => 'Create your first shopping list';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String completedCount(int completed, int total) {
    return '$completed of $total purchased';
  }

  @override
  String get noResultsFound => 'No results found';

  @override
  String get enterItemName => 'Please enter item name';
}
