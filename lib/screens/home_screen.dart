import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vlinix/main.dart';
import 'package:vlinix/l10n/app_localizations.dart';
import 'package:vlinix/theme/app_colors.dart';
import 'package:vlinix/widgets/user_profile_menu.dart';
import 'package:vlinix/services/google_calendar_service.dart';

import 'add_client_screen.dart';
import 'add_vehicle_screen.dart';
import 'add_appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _todayAppointmentsCount = 0;
  List<Map<String, dynamic>> _todayAppointments = [];
  List<Map<String, dynamic>> _upcomingAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(
        now.year,
        now.month,
        now.day,
      ).toUtc().toIso8601String();
      final endOfDay = DateTime(
        now.year,
        now.month,
        now.day,
        23,
        59,
        59,
      ).toUtc().toIso8601String();

      const selectQuery = '''
        *,
        clients(full_name),
        vehicles(model, category), 
        services(name),
        appointment_services(id, price, completed, services(name))
      ''';

      final todayData = await supabase
          .from('appointments')
          .select(selectQuery)
          .gte('start_time', startOfDay)
          .lte('start_time', endOfDay)
          .order('start_time', ascending: true);

      final upcomingData = await supabase
          .from('appointments')
          .select(selectQuery)
          .gt('start_time', endOfDay)
          .order('start_time', ascending: true);

      if (mounted) {
        setState(() {
          _todayAppointments = List<Map<String, dynamic>>.from(todayData);
          _todayAppointmentsCount = _todayAppointments.length;
          _upcomingAppointments = List<Map<String, dynamic>>.from(upcomingData);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro Dashboard: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- ATUALIZAÇÃO DO STATUS (COM GOOGLE CALENDAR) ---
  Future<void> _updateStatus(
    int id,
    String newStatus, {
    String? paymentMethod,
  }) async {
    final supabase = Supabase.instance.client;
    String feedbackMsg = '';

    // Obter o lang aqui com cuidado se a função for iniciada por um contexto que pode não estar mais na árvore
    // Idealmente passamos a String já traduzida ou pegamos depois de validar se está mounted, mas vamos resolver isso logo em seguida.

    try {
      // 1. LÓGICA DO GOOGLE CALENDAR
      final currentData = await supabase
          .from('appointments')
          .select(
            '*, clients(full_name), appointment_services(price, services(name))',
          )
          .eq('id', id)
          .single();

      final String? currentGoogleId = currentData['google_event_id'];
      String? newGoogleEventId;

      if (newStatus == 'cancelado') {
        if (currentGoogleId != null && currentGoogleId.isNotEmpty) {
          await GoogleCalendarService.instance.deleteEvent(currentGoogleId);
          // Atualiza a msg no momento em que for mostrar, para garantir o Context
        }
      } else if (newStatus == 'pendente') {
        final clientName = currentData['clients']['full_name'];
        final startTime = DateTime.parse(currentData['start_time']);
        final endTime = startTime.add(const Duration(hours: 1));

        final items = currentData['appointment_services'] as List;
        final servicesNames = items
            .map((i) => i['services']['name'])
            .join(', ');
        final totalPrice = items.fold(0.0, (sum, i) => sum + (i['price'] ?? 0));

        final title = 'Vlinix: $servicesNames - $clientName';

        // Simbolo da moeda para a desc do google (vamos assumir o locale default, pois o google envia isso pra nuvem)
        final currency = NumberFormat.simpleCurrency(name: '').currencySymbol;

        final desc =
            'Reativado - Serviços: $servicesNames\nTotal: $currency $totalPrice';

        newGoogleEventId = await GoogleCalendarService.instance.insertEvent(
          title: title,
          description: desc,
          startTime: startTime,
          endTime: endTime,
        );
      }

      // 2. ATUALIZAÇÃO NO SUPABASE
      final Map<String, dynamic> updateData = {'status': newStatus};

      if (newStatus == 'concluido') {
        updateData['payment_method'] = paymentMethod;
      } else {
        updateData['payment_method'] = null;
      }

      if (newGoogleEventId != null) {
        updateData['google_event_id'] = newGoogleEventId;
      } else if (newStatus == 'cancelado') {
        updateData['google_event_id'] = null;
      }

      await supabase.from('appointments').update(updateData).eq('id', id);
      await _loadDashboardData();

      // 3. FEEDBACK VISUAL
      if (mounted) {
        final lang = AppLocalizations.of(context)!;
        String msg = '';
        Color color = Colors.blue;

        if (newStatus == 'cancelado' &&
            currentGoogleId != null &&
            currentGoogleId.isNotEmpty) {
          feedbackMsg = lang.msgRemovedFromGoogle;
        } else if (newStatus == 'pendente' && newGoogleEventId != null) {
          feedbackMsg = lang.msgAddedToGoogle;
        }

        if (newStatus == 'concluido') {
          msg = '${lang.statusDone} ✅';
          color = AppColors.success;
        } else if (newStatus == 'em_andamento') {
          msg = '${lang.statusInProgress} 🚀';
          color = Colors.blue;
        } else if (newStatus == 'cancelado') {
          msg = '${lang.msgAppointmentCancelled} 🚫';
          color = Colors.grey;
        } else {
          msg = '${lang.statusPending} 🟠'; // Reativado
          color = Colors.orange;
        }

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        if (feedbackMsg.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$msg\n$feedbackMsg'),
              backgroundColor: color,
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.msgErrorGeneric(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleServiceCompletion(
    int appointmentServiceId,
    bool currentStatus,
  ) async {
    try {
      await Supabase.instance.client
          .from('appointment_services')
          .update({'completed': !currentStatus})
          .eq('id', appointmentServiceId);
      await _loadDashboardData();
    } catch (e) {
      debugPrint('Erro ao atualizar serviço: $e');
    }
  }

  void _showChecklistDialog(Map<String, dynamic> apt) {
    final lang = AppLocalizations.of(context)!;
    final currencySymbol = NumberFormat.simpleCurrency(name: '').currencySymbol;
    final List items = apt['appointment_services'] ?? [];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool allCompleted = items.every((i) => i['completed'] == true);
            return AlertDialog(
              title: Text(lang.titleChecklist),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final bool isChecked = item['completed'] ?? false;
                    return CheckboxListTile(
                      title: Text(item['services']['name']),
                      subtitle: Text("$currencySymbol ${item['price']}"),
                      value: isChecked,
                      activeColor: AppColors.success,
                      onChanged: (val) async {
                        await _toggleServiceCompletion(item['id'], isChecked);
                        setStateDialog(() {
                          item['completed'] = val;
                        });
                        _loadDashboardData();
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    lang.btnCancel,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allCompleted
                        ? AppColors.success
                        : Colors.grey,
                  ),
                  onPressed: allCompleted
                      ? () {
                          Navigator.pop(ctx);
                          _showPaymentDialog(apt['id']);
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(lang.msgCompleteAllServices),
                            ),
                          );
                        },
                  child: Text(lang.btnGoToPayment),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPaymentDialog(int appointmentId) {
    final lang = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(lang.dialogPaymentTitle),
          children: [
            _buildPaymentOption(
              ctx,
              appointmentId,
              lang.paymentCash,
              Icons.money,
              Colors.green,
            ),
            _buildPaymentOption(
              ctx,
              appointmentId,
              lang.paymentCard,
              Icons.credit_card,
              Colors.blue,
            ),
            _buildPaymentOption(
              ctx,
              appointmentId,
              lang.paymentPlan,
              Icons.calendar_today,
              Colors.purple,
            ),
          ],
        );
      },
    );
  }

  SimpleDialogOption _buildPaymentOption(
    BuildContext ctx,
    int id,
    String label,
    IconData icon,
    Color color,
  ) {
    return SimpleDialogOption(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
      onPressed: () {
        Navigator.pop(ctx);
        _updateStatus(id, 'concluido', paymentMethod: label);
      },
    );
  }

  String _formatTime(String isoString) {
    return DateFormat('HH:mm').format(DateTime.parse(isoString).toLocal());
  }

  Map<String, dynamic> _processAppointmentData(Map<String, dynamic> apt) {
    final lang = AppLocalizations.of(context)!;

    String serviceNames = '';
    double totalPrice = 0.0;

    if (apt['appointment_services'] != null &&
        (apt['appointment_services'] as List).isNotEmpty) {
      final items = apt['appointment_services'] as List;
      serviceNames = items.map((i) => i['services']['name']).join(', ');
      totalPrice = items.fold(0.0, (sum, i) => sum + (i['price'] ?? 0.0));
    } else if (apt['services'] != null) {
      serviceNames = apt['services']['name'];
    }

    return {
      'clientName': apt['clients'] != null
          ? apt['clients']['full_name']
          : lang.labelUnknownClient,
      'vehicleInfo': apt['vehicles'] != null
          ? "${apt['vehicles']['model']} - ${apt['vehicles']['category'] ?? lang.labelCategoryNoCategory}"
          : lang.labelUnknownVehicle,
      'serviceNames': serviceNames,
      'totalPrice': totalPrice,
      'status': apt['status'],
      'isCompleted': apt['status'] == 'concluido',
      'isCancelled': apt['status'] == 'cancelado',
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final String displayName =
        currentUser?.userMetadata?['full_name'] ?? 'Usuário';
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: UserProfileMenu(),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_symbol.png',
          height: 36,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Text(lang.appTitle),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String langCode) =>
                MyApp.setLocale(context, Locale(langCode)),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'pt', child: Text('🇧🇷 Português')),
              PopupMenuItem(value: 'en', child: Text('🇺🇸 English')),
              PopupMenuItem(value: 'es', child: Text('🇪🇸 Español')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${lang.labelHello}, $displayName",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.today,
                          color: AppColors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${lang.agendaToday} ($_todayAppointmentsCount)",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildAppointmentList(
                      _todayAppointments,
                      isToday: true,
                      emptyMsg: lang.agendaEmptyToday,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lang.agendaUpcoming,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildAppointmentList(
                      _upcomingAppointments,
                      isToday: false,
                      emptyMsg: lang.agendaEmptyUpcoming,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFab() {
    final lang = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      offset: const Offset(0, -200),
      tooltip: lang.btnNew,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      onSelected: (value) {
        Widget screen;
        if (value == 'cliente')
          screen = const AddClientScreen();
        else if (value == 'carro')
          screen = const AddVehicleScreen();
        else
          screen = const AddAppointmentScreen();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ).then((_) => _loadDashboardData());
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'cliente',
          child: Row(
            children: [
              const Icon(Icons.person_add, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(lang.titleNewClient),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'carro',
          child: Row(
            children: [
              const Icon(Icons.directions_car, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(lang.titleNewVehicle),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'agendamento',
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(lang.titleNewAppointment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentList(
    List<Map<String, dynamic>> list, {
    required bool isToday,
    required String emptyMsg,
  }) {
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(
              isToday ? Icons.check_circle_outline : Icons.event_busy,
              size: 40,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text(emptyMsg, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final lang = AppLocalizations.of(context)!;
    final currencySymbol = NumberFormat.simpleCurrency(name: '').currencySymbol;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final apt = list[index];
        final data = _processAppointmentData(apt);
        final String status = data['status'] ?? 'pendente';
        final bool isCancelled = data['isCancelled'];

        IconData actionIcon;
        Color actionColor;
        String tooltip;
        VoidCallback? onPressed;

        if (isCancelled) {
          actionIcon = Icons.refresh;
          actionColor = Colors.grey;
          tooltip = lang.btnReactivate;
          onPressed = () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(lang.dialogReactivateTitle),
                content: Text(lang.dialogReactivateContent),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(lang.btnCancel),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _updateStatus(apt['id'], 'pendente'); // REATIVAR
                    },
                    child: Text(lang.btnReactivate),
                  ),
                ],
              ),
            );
          };
        } else if (status == 'pendente') {
          actionIcon = Icons.play_arrow_rounded;
          actionColor = Colors.orange;
          tooltip = lang.btnStartService;
          onPressed = () => _updateStatus(apt['id'], 'em_andamento');
        } else if (status == 'em_andamento') {
          actionIcon = Icons.playlist_add_check_rounded;
          actionColor = Colors.blue;
          tooltip = lang.titleChecklist;
          onPressed = () => _showChecklistDialog(apt);
        } else {
          actionIcon = Icons.check_circle;
          actionColor = AppColors.success;
          tooltip = lang.tooltipDetails;
          onPressed = () {};
        }

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCancelled
                    ? Colors.grey.shade200
                    : (isToday
                          ? AppColors.accent.withValues(alpha: 0.15)
                          : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(apt['start_time']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? Colors.grey
                          : (isToday ? AppColors.primary : Colors.grey[700]),
                      decoration: isCancelled
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (!isToday)
                    Text(
                      DateFormat(
                        'dd/MM',
                      ).format(DateTime.parse(apt['start_time']).toLocal()),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                ],
              ),
            ),
            title: Text(
              data['clientName'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: isCancelled ? TextDecoration.lineThrough : null,
                color: isCancelled ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 14,
                      color: isCancelled ? Colors.grey : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${data['vehicleInfo']}",
                      style: TextStyle(
                        color: isCancelled ? Colors.grey : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                if (data['serviceNames'].toString().isNotEmpty)
                  Text(
                    "${data['serviceNames']}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (data['totalPrice'] > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "$currencySymbol ${data['totalPrice'].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isCancelled ? Colors.grey : AppColors.success,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        decoration: isCancelled
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
              ],
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(actionIcon, color: actionColor, size: 28),
                  tooltip: tooltip,
                  onPressed: onPressed,
                ),
                if (!data['isCompleted'] && !isCancelled)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == 'cancel') {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(lang.btnCancelAppointment),
                            content: Text(lang.msgConfirmCancel),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(lang.btnCancel),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  _updateStatus(apt['id'], 'cancelado');
                                },
                                child: Text(lang.btnConfirm),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.cancel_presentation,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(lang.btnCancelAppointment),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
