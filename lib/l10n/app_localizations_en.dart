// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vlinix Dashboard';

  @override
  String get menuOverview => 'Overview';

  @override
  String get menuAgenda => 'Schedule';

  @override
  String get menuClients => 'Clients';

  @override
  String get menuVehicles => 'Vehicles';

  @override
  String get menuServices => 'Services';

  @override
  String get menuFinance => 'Finance';

  @override
  String get menuLogout => 'Logout';

  @override
  String get dashboardClients => 'Clients';

  @override
  String get dashboardVehicles => 'Fleet';

  @override
  String get dashboardToday => 'Today';

  @override
  String get agendaToday => 'Today\'s Schedule';

  @override
  String get agendaUpcoming => 'Upcoming Appointments';

  @override
  String get agendaEmptyToday => 'All clear for today!';

  @override
  String get agendaEmptyUpcoming => 'No upcoming appointments.';

  @override
  String get btnNew => 'New';

  @override
  String get btnSave => 'Save';

  @override
  String get btnSchedule => 'Schedule';

  @override
  String get btnUpdate => 'Save Changes';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnEdit => 'Edit';

  @override
  String get labelClient => 'Client';

  @override
  String get labelVehicle => 'Vehicle';

  @override
  String get labelService => 'Service';

  @override
  String get labelName => 'Full Name';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelModel => 'Model';

  @override
  String get labelPlate => 'Plate';

  @override
  String get labelColor => 'Color';

  @override
  String get labelOwner => 'Owner';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusDone => 'Done';

  @override
  String get dialogPaymentTitle => 'Payment Method';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentPlan => 'Monthly Plan';

  @override
  String get filterAll => 'All';

  @override
  String get financeTitle => 'Financial Control';

  @override
  String get financeTotal => 'Total Revenue';

  @override
  String get financeEmpty => 'No services completed this month.';

  @override
  String get titleManageClients => 'Manage Clients';

  @override
  String get titleAllVehicles => 'All Vehicles';

  @override
  String get msgNoClients => 'No clients found.';

  @override
  String get msgNoVehicles => 'No vehicles found.';

  @override
  String get msgClientCreated => 'Client created!';

  @override
  String get msgClientUpdated => 'Client updated!';

  @override
  String get msgClientDeleted => 'Client deleted!';

  @override
  String get msgGoogleUpdated => 'Google Calendar Updated!';

  @override
  String get msgGoogleDeleted => 'Removed from Google Calendar!';

  @override
  String get msgErrorDeleteClient =>
      'Error: Cannot delete client with appointments!';

  @override
  String get msgErrorDeleteVehicle => 'Error: Car has appointments!';

  @override
  String get titleNewClient => 'New Client';

  @override
  String get titleEditClient => 'Edit Client';

  @override
  String get titleEditVehicle => 'Edit Vehicle';

  @override
  String get dialogDeleteTitle => 'Delete?';

  @override
  String get dialogDeleteContent => 'This will delete the record permanently.';

  @override
  String get labelSelectServices => 'Select Services';

  @override
  String labelTotal(Object filter) {
    return 'TOTAL $filter';
  }

  @override
  String get msgSelectService => 'Select at least one service!';

  @override
  String get msgSelectClientVehicle => 'Select Client and Vehicle!';

  @override
  String get tooltipEditProfile => 'Edit Profile';

  @override
  String get titleNewVehicle => 'New Vehicle';

  @override
  String get titleNewAppointment => 'New Appointment';

  @override
  String get labelProfileInfo => 'Your Information';

  @override
  String get msgTapPhoto => 'Tap photo to change';

  @override
  String get labelDisplayName => 'Display Name';

  @override
  String get hintSearchClient => 'Search Client';

  @override
  String get hintSearchVehicle => 'Search Vehicle';

  @override
  String get hintSearchGeneric => 'Name, phone or email...';

  @override
  String get labelHello => 'Hello';

  @override
  String get titleNewExpense => 'New Expense';

  @override
  String get labelReason => 'Reason / Description';

  @override
  String get labelValue => 'Amount';

  @override
  String get labelDate => 'Date: ';

  @override
  String get btnAddExpense => 'ADD EXPENSE';

  @override
  String get msgFillAllFields => 'Please fill all fields!';

  @override
  String get msgExpenseAdded => 'Expense added!';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get btnStartService => 'Start Service';

  @override
  String get titleChecklist => 'Service Checklist';

  @override
  String get btnGoToPayment => 'Go to Payment';

  @override
  String get msgCompleteAllServices => 'Complete all items to finish!';

  @override
  String get labelAddress => 'Address';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get btnCancelAppointment => 'Cancel Appointment';

  @override
  String get msgAppointmentCancelled => 'Appointment cancelled!';

  @override
  String get btnConfirm => 'Confirm';

  @override
  String get msgConfirmCancel =>
      'Are you sure you want to cancel this appointment?';

  @override
  String get msgAlmostThere => 'Almost there!';

  @override
  String get msgNeedClientAndService =>
      'You need to have at least 1 Client (with a vehicle) and 1 Service registered to create an appointment.';

  @override
  String get btnRegisterClient => 'Register Client';

  @override
  String get btnRegisterService => 'Register Service';

  @override
  String get msgSelectClientFirst => 'Select a client first';

  @override
  String get labelCategoryNoCategory => 'No category';

  @override
  String get msgAppointmentSaved => 'Appointment saved successfully!';

  @override
  String msgErrorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get labelZipcode => 'Zipcode';

  @override
  String get labelNumber => 'Number';

  @override
  String get labelStreet => 'Street';

  @override
  String get labelCity => 'City';

  @override
  String get labelState => 'State';

  @override
  String get msgEmptyName => 'Please enter a name';

  @override
  String get msgErrorSearchZip => 'Error searching Zipcode';

  @override
  String get titleQuickTemplates => 'Quick Templates';

  @override
  String msgTemplateApplied(Object name) {
    return 'Suggesting: $name';
  }

  @override
  String get labelPrice => 'Price';

  @override
  String get labelCategory => 'Size / Category';

  @override
  String get msgErrorSaveVehicle =>
      'Select a client, size, and enter the model.';

  @override
  String get msgVehicleSaved => 'Vehicle saved successfully!';

  @override
  String get hintModelExample => 'Ex: Tesla Model 3';

  @override
  String get labelNoOwner => 'No owner';

  @override
  String get dialogDeleteAppointmentTitle => 'Delete Appointment?';

  @override
  String get dialogDeleteAppointmentContent =>
      'This will delete it from the app and Google Calendar.';

  @override
  String get msgLoading => 'Loading...';

  @override
  String get msgErrorSelectImage => 'Error selecting image';

  @override
  String get msgUserNotLoggedIn => 'User not logged in';

  @override
  String get msgErrorCleanupAvatar => 'Non-critical error during cleanup';

  @override
  String get msgProfileUpdated => 'Profile updated successfully!';

  @override
  String get labelNetBalance => 'NET BALANCE';

  @override
  String get labelTotalReceivable => 'TOTAL RECEIVABLE';

  @override
  String get statusAwaitingPayment => 'Awaiting Payment';

  @override
  String get labelExpenseTitle => 'Expense';

  @override
  String get labelExpenseSubtitle => 'Outflow';

  @override
  String get filterPending => 'Receivable';

  @override
  String get labelWithoutRegistration => 'Unregistered';

  @override
  String get msgRemovedFromGoogle => 'Removed from Google Calendar';

  @override
  String get msgAddedToGoogle => 'Re-added to Google Calendar';

  @override
  String get dialogReactivateTitle => 'Reactivate Appointment?';

  @override
  String get dialogReactivateContent =>
      'The appointment will return to Pending status and be added back to the calendar.';

  @override
  String get btnReactivate => 'Reactivate';

  @override
  String get tooltipDetails => 'Details';

  @override
  String get labelUnknownClient => 'Unknown';

  @override
  String get labelUnknownVehicle => 'Car?';

  @override
  String get msgErrorGoogleLogin => 'Error starting Google Login';

  @override
  String get msgErrorUnexpected => 'Unexpected error.';

  @override
  String get btnLoginGoogle => 'Sign in with Google';

  @override
  String get labelOr => 'OR';

  @override
  String get labelPassword => 'Password';

  @override
  String get btnLogin => 'SIGN IN';

  @override
  String get btnCreateAccountNow => 'Create account now';

  @override
  String get msgDemoModeStarted => 'Test Mode: Session expires in 10 minutes!';

  @override
  String get msgDemoModeEnded => 'Test time has ended. Thank you!';

  @override
  String get dialogDeleteServiceTitle => 'Delete Service?';

  @override
  String get dialogDeleteServiceContent =>
      'If this service is in any appointment, it cannot be deleted.';

  @override
  String get msgServiceDeleted => 'Service deleted successfully.';

  @override
  String get msgErrorDeleteService =>
      'Error: Service in use or failed to delete!';

  @override
  String get msgNoServices => 'No services registered.';

  @override
  String get titleCreateAccount => 'Create Account';

  @override
  String get msgJoinApp => 'Join V-LINIX';

  @override
  String get msgCreateAccountSeconds => 'Create your account in seconds';

  @override
  String get msgInvalidEmail => 'Invalid email. Check the format.';

  @override
  String get msgShortPassword => 'Password must be at least 6 characters.';

  @override
  String get msgAccountCreated => 'Account created! Welcome.';

  @override
  String get btnSignUp => 'SIGN UP';

  @override
  String get hintEmailExample => 'example@email.com';

  @override
  String get labelDefaultUser => 'User';

  @override
  String get btnConfirmPayment => 'Confirm Payment';

  @override
  String get msgPaymentConfirmed => 'Payment confirmed!';

  @override
  String get msgServiceSaved => 'Service saved successfully!';

  @override
  String get labelEstimatedTotal => 'Estimated Total';

  @override
  String get dialogDeleteExpenseTitle => 'Delete Expense?';

  @override
  String get dialogDeleteExpenseContent =>
      'Are you sure you want to delete this expense? This action cannot be undone.';

  @override
  String get msgExpenseDeleted => 'Expense deleted successfully!';

  @override
  String get btnRegisterVehicle => 'Register Vehicle';

  @override
  String get labelDescription => 'Reason / Description';

  @override
  String get msgExpenseSaved => 'Expense saved successfully!';
}
