// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Vlinix Dashboard';

  @override
  String get menuOverview => 'Visão Geral';

  @override
  String get menuAgenda => 'Agenda';

  @override
  String get menuClients => 'Clientes';

  @override
  String get menuVehicles => 'Veículos';

  @override
  String get menuServices => 'Serviços';

  @override
  String get menuFinance => 'Financeiro';

  @override
  String get menuLogout => 'Sair';

  @override
  String get dashboardClients => 'Clientes';

  @override
  String get dashboardVehicles => 'Veículos';

  @override
  String get dashboardToday => 'Hoje';

  @override
  String get agendaToday => 'Agenda de Hoje';

  @override
  String get agendaUpcoming => 'Próximos Agendamentos';

  @override
  String get agendaEmptyToday => 'Tudo livre por hoje!';

  @override
  String get agendaEmptyUpcoming => 'Sem agendamentos futuros.';

  @override
  String get btnNew => 'Novo';

  @override
  String get btnSave => 'Salvar';

  @override
  String get btnSchedule => 'Agendar';

  @override
  String get btnUpdate => 'Salvar Alterações';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnDelete => 'Excluir';

  @override
  String get btnEdit => 'Editar';

  @override
  String get labelClient => 'Cliente';

  @override
  String get labelVehicle => 'Veículo';

  @override
  String get labelService => 'Serviço';

  @override
  String get labelName => 'Nome Completo';

  @override
  String get labelPhone => 'Telefone';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelModel => 'Modelo';

  @override
  String get labelPlate => 'Placa';

  @override
  String get labelColor => 'Cor';

  @override
  String get labelOwner => 'Dono';

  @override
  String get statusPending => 'Pendente';

  @override
  String get statusDone => 'Concluído';

  @override
  String get dialogPaymentTitle => 'Forma de Pagamento';

  @override
  String get paymentCash => 'Dinheiro';

  @override
  String get paymentCard => 'Cartão';

  @override
  String get paymentPlan => 'Plano Mensal';

  @override
  String get filterAll => 'Todos';

  @override
  String get financeTitle => 'Controle Financeiro';

  @override
  String get financeTotal => 'Faturamento Total';

  @override
  String get financeEmpty => 'Nenhum serviço concluído neste mês.';

  @override
  String get titleManageClients => 'Gerenciar Clientes';

  @override
  String get titleAllVehicles => 'Todos os Veículos';

  @override
  String get msgNoClients => 'Nenhum cliente cadastrado.';

  @override
  String get msgNoVehicles => 'Nenhum veículo cadastrado.';

  @override
  String get msgClientCreated => 'Cliente criado!';

  @override
  String get msgClientUpdated => 'Cliente atualizado!';

  @override
  String get msgClientDeleted => 'Cliente excluído!';

  @override
  String get msgGoogleUpdated => 'Google Agenda Atualizada!';

  @override
  String get msgGoogleDeleted => 'Removido do Google Agenda!';

  @override
  String get msgErrorDeleteClient =>
      'Erro: Não é possível apagar cliente com agendamentos!';

  @override
  String get msgErrorDeleteVehicle => 'Erro: Carro possui agendamentos!';

  @override
  String get titleNewClient => 'Novo Cliente';

  @override
  String get titleEditClient => 'Editar Cliente';

  @override
  String get titleEditVehicle => 'Editar Veículo';

  @override
  String get dialogDeleteTitle => 'Excluir?';

  @override
  String get dialogDeleteContent => 'Isso apagará o registro permanentemente.';

  @override
  String get labelSelectServices => 'Selecionar Serviços';

  @override
  String labelTotal(Object filter) {
    return 'TOTAL $filter';
  }

  @override
  String get msgSelectService => 'Selecione pelo menos um serviço!';

  @override
  String get msgSelectClientVehicle => 'Selecione Cliente e Veículo!';

  @override
  String get tooltipEditProfile => 'Editar Perfil';

  @override
  String get titleNewVehicle => 'Novo Veículo';

  @override
  String get titleNewAppointment => 'Novo Agendamento';

  @override
  String get labelProfileInfo => 'Suas Informações';

  @override
  String get msgTapPhoto => 'Toque na foto para alterar';

  @override
  String get labelDisplayName => 'Nome de Exibição';

  @override
  String get hintSearchClient => 'Pesquisar Cliente';

  @override
  String get hintSearchVehicle => 'Pesquisar Veículo';

  @override
  String get hintSearchGeneric => 'Nome, telefone ou email...';

  @override
  String get labelHello => 'Olá';

  @override
  String get titleNewExpense => 'Nova Despesa';

  @override
  String get labelReason => 'Motivo / Descrição';

  @override
  String get labelValue => 'Valor';

  @override
  String get labelDate => 'Data: ';

  @override
  String get btnAddExpense => 'ADICIONAR DESPESA';

  @override
  String get msgFillAllFields => 'Preencha todos os campos!';

  @override
  String get msgExpenseAdded => 'Despesa adicionada!';

  @override
  String get statusInProgress => 'Em Andamento';

  @override
  String get btnStartService => 'Iniciar Serviço';

  @override
  String get titleChecklist => 'Checklist de Serviços';

  @override
  String get btnGoToPayment => 'Ir para Pagamento';

  @override
  String get msgCompleteAllServices => 'Conclua todos os itens para finalizar!';

  @override
  String get labelAddress => 'Endereço';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get btnCancelAppointment => 'Cancelar Agendamento';

  @override
  String get msgAppointmentCancelled => 'Agendamento cancelado!';

  @override
  String get btnConfirm => 'Confirmar';

  @override
  String get msgConfirmCancel =>
      'Tem certeza que deseja cancelar este agendamento?';

  @override
  String get msgAlmostThere => 'Quase lá!';

  @override
  String get msgNeedClientAndService =>
      'Você precisa ter pelo menos 1 Cliente (com veículo) e 1 Serviço cadastrados para criar um agendamento.';

  @override
  String get btnRegisterClient => 'Cadastrar Cliente';

  @override
  String get btnRegisterService => 'Cadastrar Serviço';

  @override
  String get msgSelectClientFirst => 'Selecione um cliente primeiro';

  @override
  String get labelCategoryNoCategory => 'Sem categoria';

  @override
  String get msgAppointmentSaved => 'Agendamento salvo com sucesso!';

  @override
  String msgErrorGeneric(Object error) {
    return 'Erro: $error';
  }

  @override
  String get labelZipcode => 'CEP';

  @override
  String get labelNumber => 'Número';

  @override
  String get labelStreet => 'Rua / Logradouro';

  @override
  String get labelCity => 'Cidade';

  @override
  String get labelState => 'Estado';

  @override
  String get msgEmptyName => 'Informe o nome';

  @override
  String get msgErrorSearchZip => 'Erro ao buscar CEP';

  @override
  String get titleQuickTemplates => 'Sugestões Rápidas';

  @override
  String msgTemplateApplied(Object name) {
    return 'Sugerindo: $name';
  }

  @override
  String get labelPrice => 'Preço';

  @override
  String get labelCategory => 'Tamanho / Categoria';

  @override
  String get msgErrorSaveVehicle =>
      'Selecione um cliente, tamanho e preencha o modelo.';

  @override
  String get msgVehicleSaved => 'Veículo salvo com sucesso!';

  @override
  String get hintModelExample => 'Ex: Tesla Model 3';

  @override
  String get labelNoOwner => 'Sem dono';

  @override
  String get dialogDeleteAppointmentTitle => 'Excluir Agendamento?';

  @override
  String get dialogDeleteAppointmentContent =>
      'Isso apagará do app e do Google Agenda.';

  @override
  String get msgLoading => 'Carregando...';

  @override
  String get msgErrorSelectImage => 'Erro ao selecionar imagem';

  @override
  String get msgUserNotLoggedIn => 'Usuário não logado';

  @override
  String get msgErrorCleanupAvatar => 'Erro não crítico na limpeza';

  @override
  String get msgProfileUpdated => 'Perfil atualizado com sucesso!';

  @override
  String get labelNetBalance => 'SALDO LÍQUIDO';

  @override
  String get labelTotalReceivable => 'TOTAL A RECEBER';

  @override
  String get statusAwaitingPayment => 'Aguardando Pagamento';

  @override
  String get labelExpenseTitle => 'Despesa';

  @override
  String get labelExpenseSubtitle => 'Saída';

  @override
  String get filterPending => 'A Receber';

  @override
  String get labelWithoutRegistration => 'Sem registro';

  @override
  String get msgRemovedFromGoogle => 'Removido da Agenda Google';

  @override
  String get msgAddedToGoogle => 'Readicionado à Agenda Google';

  @override
  String get dialogReactivateTitle => 'Reativar Agendamento?';

  @override
  String get dialogReactivateContent =>
      'O agendamento voltará para o status Pendente e será readicionado à agenda.';

  @override
  String get btnReactivate => 'Reativar';

  @override
  String get tooltipDetails => 'Detalhes';

  @override
  String get labelUnknownClient => 'Desconhecido';

  @override
  String get labelUnknownVehicle => 'Carro?';

  @override
  String get msgErrorGoogleLogin => 'Erro ao iniciar Google Login';

  @override
  String get msgErrorUnexpected => 'Erro inesperado.';

  @override
  String get btnLoginGoogle => 'Entrar com Google';

  @override
  String get labelOr => 'OU';

  @override
  String get labelPassword => 'Senha';

  @override
  String get btnLogin => 'ENTRAR';

  @override
  String get btnCreateAccountNow => 'Criar conta agora';

  @override
  String get msgDemoModeStarted => 'Modo Teste: Sessão expira em 10 minutos!';

  @override
  String get msgDemoModeEnded => 'Tempo de teste finalizado. Obrigado!';

  @override
  String get dialogDeleteServiceTitle => 'Excluir Serviço?';

  @override
  String get dialogDeleteServiceContent =>
      'Se este serviço estiver em algum agendamento, ele não poderá ser excluído.';

  @override
  String get msgServiceDeleted => 'Serviço excluído com sucesso.';

  @override
  String get msgErrorDeleteService =>
      'Erro: Serviço em uso ou falha ao excluir!';

  @override
  String get msgNoServices => 'Nenhum serviço cadastrado.';

  @override
  String get titleCreateAccount => 'Criar Conta';

  @override
  String get msgJoinApp => 'Junte-se ao V-LINIX';

  @override
  String get msgCreateAccountSeconds => 'Crie sua conta em segundos';

  @override
  String get msgInvalidEmail => 'E-mail inválido. Verifique o formato.';

  @override
  String get msgShortPassword => 'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get msgAccountCreated => 'Conta criada! Bem-vindo.';

  @override
  String get btnSignUp => 'CADASTRAR';

  @override
  String get hintEmailExample => 'exemplo@email.com';

  @override
  String get labelDefaultUser => 'Usuário';

  @override
  String get btnConfirmPayment => 'Confirmar Pagamento';

  @override
  String get msgPaymentConfirmed => 'Pagamento confirmado!';

  @override
  String get msgServiceSaved => 'Serviço salvo com sucesso!';

  @override
  String get labelEstimatedTotal => 'Total Estimado';

  @override
  String get dialogDeleteExpenseTitle => 'Excluir Despesa?';

  @override
  String get dialogDeleteExpenseContent =>
      'Tem certeza que deseja excluir esta despesa? Esta ação não pode ser desfeita.';

  @override
  String get msgExpenseDeleted => 'Despesa excluída com sucesso!';

  @override
  String get btnRegisterVehicle => 'Cadastrar Veículo';

  @override
  String get labelDescription => 'Motivo / Descrição';

  @override
  String get msgExpenseSaved => 'Despesa salva com sucesso!';

  @override
  String get msgGeneratingExcel => 'Gerando arquivo Excel...';

  @override
  String msgExcelSaved(String monthStr) {
    return 'Salvo em: Documentos/VLINIX_Financeiro_$monthStr.xlsx';
  }

  @override
  String get msgExportWebNotSupported =>
      'Exportação Web não configurada ainda.';

  @override
  String msgExportError(String error) {
    return 'Erro ao exportar: $error';
  }

  @override
  String get tooltipExportExcel => 'Exportar Excel';

  @override
  String get excelSheetAll => 'Todos';

  @override
  String get excelSheetReceivable => 'A Receber';

  @override
  String get excelSheetCash => 'Dinheiro';

  @override
  String get excelSheetCard => 'Cartão';

  @override
  String get excelSheetExpenses => 'Despesas';

  @override
  String get excelColDate => 'Data';

  @override
  String get excelColType => 'Tipo';

  @override
  String get excelColDesc => 'Descrição / Serviços';

  @override
  String get excelColClient => 'Cliente / Subtítulo';

  @override
  String get excelColMethod => 'Método / Status';

  @override
  String get excelColValue => 'Valor';

  @override
  String get excelTypeExpense => 'Despesa';

  @override
  String get excelTypePending => 'Pendente';

  @override
  String get excelTypeIncome => 'Receita';

  @override
  String get excelStatusWaiting => 'Aguardando';

  @override
  String get excelTotal => 'TOTAL:';

  @override
  String msgExcelDownloadStarted(String filename) {
    return 'Download iniciado: $filename';
  }

  @override
  String get expenseCatWater => 'Água';

  @override
  String get expenseCatEnergy => 'Energia';

  @override
  String get expenseCatGas => 'Gasolina / Combustível';

  @override
  String get expenseCatProducts => 'Produtos / Insumos';

  @override
  String get expenseCatFood => 'Alimentação';

  @override
  String get expenseCatRent => 'Aluguel';

  @override
  String get expenseCatOthers => 'Outros';

  @override
  String get labelWhichExpense => 'Qual despesa?';

  @override
  String get labelTip => 'Gorjeta (Opcional)';

  @override
  String get dialogPaymentTip => 'Houve gorjeta?';

  @override
  String get excelColTip => 'Gorjeta';

  @override
  String msgGoogleReactivated(String services, String total) {
    return 'Reativado - Serviços: $services\nTotal: $total';
  }

  @override
  String get btnOpenMap => 'Ver no Mapa';

  @override
  String get msgErrorOpenMap => 'Não foi possível abrir o mapa.';

  @override
  String get btnResetFilter => 'Limpar';

  @override
  String get tooltipResetDate => 'Mostrar mês inteiro';
}
