import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vlinix Dashboard'**
  String get appTitle;

  /// No description provided for @menuOverview.
  ///
  /// In pt, this message translates to:
  /// **'Visão Geral'**
  String get menuOverview;

  /// No description provided for @menuAgenda.
  ///
  /// In pt, this message translates to:
  /// **'Agenda'**
  String get menuAgenda;

  /// No description provided for @menuClients.
  ///
  /// In pt, this message translates to:
  /// **'Clientes'**
  String get menuClients;

  /// No description provided for @menuVehicles.
  ///
  /// In pt, this message translates to:
  /// **'Veículos'**
  String get menuVehicles;

  /// No description provided for @menuServices.
  ///
  /// In pt, this message translates to:
  /// **'Serviços'**
  String get menuServices;

  /// No description provided for @menuFinance.
  ///
  /// In pt, this message translates to:
  /// **'Financeiro'**
  String get menuFinance;

  /// No description provided for @menuLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get menuLogout;

  /// No description provided for @dashboardClients.
  ///
  /// In pt, this message translates to:
  /// **'Clientes'**
  String get dashboardClients;

  /// No description provided for @dashboardVehicles.
  ///
  /// In pt, this message translates to:
  /// **'Veículos'**
  String get dashboardVehicles;

  /// No description provided for @dashboardToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get dashboardToday;

  /// No description provided for @agendaToday.
  ///
  /// In pt, this message translates to:
  /// **'Agenda de Hoje'**
  String get agendaToday;

  /// No description provided for @agendaUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Próximos Agendamentos'**
  String get agendaUpcoming;

  /// No description provided for @agendaEmptyToday.
  ///
  /// In pt, this message translates to:
  /// **'Tudo livre por hoje!'**
  String get agendaEmptyToday;

  /// No description provided for @agendaEmptyUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Sem agendamentos futuros.'**
  String get agendaEmptyUpcoming;

  /// No description provided for @btnNew.
  ///
  /// In pt, this message translates to:
  /// **'Novo'**
  String get btnNew;

  /// No description provided for @btnSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get btnSave;

  /// No description provided for @btnSchedule.
  ///
  /// In pt, this message translates to:
  /// **'Agendar'**
  String get btnSchedule;

  /// No description provided for @btnUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Salvar Alterações'**
  String get btnUpdate;

  /// No description provided for @btnCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get btnCancel;

  /// No description provided for @btnDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get btnDelete;

  /// No description provided for @btnEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get btnEdit;

  /// No description provided for @labelClient.
  ///
  /// In pt, this message translates to:
  /// **'Cliente'**
  String get labelClient;

  /// No description provided for @labelVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Veículo'**
  String get labelVehicle;

  /// No description provided for @labelService.
  ///
  /// In pt, this message translates to:
  /// **'Serviço'**
  String get labelService;

  /// No description provided for @labelName.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo'**
  String get labelName;

  /// No description provided for @labelPhone.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get labelPhone;

  /// No description provided for @labelEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelModel.
  ///
  /// In pt, this message translates to:
  /// **'Modelo'**
  String get labelModel;

  /// No description provided for @labelPlate.
  ///
  /// In pt, this message translates to:
  /// **'Placa'**
  String get labelPlate;

  /// No description provided for @labelColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor'**
  String get labelColor;

  /// No description provided for @labelOwner.
  ///
  /// In pt, this message translates to:
  /// **'Dono'**
  String get labelOwner;

  /// No description provided for @statusPending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get statusPending;

  /// No description provided for @statusDone.
  ///
  /// In pt, this message translates to:
  /// **'Concluído'**
  String get statusDone;

  /// No description provided for @dialogPaymentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Forma de Pagamento'**
  String get dialogPaymentTitle;

  /// No description provided for @paymentCash.
  ///
  /// In pt, this message translates to:
  /// **'Dinheiro'**
  String get paymentCash;

  /// No description provided for @paymentCard.
  ///
  /// In pt, this message translates to:
  /// **'Cartão'**
  String get paymentCard;

  /// No description provided for @paymentPlan.
  ///
  /// In pt, this message translates to:
  /// **'Plano Mensal'**
  String get paymentPlan;

  /// No description provided for @filterAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get filterAll;

  /// No description provided for @financeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Controle Financeiro'**
  String get financeTitle;

  /// No description provided for @financeTotal.
  ///
  /// In pt, this message translates to:
  /// **'Faturamento Total'**
  String get financeTotal;

  /// No description provided for @financeEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum serviço concluído neste mês.'**
  String get financeEmpty;

  /// No description provided for @titleManageClients.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar Clientes'**
  String get titleManageClients;

  /// No description provided for @titleAllVehicles.
  ///
  /// In pt, this message translates to:
  /// **'Todos os Veículos'**
  String get titleAllVehicles;

  /// No description provided for @msgNoClients.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum cliente cadastrado.'**
  String get msgNoClients;

  /// No description provided for @msgNoVehicles.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum veículo cadastrado.'**
  String get msgNoVehicles;

  /// No description provided for @msgClientCreated.
  ///
  /// In pt, this message translates to:
  /// **'Cliente criado!'**
  String get msgClientCreated;

  /// No description provided for @msgClientUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Cliente atualizado!'**
  String get msgClientUpdated;

  /// No description provided for @msgClientDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Cliente excluído!'**
  String get msgClientDeleted;

  /// No description provided for @msgGoogleUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Google Agenda Atualizada!'**
  String get msgGoogleUpdated;

  /// No description provided for @msgGoogleDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Removido do Google Agenda!'**
  String get msgGoogleDeleted;

  /// No description provided for @msgErrorDeleteClient.
  ///
  /// In pt, this message translates to:
  /// **'Erro: Não é possível apagar cliente com agendamentos!'**
  String get msgErrorDeleteClient;

  /// No description provided for @msgErrorDeleteVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Erro: Carro possui agendamentos!'**
  String get msgErrorDeleteVehicle;

  /// No description provided for @titleNewClient.
  ///
  /// In pt, this message translates to:
  /// **'Novo Cliente'**
  String get titleNewClient;

  /// No description provided for @titleEditClient.
  ///
  /// In pt, this message translates to:
  /// **'Editar Cliente'**
  String get titleEditClient;

  /// No description provided for @titleEditVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Veículo'**
  String get titleEditVehicle;

  /// No description provided for @dialogDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir?'**
  String get dialogDeleteTitle;

  /// No description provided for @dialogDeleteContent.
  ///
  /// In pt, this message translates to:
  /// **'Isso apagará o registro permanentemente.'**
  String get dialogDeleteContent;

  /// No description provided for @labelSelectServices.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar Serviços'**
  String get labelSelectServices;

  /// No description provided for @labelTotal.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL {filter}'**
  String labelTotal(Object filter);

  /// No description provided for @msgSelectService.
  ///
  /// In pt, this message translates to:
  /// **'Selecione pelo menos um serviço!'**
  String get msgSelectService;

  /// No description provided for @msgSelectClientVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Selecione Cliente e Veículo!'**
  String get msgSelectClientVehicle;

  /// No description provided for @tooltipEditProfile.
  ///
  /// In pt, this message translates to:
  /// **'Editar Perfil'**
  String get tooltipEditProfile;

  /// No description provided for @titleNewVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Novo Veículo'**
  String get titleNewVehicle;

  /// No description provided for @titleNewAppointment.
  ///
  /// In pt, this message translates to:
  /// **'Novo Agendamento'**
  String get titleNewAppointment;

  /// No description provided for @labelProfileInfo.
  ///
  /// In pt, this message translates to:
  /// **'Suas Informações'**
  String get labelProfileInfo;

  /// No description provided for @msgTapPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Toque na foto para alterar'**
  String get msgTapPhoto;

  /// No description provided for @labelDisplayName.
  ///
  /// In pt, this message translates to:
  /// **'Nome de Exibição'**
  String get labelDisplayName;

  /// No description provided for @hintSearchClient.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar Cliente'**
  String get hintSearchClient;

  /// No description provided for @hintSearchVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar Veículo'**
  String get hintSearchVehicle;

  /// No description provided for @hintSearchGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Nome, telefone ou email...'**
  String get hintSearchGeneric;

  /// No description provided for @labelHello.
  ///
  /// In pt, this message translates to:
  /// **'Olá'**
  String get labelHello;

  /// No description provided for @titleNewExpense.
  ///
  /// In pt, this message translates to:
  /// **'Nova Despesa'**
  String get titleNewExpense;

  /// No description provided for @labelReason.
  ///
  /// In pt, this message translates to:
  /// **'Motivo / Descrição'**
  String get labelReason;

  /// No description provided for @labelValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor'**
  String get labelValue;

  /// No description provided for @labelDate.
  ///
  /// In pt, this message translates to:
  /// **'Data: '**
  String get labelDate;

  /// No description provided for @btnAddExpense.
  ///
  /// In pt, this message translates to:
  /// **'ADICIONAR DESPESA'**
  String get btnAddExpense;

  /// No description provided for @msgFillAllFields.
  ///
  /// In pt, this message translates to:
  /// **'Preencha todos os campos!'**
  String get msgFillAllFields;

  /// No description provided for @msgExpenseAdded.
  ///
  /// In pt, this message translates to:
  /// **'Despesa adicionada!'**
  String get msgExpenseAdded;

  /// No description provided for @statusInProgress.
  ///
  /// In pt, this message translates to:
  /// **'Em Andamento'**
  String get statusInProgress;

  /// No description provided for @btnStartService.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Serviço'**
  String get btnStartService;

  /// No description provided for @titleChecklist.
  ///
  /// In pt, this message translates to:
  /// **'Checklist de Serviços'**
  String get titleChecklist;

  /// No description provided for @btnGoToPayment.
  ///
  /// In pt, this message translates to:
  /// **'Ir para Pagamento'**
  String get btnGoToPayment;

  /// No description provided for @msgCompleteAllServices.
  ///
  /// In pt, this message translates to:
  /// **'Conclua todos os itens para finalizar!'**
  String get msgCompleteAllServices;

  /// No description provided for @labelAddress.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get labelAddress;

  /// No description provided for @statusCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Cancelado'**
  String get statusCancelled;

  /// No description provided for @btnCancelAppointment.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar Agendamento'**
  String get btnCancelAppointment;

  /// No description provided for @msgAppointmentCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Agendamento cancelado!'**
  String get msgAppointmentCancelled;

  /// No description provided for @btnConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get btnConfirm;

  /// No description provided for @msgConfirmCancel.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja cancelar este agendamento?'**
  String get msgConfirmCancel;

  /// No description provided for @msgAlmostThere.
  ///
  /// In pt, this message translates to:
  /// **'Quase lá!'**
  String get msgAlmostThere;

  /// No description provided for @msgNeedClientAndService.
  ///
  /// In pt, this message translates to:
  /// **'Você precisa ter pelo menos 1 Cliente (com veículo) e 1 Serviço cadastrados para criar um agendamento.'**
  String get msgNeedClientAndService;

  /// No description provided for @btnRegisterClient.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar Cliente'**
  String get btnRegisterClient;

  /// No description provided for @btnRegisterService.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar Serviço'**
  String get btnRegisterService;

  /// No description provided for @msgSelectClientFirst.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um cliente primeiro'**
  String get msgSelectClientFirst;

  /// No description provided for @labelCategoryNoCategory.
  ///
  /// In pt, this message translates to:
  /// **'Sem categoria'**
  String get labelCategoryNoCategory;

  /// No description provided for @msgAppointmentSaved.
  ///
  /// In pt, this message translates to:
  /// **'Agendamento salvo com sucesso!'**
  String get msgAppointmentSaved;

  /// No description provided for @msgErrorGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String msgErrorGeneric(Object error);

  /// No description provided for @labelZipcode.
  ///
  /// In pt, this message translates to:
  /// **'CEP'**
  String get labelZipcode;

  /// No description provided for @labelNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número'**
  String get labelNumber;

  /// No description provided for @labelStreet.
  ///
  /// In pt, this message translates to:
  /// **'Rua / Logradouro'**
  String get labelStreet;

  /// No description provided for @labelCity.
  ///
  /// In pt, this message translates to:
  /// **'Cidade'**
  String get labelCity;

  /// No description provided for @labelState.
  ///
  /// In pt, this message translates to:
  /// **'Estado'**
  String get labelState;

  /// No description provided for @msgEmptyName.
  ///
  /// In pt, this message translates to:
  /// **'Informe o nome'**
  String get msgEmptyName;

  /// No description provided for @msgErrorSearchZip.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao buscar CEP'**
  String get msgErrorSearchZip;

  /// No description provided for @titleQuickTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Sugestões Rápidas'**
  String get titleQuickTemplates;

  /// No description provided for @msgTemplateApplied.
  ///
  /// In pt, this message translates to:
  /// **'Sugerindo: {name}'**
  String msgTemplateApplied(Object name);

  /// No description provided for @labelPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preço'**
  String get labelPrice;

  /// No description provided for @labelCategory.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho / Categoria'**
  String get labelCategory;

  /// No description provided for @msgErrorSaveVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um cliente, tamanho e preencha o modelo.'**
  String get msgErrorSaveVehicle;

  /// No description provided for @msgVehicleSaved.
  ///
  /// In pt, this message translates to:
  /// **'Veículo salvo com sucesso!'**
  String get msgVehicleSaved;

  /// No description provided for @hintModelExample.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Tesla Model 3'**
  String get hintModelExample;

  /// No description provided for @labelNoOwner.
  ///
  /// In pt, this message translates to:
  /// **'Sem dono'**
  String get labelNoOwner;

  /// No description provided for @dialogDeleteAppointmentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Agendamento?'**
  String get dialogDeleteAppointmentTitle;

  /// No description provided for @dialogDeleteAppointmentContent.
  ///
  /// In pt, this message translates to:
  /// **'Isso apagará do app e do Google Agenda.'**
  String get dialogDeleteAppointmentContent;

  /// No description provided for @msgLoading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando...'**
  String get msgLoading;

  /// No description provided for @msgErrorSelectImage.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao selecionar imagem'**
  String get msgErrorSelectImage;

  /// No description provided for @msgUserNotLoggedIn.
  ///
  /// In pt, this message translates to:
  /// **'Usuário não logado'**
  String get msgUserNotLoggedIn;

  /// No description provided for @msgErrorCleanupAvatar.
  ///
  /// In pt, this message translates to:
  /// **'Erro não crítico na limpeza'**
  String get msgErrorCleanupAvatar;

  /// No description provided for @msgProfileUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Perfil atualizado com sucesso!'**
  String get msgProfileUpdated;

  /// No description provided for @labelNetBalance.
  ///
  /// In pt, this message translates to:
  /// **'SALDO LÍQUIDO'**
  String get labelNetBalance;

  /// No description provided for @labelTotalReceivable.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL A RECEBER'**
  String get labelTotalReceivable;

  /// No description provided for @statusAwaitingPayment.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando Pagamento'**
  String get statusAwaitingPayment;

  /// No description provided for @labelExpenseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Despesa'**
  String get labelExpenseTitle;

  /// No description provided for @labelExpenseSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Saída'**
  String get labelExpenseSubtitle;

  /// No description provided for @filterPending.
  ///
  /// In pt, this message translates to:
  /// **'A Receber'**
  String get filterPending;

  /// No description provided for @labelWithoutRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Sem registro'**
  String get labelWithoutRegistration;

  /// No description provided for @msgRemovedFromGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Removido da Agenda Google'**
  String get msgRemovedFromGoogle;

  /// No description provided for @msgAddedToGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Readicionado à Agenda Google'**
  String get msgAddedToGoogle;

  /// No description provided for @dialogReactivateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Reativar Agendamento?'**
  String get dialogReactivateTitle;

  /// No description provided for @dialogReactivateContent.
  ///
  /// In pt, this message translates to:
  /// **'O agendamento voltará para o status Pendente e será readicionado à agenda.'**
  String get dialogReactivateContent;

  /// No description provided for @btnReactivate.
  ///
  /// In pt, this message translates to:
  /// **'Reativar'**
  String get btnReactivate;

  /// No description provided for @tooltipDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes'**
  String get tooltipDetails;

  /// No description provided for @labelUnknownClient.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido'**
  String get labelUnknownClient;

  /// No description provided for @labelUnknownVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Carro?'**
  String get labelUnknownVehicle;

  /// No description provided for @msgErrorGoogleLogin.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao iniciar Google Login'**
  String get msgErrorGoogleLogin;

  /// No description provided for @msgErrorUnexpected.
  ///
  /// In pt, this message translates to:
  /// **'Erro inesperado.'**
  String get msgErrorUnexpected;

  /// No description provided for @btnLoginGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com Google'**
  String get btnLoginGoogle;

  /// No description provided for @labelOr.
  ///
  /// In pt, this message translates to:
  /// **'OU'**
  String get labelOr;

  /// No description provided for @labelPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get labelPassword;

  /// No description provided for @btnLogin.
  ///
  /// In pt, this message translates to:
  /// **'ENTRAR'**
  String get btnLogin;

  /// No description provided for @btnCreateAccountNow.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta agora'**
  String get btnCreateAccountNow;

  /// No description provided for @msgDemoModeStarted.
  ///
  /// In pt, this message translates to:
  /// **'Modo Teste: Sessão expira em 10 minutos!'**
  String get msgDemoModeStarted;

  /// No description provided for @msgDemoModeEnded.
  ///
  /// In pt, this message translates to:
  /// **'Tempo de teste finalizado. Obrigado!'**
  String get msgDemoModeEnded;

  /// No description provided for @dialogDeleteServiceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Serviço?'**
  String get dialogDeleteServiceTitle;

  /// No description provided for @dialogDeleteServiceContent.
  ///
  /// In pt, this message translates to:
  /// **'Se este serviço estiver em algum agendamento, ele não poderá ser excluído.'**
  String get dialogDeleteServiceContent;

  /// No description provided for @msgServiceDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Serviço excluído com sucesso.'**
  String get msgServiceDeleted;

  /// No description provided for @msgErrorDeleteService.
  ///
  /// In pt, this message translates to:
  /// **'Erro: Serviço em uso ou falha ao excluir!'**
  String get msgErrorDeleteService;

  /// No description provided for @msgNoServices.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum serviço cadastrado.'**
  String get msgNoServices;

  /// No description provided for @titleCreateAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar Conta'**
  String get titleCreateAccount;

  /// No description provided for @msgJoinApp.
  ///
  /// In pt, this message translates to:
  /// **'Junte-se ao V-LINIX'**
  String get msgJoinApp;

  /// No description provided for @msgCreateAccountSeconds.
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta em segundos'**
  String get msgCreateAccountSeconds;

  /// No description provided for @msgInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail inválido. Verifique o formato.'**
  String get msgInvalidEmail;

  /// No description provided for @msgShortPassword.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres.'**
  String get msgShortPassword;

  /// No description provided for @msgAccountCreated.
  ///
  /// In pt, this message translates to:
  /// **'Conta criada! Bem-vindo.'**
  String get msgAccountCreated;

  /// No description provided for @btnSignUp.
  ///
  /// In pt, this message translates to:
  /// **'CADASTRAR'**
  String get btnSignUp;

  /// No description provided for @hintEmailExample.
  ///
  /// In pt, this message translates to:
  /// **'exemplo@email.com'**
  String get hintEmailExample;

  /// No description provided for @labelDefaultUser.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get labelDefaultUser;

  /// No description provided for @btnConfirmPayment.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Pagamento'**
  String get btnConfirmPayment;

  /// No description provided for @msgPaymentConfirmed.
  ///
  /// In pt, this message translates to:
  /// **'Pagamento confirmado!'**
  String get msgPaymentConfirmed;

  /// No description provided for @msgServiceSaved.
  ///
  /// In pt, this message translates to:
  /// **'Serviço salvo com sucesso!'**
  String get msgServiceSaved;

  /// No description provided for @labelEstimatedTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total Estimado'**
  String get labelEstimatedTotal;

  /// No description provided for @dialogDeleteExpenseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Despesa?'**
  String get dialogDeleteExpenseTitle;

  /// No description provided for @dialogDeleteExpenseContent.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja excluir esta despesa? Esta ação não pode ser desfeita.'**
  String get dialogDeleteExpenseContent;

  /// No description provided for @msgExpenseDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Despesa excluída com sucesso!'**
  String get msgExpenseDeleted;

  /// No description provided for @btnRegisterVehicle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar Veículo'**
  String get btnRegisterVehicle;

  /// No description provided for @labelDescription.
  ///
  /// In pt, this message translates to:
  /// **'Motivo / Descrição'**
  String get labelDescription;

  /// No description provided for @msgExpenseSaved.
  ///
  /// In pt, this message translates to:
  /// **'Despesa salva com sucesso!'**
  String get msgExpenseSaved;

  /// No description provided for @msgGeneratingExcel.
  ///
  /// In pt, this message translates to:
  /// **'Gerando arquivo Excel...'**
  String get msgGeneratingExcel;

  /// No description provided for @msgExcelSaved.
  ///
  /// In pt, this message translates to:
  /// **'Salvo em: Documentos/VLINIX_Financeiro_{monthStr}.xlsx'**
  String msgExcelSaved(String monthStr);

  /// No description provided for @msgExportWebNotSupported.
  ///
  /// In pt, this message translates to:
  /// **'Exportação Web não configurada ainda.'**
  String get msgExportWebNotSupported;

  /// No description provided for @msgExportError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao exportar: {error}'**
  String msgExportError(String error);

  /// No description provided for @tooltipExportExcel.
  ///
  /// In pt, this message translates to:
  /// **'Exportar Excel'**
  String get tooltipExportExcel;

  /// No description provided for @excelSheetAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get excelSheetAll;

  /// No description provided for @excelSheetReceivable.
  ///
  /// In pt, this message translates to:
  /// **'A Receber'**
  String get excelSheetReceivable;

  /// No description provided for @excelSheetCash.
  ///
  /// In pt, this message translates to:
  /// **'Dinheiro'**
  String get excelSheetCash;

  /// No description provided for @excelSheetCard.
  ///
  /// In pt, this message translates to:
  /// **'Cartão'**
  String get excelSheetCard;

  /// No description provided for @excelSheetExpenses.
  ///
  /// In pt, this message translates to:
  /// **'Despesas'**
  String get excelSheetExpenses;

  /// No description provided for @excelColDate.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get excelColDate;

  /// No description provided for @excelColType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get excelColType;

  /// No description provided for @excelColDesc.
  ///
  /// In pt, this message translates to:
  /// **'Descrição / Serviços'**
  String get excelColDesc;

  /// No description provided for @excelColClient.
  ///
  /// In pt, this message translates to:
  /// **'Cliente / Subtítulo'**
  String get excelColClient;

  /// No description provided for @excelColMethod.
  ///
  /// In pt, this message translates to:
  /// **'Método / Status'**
  String get excelColMethod;

  /// No description provided for @excelColValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor'**
  String get excelColValue;

  /// No description provided for @excelTypeExpense.
  ///
  /// In pt, this message translates to:
  /// **'Despesa'**
  String get excelTypeExpense;

  /// No description provided for @excelTypePending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get excelTypePending;

  /// No description provided for @excelTypeIncome.
  ///
  /// In pt, this message translates to:
  /// **'Receita'**
  String get excelTypeIncome;

  /// No description provided for @excelStatusWaiting.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando'**
  String get excelStatusWaiting;

  /// No description provided for @excelTotal.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL:'**
  String get excelTotal;

  /// No description provided for @msgExcelDownloadStarted.
  ///
  /// In pt, this message translates to:
  /// **'Download iniciado: {filename}'**
  String msgExcelDownloadStarted(String filename);
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
