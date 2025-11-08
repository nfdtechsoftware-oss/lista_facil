import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// Título do aplicativo
  ///
  /// In pt, this message translates to:
  /// **'Lista Fácil'**
  String get appTitle;

  /// Botão para adicionar item
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Item'**
  String get addItem;

  /// Label para campo de nome do item
  ///
  /// In pt, this message translates to:
  /// **'Nome do item'**
  String get itemName;

  /// Botão excluir
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// Botão cancelar
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Botão salvar
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// Mensagem quando lista vazia
  ///
  /// In pt, this message translates to:
  /// **'Sua lista está vazia'**
  String get emptyList;

  /// Subtítulo do estado vazio
  ///
  /// In pt, this message translates to:
  /// **'Toque em + para adicionar seu primeiro item'**
  String get emptyListSubtitle;

  /// Hint do campo de busca
  ///
  /// In pt, this message translates to:
  /// **'Buscar itens...'**
  String get searchItems;

  /// Categoria supermercado
  ///
  /// In pt, this message translates to:
  /// **'Supermercado'**
  String get supermarket;

  /// Categoria farmácia
  ///
  /// In pt, this message translates to:
  /// **'Farmácia'**
  String get pharmacy;

  /// Categoria feira
  ///
  /// In pt, this message translates to:
  /// **'Feira'**
  String get market;

  /// Categoria padaria
  ///
  /// In pt, this message translates to:
  /// **'Padaria'**
  String get bakery;

  /// Lista personalizada
  ///
  /// In pt, this message translates to:
  /// **'Personalizada'**
  String get custom;

  /// Criar nova lista
  ///
  /// In pt, this message translates to:
  /// **'Nova Lista'**
  String get newList;

  /// Editar lista existente
  ///
  /// In pt, this message translates to:
  /// **'Editar Lista'**
  String get editList;

  /// Excluir lista
  ///
  /// In pt, this message translates to:
  /// **'Excluir Lista'**
  String get deleteList;

  /// Mensagem de confirmação de exclusão
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja excluir?'**
  String get confirmDelete;

  /// Título da tela de listas
  ///
  /// In pt, this message translates to:
  /// **'Todas as Listas'**
  String get allLists;

  /// Label para nome da lista
  ///
  /// In pt, this message translates to:
  /// **'Nome da lista'**
  String get listName;

  /// Mensagem quando não há listas
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma lista criada'**
  String get noLists;

  /// Subtítulo quando não há listas
  ///
  /// In pt, this message translates to:
  /// **'Crie sua primeira lista de compras'**
  String get noListsSubtitle;

  /// Contador de itens
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhum item} =1{1 item} other{{count} itens}}'**
  String itemsCount(int count);

  /// Contador de itens completos
  ///
  /// In pt, this message translates to:
  /// **'{completed} de {total} comprados'**
  String completedCount(int completed, int total);

  /// Mensagem quando busca não retorna resultados
  ///
  /// In pt, this message translates to:
  /// **'Nenhum resultado encontrado'**
  String get noResultsFound;

  /// Validação de campo vazio
  ///
  /// In pt, this message translates to:
  /// **'Digite o nome do item'**
  String get enterItemName;

  /// Botão para limpar itens comprados
  ///
  /// In pt, this message translates to:
  /// **'Limpar comprados'**
  String get clearCompleted;

  /// Confirmação para limpar itens comprados
  ///
  /// In pt, this message translates to:
  /// **'Deseja remover todos os itens já comprados?'**
  String get clearCompletedConfirm;

  /// Mensagem de sucesso ao limpar itens
  ///
  /// In pt, this message translates to:
  /// **'Itens comprados removidos'**
  String get itemsCleared;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
