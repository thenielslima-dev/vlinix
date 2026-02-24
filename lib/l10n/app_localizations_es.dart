// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Panel Vlinix';

  @override
  String get menuOverview => 'Visión General';

  @override
  String get menuAgenda => 'Agenda';

  @override
  String get menuClients => 'Clientes';

  @override
  String get menuVehicles => 'Vehículos';

  @override
  String get menuServices => 'Servicios';

  @override
  String get menuFinance => 'Financiero';

  @override
  String get menuLogout => 'Salir';

  @override
  String get dashboardClients => 'Clientes';

  @override
  String get dashboardVehicles => 'Flota';

  @override
  String get dashboardToday => 'Hoy';

  @override
  String get agendaToday => 'Agenda de Hoy';

  @override
  String get agendaUpcoming => 'Próximas Citas';

  @override
  String get agendaEmptyToday => '¡Todo libre por hoy!';

  @override
  String get agendaEmptyUpcoming => 'Sin citas futuras.';

  @override
  String get btnNew => 'Nuevo';

  @override
  String get btnSave => 'Guardar';

  @override
  String get btnSchedule => 'Agendar';

  @override
  String get btnUpdate => 'Guardar Cambios';

  @override
  String get btnCancel => 'Cancelar';

  @override
  String get btnDelete => 'Eliminar';

  @override
  String get btnEdit => 'Editar';

  @override
  String get labelClient => 'Cliente';

  @override
  String get labelVehicle => 'Vehículo';

  @override
  String get labelService => 'Servicio';

  @override
  String get labelName => 'Nombre Completo';

  @override
  String get labelPhone => 'Teléfono';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelModel => 'Modelo';

  @override
  String get labelPlate => 'Placa';

  @override
  String get labelColor => 'Color';

  @override
  String get labelOwner => 'Dueño';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusDone => 'Concluido';

  @override
  String get dialogPaymentTitle => 'Método de Pago';

  @override
  String get paymentCash => 'Efectivo';

  @override
  String get paymentCard => 'Tarjeta';

  @override
  String get paymentPlan => 'Plan Mensual';

  @override
  String get filterAll => 'Todos';

  @override
  String get financeTitle => 'Control Financiero';

  @override
  String get financeTotal => 'Facturación Total';

  @override
  String get financeEmpty => 'Ningún servicio completado este mes.';

  @override
  String get titleManageClients => 'Gestionar Clientes';

  @override
  String get titleAllVehicles => 'Todos los Vehículos';

  @override
  String get msgNoClients => 'Ningún cliente registrado.';

  @override
  String get msgNoVehicles => 'Ningún vehículo registrado.';

  @override
  String get msgClientCreated => '¡Cliente creado!';

  @override
  String get msgClientUpdated => '¡Cliente actualizado!';

  @override
  String get msgClientDeleted => '¡Cliente eliminado!';

  @override
  String get msgGoogleUpdated => '¡Google Calendar Actualizado!';

  @override
  String get msgGoogleDeleted => '¡Eliminado de Google Calendar!';

  @override
  String get msgErrorDeleteClient =>
      'Error: ¡No se puede eliminar cliente con citas!';

  @override
  String get msgErrorDeleteVehicle => 'Error: ¡El coche tiene citas!';

  @override
  String get titleNewClient => 'Nuevo Cliente';

  @override
  String get titleEditClient => 'Editar Cliente';

  @override
  String get titleEditVehicle => 'Editar Vehículo';

  @override
  String get dialogDeleteTitle => '¿Eliminar?';

  @override
  String get dialogDeleteContent =>
      'Esto eliminará el registro permanentemente.';

  @override
  String get labelSelectServices => 'Seleccionar Servicios';

  @override
  String labelTotal(Object filter) {
    return 'TOTAL $filter';
  }

  @override
  String get msgSelectService => '¡Seleccione al menos un servicio!';

  @override
  String get msgSelectClientVehicle => '¡Seleccione Cliente y Vehículo!';

  @override
  String get tooltipEditProfile => 'Editar Perfil';

  @override
  String get titleNewVehicle => 'Nuevo Vehículo';

  @override
  String get titleNewAppointment => 'Nueva Cita';

  @override
  String get labelProfileInfo => 'Tu Información';

  @override
  String get msgTapPhoto => 'Toca la foto para cambiar';

  @override
  String get labelDisplayName => 'Nombre para mostrar';

  @override
  String get hintSearchClient => 'Buscar Cliente';

  @override
  String get hintSearchVehicle => 'Buscar Vehículo';

  @override
  String get hintSearchGeneric => 'Nombre, teléfono o email...';

  @override
  String get labelHello => 'Hola';

  @override
  String get titleNewExpense => 'Nuevo Gasto';

  @override
  String get labelReason => 'Motivo / Descripción';

  @override
  String get labelValue => 'Valor';

  @override
  String get labelDate => 'Fecha';

  @override
  String get btnAddExpense => 'AÑADIR GASTO';

  @override
  String get msgFillAllFields => '¡Complete todos los campos!';

  @override
  String get msgExpenseAdded => '¡Gasto añadido!';

  @override
  String get statusInProgress => 'En Progreso';

  @override
  String get btnStartService => 'Iniciar Servicio';

  @override
  String get titleChecklist => 'Lista de Verificación';

  @override
  String get btnGoToPayment => 'Ir al Pago';

  @override
  String get msgCompleteAllServices =>
      '¡Complete todos los ítems para finalizar!';

  @override
  String get labelAddress => 'Dirección';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get btnCancelAppointment => 'Cancelar Cita';

  @override
  String get msgAppointmentCancelled => '¡Cita cancelada!';

  @override
  String get btnConfirm => 'Confirmar';

  @override
  String get msgConfirmCancel =>
      '¿Está seguro de que desea cancelar esta cita?';

  @override
  String get msgAlmostThere => '¡Casi listo!';

  @override
  String get msgNeedClientAndService =>
      'Necesita tener al menos 1 Cliente (con vehículo) y 1 Servicio registrado para crear una cita.';

  @override
  String get btnRegisterClient => 'Registrar Cliente';

  @override
  String get btnRegisterService => 'Registrar Servicio';

  @override
  String get msgSelectClientFirst => 'Seleccione un cliente primero';

  @override
  String get labelCategoryNoCategory => 'Sin categoría';

  @override
  String get msgAppointmentSaved => '¡Cita guardada con éxito!';

  @override
  String msgErrorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get labelZipcode => 'Código Postal';

  @override
  String get labelNumber => 'Número';

  @override
  String get labelStreet => 'Calle / Avenida';

  @override
  String get labelCity => 'Ciudad';

  @override
  String get labelState => 'Estado';

  @override
  String get msgEmptyName => 'Ingrese el nombre';

  @override
  String get msgErrorSearchZip => 'Error al buscar Código Postal';

  @override
  String get titleQuickTemplates => 'Sugerencias Rápidas';

  @override
  String msgTemplateApplied(Object name) {
    return 'Sugiriendo: $name';
  }

  @override
  String get labelPrice => 'Precio';

  @override
  String get labelCategory => 'Tamaño / Categoría';

  @override
  String get msgErrorSaveVehicle =>
      'Seleccione un cliente, tamaño y escriba el modelo.';

  @override
  String get msgVehicleSaved => '¡Vehículo guardado con éxito!';

  @override
  String get hintModelExample => 'Ej: Tesla Model 3';

  @override
  String get labelNoOwner => 'Sin dueño';

  @override
  String get dialogDeleteAppointmentTitle => '¿Eliminar Cita?';

  @override
  String get dialogDeleteAppointmentContent =>
      'Esto la eliminará de la app y de Google Calendar.';

  @override
  String get msgLoading => 'Cargando...';

  @override
  String get msgErrorSelectImage => 'Error al seleccionar imagen';

  @override
  String get msgUserNotLoggedIn => 'Usuario no conectado';

  @override
  String get msgErrorCleanupAvatar => 'Error no crítico en la limpieza';

  @override
  String get msgProfileUpdated => '¡Perfil actualizado con éxito!';

  @override
  String get labelNetBalance => 'SALDO NETO';

  @override
  String get labelTotalReceivable => 'TOTAL POR RECIBIR';

  @override
  String get statusAwaitingPayment => 'Esperando Pago';

  @override
  String get labelExpenseTitle => 'Gasto';

  @override
  String get labelExpenseSubtitle => 'Salida';

  @override
  String get filterPending => 'Por Recibir';

  @override
  String get labelWithoutRegistration => 'Sin registro';

  @override
  String get msgRemovedFromGoogle => 'Eliminado de Google Calendar';

  @override
  String get msgAddedToGoogle => 'Añadido a Google Calendar';

  @override
  String get dialogReactivateTitle => '¿Reactivar Cita?';

  @override
  String get dialogReactivateContent =>
      'La cita volverá al estado Pendiente y se agregará de nuevo al calendario.';

  @override
  String get btnReactivate => 'Reactivar';

  @override
  String get tooltipDetails => 'Detalles';

  @override
  String get labelUnknownClient => 'Desconocido';

  @override
  String get labelUnknownVehicle => '¿Coche?';

  @override
  String get msgErrorGoogleLogin => 'Error al iniciar sesión con Google';

  @override
  String get msgErrorUnexpected => 'Error inesperado.';

  @override
  String get btnLoginGoogle => 'Entrar con Google';

  @override
  String get labelOr => 'O';

  @override
  String get labelPassword => 'Contraseña';

  @override
  String get btnLogin => 'ENTRAR';

  @override
  String get btnCreateAccountNow => 'Crear cuenta ahora';

  @override
  String get msgDemoModeStarted =>
      'Modo de Prueba: ¡La sesión expira en 10 minutos!';

  @override
  String get msgDemoModeEnded => 'El tiempo de prueba ha finalizado. ¡Gracias!';

  @override
  String get dialogDeleteServiceTitle => '¿Eliminar Servicio?';

  @override
  String get dialogDeleteServiceContent =>
      'Si este servicio está en alguna cita, no podrá ser eliminado.';

  @override
  String get msgServiceDeleted => 'Servicio eliminado con éxito.';

  @override
  String get msgErrorDeleteService =>
      'Error: ¡Servicio en uso o fallo al eliminar!';

  @override
  String get msgNoServices => 'Ningún servicio registrado.';

  @override
  String get titleCreateAccount => 'Crear Cuenta';

  @override
  String get msgJoinApp => 'Únete a V-LINIX';

  @override
  String get msgCreateAccountSeconds => 'Crea tu cuenta en segundos';

  @override
  String get msgInvalidEmail => 'Correo inválido. Verifica el formato.';

  @override
  String get msgShortPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get msgAccountCreated => '¡Cuenta creada! Bienvenido.';

  @override
  String get btnSignUp => 'REGISTRARSE';

  @override
  String get hintEmailExample => 'ejemplo@correo.com';

  @override
  String get labelDefaultUser => 'Usuario';

  @override
  String get btnConfirmPayment => 'Confirmar Pago';

  @override
  String get msgPaymentConfirmed => '¡Pago confirmado!';

  @override
  String get msgServiceSaved => '¡Servicio guardado con éxito!';

  @override
  String get labelEstimatedTotal => 'Total Estimado';

  @override
  String get dialogDeleteExpenseTitle => '¿Eliminar Gasto?';

  @override
  String get dialogDeleteExpenseContent =>
      '¿Estás seguro de que deseas eliminar este gasto? Esta acción no se puede deshacer.';

  @override
  String get msgExpenseDeleted => '¡Gasto eliminado con éxito!';
}
