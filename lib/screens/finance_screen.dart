import 'dart:io';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'package:vlinix/l10n/app_localizations.dart';
import 'package:vlinix/theme/app_colors.dart';
import 'package:vlinix/widgets/user_profile_menu.dart';
import 'package:vlinix/screens/add_expense_screen.dart';
import 'package:universal_html/html.dart' as html; // <--- ADICIONADO PARA WEB

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  bool _isLoading = true;

  // Totais
  double _totalRevenue = 0.0;
  double _totalExpenses = 0.0;
  double _netBalance = 0.0;

  // Lista unificada
  List<Map<String, dynamic>> _records = [];

  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'todos';

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  void _changeMonth(int monthsToAdd) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + monthsToAdd,
        1,
      );
      _loadFinanceData();
    });
  }

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _loadFinanceData();
      });
    }
  }

  void _changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _loadFinanceData();
    });
  }

  // --- ATUALIZAR STATUS NO FINANCEIRO (RECEITAS) ---
  Future<void> _updateAppointmentStatus(
    int id,
    String newStatus, {
    String? paymentMethod,
  }) async {
    setState(() => _isLoading = true);
    final lang = AppLocalizations.of(context)!;
    try {
      final Map<String, dynamic> updateData = {'status': newStatus};
      if (paymentMethod != null) {
        updateData['payment_method'] = paymentMethod;
      }

      if (newStatus == 'cancelado') {
        updateData['google_event_id'] = null;
      }

      await Supabase.instance.client
          .from('appointments')
          .update(updateData)
          .eq('id', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'concluido'
                  ? lang.msgPaymentConfirmed
                  : lang.msgAppointmentCancelled,
            ),
            backgroundColor: newStatus == 'concluido'
                ? AppColors.success
                : Colors.grey,
          ),
        );
      }

      _loadFinanceData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.msgErrorGeneric(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  // --- EXCLUIR DESPESA ---
  Future<void> _deleteExpense(int id) async {
    final lang = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.dialogDeleteExpenseTitle),
        content: Text(lang.dialogDeleteExpenseContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              lang.btnCancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(lang.btnDelete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('expenses').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.msgExpenseDeleted),
            backgroundColor: AppColors.success,
          ),
        );
      }
      _loadFinanceData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.msgErrorGeneric(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  // --- DIÁLOGO DE PAGAMENTO ---
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
              'dinheiro',
              Icons.money,
              Colors.green,
            ),
            _buildPaymentOption(
              ctx,
              appointmentId,
              lang.paymentCard,
              'cartao',
              Icons.credit_card,
              Colors.blue,
            ),
            _buildPaymentOption(
              ctx,
              appointmentId,
              lang.paymentPlan,
              'plano',
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
    String internalValue,
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
        _updateAppointmentStatus(id, 'concluido', paymentMethod: internalValue);
      },
    );
  }

  Future<void> _loadFinanceData() async {
    setState(() => _isLoading = true);

    final startOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    ).toUtc().toIso8601String();
    final endOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
      23,
      59,
      59,
    ).toUtc().toIso8601String();

    final supabase = Supabase.instance.client;

    try {
      var queryRevenue = supabase
          .from('appointments')
          .select('''
            id,
            start_time, 
            status,
            payment_method, 
            clients(full_name), 
            appointment_services(price, services(name)), 
            services(name, price) 
            ''')
          .gte('start_time', startOfMonth)
          .lte('start_time', endOfMonth);

      if (_selectedFilter == 'pendentes') {
        queryRevenue = queryRevenue.inFilter('status', const [
          'pendente',
          'em_andamento',
        ]);
      } else {
        queryRevenue = queryRevenue.eq('status', 'concluido');

        if (_selectedFilter != 'todos') {
          List<String> allowedValues = [];
          if (_selectedFilter == 'dinheiro')
            allowedValues = ['dinheiro', 'Dinheiro', 'Cash', 'Efectivo'];
          else if (_selectedFilter == 'cartao')
            allowedValues = ['cartao', 'Cartão', 'Card', 'Tarjeta'];
          else if (_selectedFilter == 'plano')
            allowedValues = [
              'plano',
              'Plano Mensal',
              'Monthly Plan',
              'Plan Mensual',
            ];

          if (allowedValues.isNotEmpty) {
            queryRevenue = queryRevenue.inFilter(
              'payment_method',
              allowedValues,
            );
          }
        }
      }

      final revenueData = await queryRevenue;

      // 2. BUSCAR DESPESAS
      List<dynamic> expensesData = [];
      if (_selectedFilter == 'todos') {
        expensesData = await supabase
            .from('expenses')
            .select()
            .gte('date', startOfMonth)
            .lte('date', endOfMonth);
      }

      // 3. PROCESSAMENTO
      double revenueTotal = 0.0;
      double expenseTotal = 0.0;
      final List<Map<String, dynamic>> combinedList = [];

      for (var item in revenueData) {
        double appointmentTotal = 0.0;
        String serviceNames = '';

        if (item['appointment_services'] != null &&
            (item['appointment_services'] as List).isNotEmpty) {
          final items = item['appointment_services'] as List;
          appointmentTotal = items.fold(
            0.0,
            (sum, i) => sum + (i['price'] ?? 0.0),
          );
          serviceNames = items.map((i) => i['services']['name']).join(', ');
        } else if (item['services'] != null) {
          final s = item['services'];
          appointmentTotal = (s['price'] is int)
              ? (s['price'] as int).toDouble()
              : (s['price'] as double? ?? 0.0);
          serviceNames = s['name'];
        }

        revenueTotal += appointmentTotal;
        final isPending =
            item['status'] == 'pendente' || item['status'] == 'em_andamento';

        combinedList.add({
          'id': item['id'],
          'type': isPending ? 'pending' : 'income',
          'date': item['start_time'],
          'title': serviceNames,
          'subtitle': item['clients'] != null
              ? item['clients']['full_name']
              : 'Cliente?',
          'value': appointmentTotal,
          'isPending': isPending,
          'rawMethod': item['payment_method'],
        });
      }

      for (var item in expensesData) {
        final double val = (item['amount'] is int)
            ? (item['amount'] as int).toDouble()
            : (item['amount'] as double);
        expenseTotal += val;

        combinedList.add({
          'id': item['id'],
          'type': 'expense',
          'date': item['date'],
          'titleRaw': item['description'],
          'value': val,
        });
      }

      combinedList.sort(
        (a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
      );

      if (mounted) {
        setState(() {
          _totalRevenue = revenueTotal;
          _totalExpenses = expenseTotal;

          if (_selectedFilter == 'todos') {
            _netBalance = revenueTotal - expenseTotal;
          } else {
            _netBalance = revenueTotal;
          }

          _records = combinedList;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro Financeiro: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- FUNÇÃO DE EXPORTAR PARA EXCEL (100% TRADUZIDA E ESTILIZADA) ---
  // --- FUNÇÃO DE EXPORTAR PARA EXCEL (100% TRADUZIDA E ESTILIZADA E SEM ERROS) ---
  // --- FUNÇÃO DE EXPORTAR PARA EXCEL (100% TRADUZIDA, ESTILIZADA E COMPATÍVEL COM WEB/MOBILE) ---
  Future<void> _exportToExcel() async {
    final lang = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final currencySymbol = locale == 'pt' ? 'R\$' : '\$';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang.msgGeneratingExcel),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      var excel = Excel.createExcel();

      for (var sheetName in excel.tables.keys.toList()) {
        excel.delete(sheetName);
      }

      void populateSheet(String sheetName, String filterType) {
        Sheet sheet = excel[sheetName];

        // --- ESTILO DO CABEÇALHO ---
        CellStyle headerStyle = CellStyle(
          bold: true,
          fontColorHex: ExcelColor.white,
          backgroundColorHex: ExcelColor.blue,
          horizontalAlign: HorizontalAlign.Center,
        );

        var headers = [
          lang.excelColDate,
          lang.excelColType,
          lang.excelColDesc,
          lang.excelColClient,
          lang.excelColMethod,
          '${lang.excelColValue} ($currencySymbol)',
        ];

        // Aplicando as colunas do Cabeçalho com o Estilo
        for (var i = 0; i < headers.length; i++) {
          var cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
          );
          cell.value = TextCellValue(headers[i]);
          cell.cellStyle = headerStyle;
        }

        // Filtro de Dados
        List<Map<String, dynamic>> filteredList = [];

        if (filterType == 'Todos') {
          filteredList = _records;
        } else if (filterType == 'A Receber') {
          filteredList = _records
              .where((item) => item['type'] == 'pending')
              .toList();
        } else if (filterType == 'Dinheiro') {
          filteredList = _records
              .where(
                (item) =>
                    item['type'] == 'income' &&
                    [
                      'dinheiro',
                      'Dinheiro',
                      'Cash',
                      'Efectivo',
                    ].contains(item['rawMethod']),
              )
              .toList();
        } else if (filterType == 'Cartão') {
          filteredList = _records
              .where(
                (item) =>
                    item['type'] == 'income' &&
                    [
                      'cartao',
                      'Cartão',
                      'Card',
                      'Tarjeta',
                    ].contains(item['rawMethod']),
              )
              .toList();
        } else if (filterType == 'Despesas') {
          filteredList = _records
              .where((item) => item['type'] == 'expense')
              .toList();
        }

        double totalSheetValue = 0.0;

        // Popula as linhas a partir do índice 1 (abaixo do cabeçalho)
        for (int row = 0; row < filteredList.length; row++) {
          var item = filteredList[row];
          final isExpense = item['type'] == 'expense';
          final isPending = item['type'] == 'pending';

          String data = DateFormat(
            'dd/MM/yyyy',
            locale,
          ).format(DateTime.parse(item['date']).toLocal());
          String tipo = isExpense
              ? lang.excelTypeExpense
              : (isPending ? lang.excelTypePending : lang.excelTypeIncome);
          String titulo = isExpense
              ? (item['titleRaw'] ?? lang.labelExpenseTitle)
              : item['title'];
          String subtitulo = isExpense
              ? lang.labelExpenseSubtitle
              : item['subtitle'];

          String metodo = '';
          if (isExpense) {
            metodo = '-';
          } else if (isPending) {
            metodo = lang.excelStatusWaiting;
          } else {
            // Traduz a forma de pagamento do banco para o Excel
            final rawMethod = item['rawMethod'];
            if (rawMethod == null) {
              metodo = lang.labelWithoutRegistration;
            } else if ([
              'dinheiro',
              'Dinheiro',
              'Cash',
              'Efectivo',
            ].contains(rawMethod)) {
              metodo = lang.paymentCash;
            } else if ([
              'cartao',
              'Cartão',
              'Card',
              'Tarjeta',
            ].contains(rawMethod)) {
              metodo = lang.paymentCard;
            } else if ([
              'plano',
              'Plano Mensal',
              'Monthly Plan',
              'Plan Mensual',
            ].contains(rawMethod)) {
              metodo = lang.paymentPlan;
            } else {
              metodo = rawMethod;
            }
          }

          double valor = item['value'];
          double displayValue = isExpense ? -valor : valor;
          totalSheetValue += displayValue;

          sheet.appendRow([
            TextCellValue(data),
            TextCellValue(tipo),
            TextCellValue(titulo),
            TextCellValue(subtitulo),
            TextCellValue(metodo),
            DoubleCellValue(displayValue),
          ]);
        }

        // Pula uma linha
        sheet.appendRow([
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
          TextCellValue(''),
        ]);

        // --- ESTILO E ADIÇÃO DA LINHA TOTALIZADORA ---
        CellStyle totalStyle = CellStyle(
          bold: true,
          fontColorHex: totalSheetValue >= 0
              ? ExcelColor.green
              : ExcelColor.red,
        );

        int totalRowIndex = filteredList.length + 2;

        var totalLabelCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: totalRowIndex),
        );
        totalLabelCell.value = TextCellValue(lang.excelTotal);
        totalLabelCell.cellStyle = CellStyle(bold: true);

        var totalValueCell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: totalRowIndex),
        );
        totalValueCell.value = DoubleCellValue(totalSheetValue);
        totalValueCell.cellStyle = totalStyle;
      }

      // Nomes das abas traduzidos
      populateSheet(lang.excelSheetAll, 'Todos');
      populateSheet(lang.excelSheetReceivable, 'A Receber');
      populateSheet(lang.excelSheetCash, 'Dinheiro');
      populateSheet(lang.excelSheetCard, 'Cartão');
      populateSheet(lang.excelSheetExpenses, 'Despesas');

      // --- VERIFICAÇÃO DE PLATAFORMA ---
      if (!kIsWeb) {
        // MOBILE LÓGICA
        Directory directory = await getApplicationDocumentsDirectory();
        String monthStr = DateFormat('MM_yyyy').format(_selectedDate);
        String filePath = '${directory.path}/VLINIX_Financeiro_$monthStr.xlsx';

        File file = File(filePath);
        final bytes = excel.encode();
        if (bytes != null) {
          await file.writeAsBytes(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(lang.msgExcelSaved(monthStr)),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      } else {
        // WEB LÓGICA
        final bytes = excel.encode();
        if (bytes != null) {
          String monthStr = DateFormat('MM_yyyy').format(_selectedDate);
          String filename = 'VLINIX_Financeiro_$monthStr.xlsx';

          // Cria um arquivo "virtual" (Blob) na memória do navegador
          final blob = html.Blob(
            [bytes],
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          );
          final url = html.Url.createObjectUrlFromBlob(blob);

          // Cria um link invisível, clica nele para baixar e depois destrói o link
          html.AnchorElement(href: url)
            ..setAttribute('download', filename)
            ..click();

          html.Url.revokeObjectUrl(url);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  lang.msgExcelDownloadStarted(filename),
                ), // Tradução aplicada aqui!
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.msgExportError(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatCurrency(double value) {
    final locale = Localizations.localeOf(context).languageCode;
    final symbol = locale == 'pt' ? 'R\$' : '\$';
    return NumberFormat.currency(locale: locale, symbol: symbol).format(value);
  }

  String _formatDate(String isoString) {
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat(
      'dd/MM',
      locale,
    ).format(DateTime.parse(isoString).toLocal());
  }

  Color _getTypeColor(String type) {
    if (type == 'expense') return AppColors.error;
    if (type == 'pending') return Colors.orange;
    return AppColors.success;
  }

  String _getTopBannerText(AppLocalizations lang) {
    if (_selectedFilter == 'todos') return lang.labelNetBalance;
    if (_selectedFilter == 'pendentes') return lang.labelTotalReceivable;
    if (_selectedFilter == 'dinheiro')
      return lang.labelTotal(lang.paymentCash.toUpperCase());
    if (_selectedFilter == 'cartao')
      return lang.labelTotal(lang.paymentCard.toUpperCase());
    if (_selectedFilter == 'plano')
      return lang.labelTotal(lang.paymentPlan.toUpperCase());
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: UserProfileMenu(),
        ),
        title: Text(lang.financeTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip: lang.tooltipExportExcel,
            onPressed: _records.isEmpty ? null : _exportToExcel,
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: _selectedFilter == 'todos'
          ? FloatingActionButton(
              heroTag: 'fab_expenses',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen(),
                  ),
                );
                if (result == true) _loadFinanceData();
              },
              backgroundColor: AppColors.error,
              child: const Icon(Icons.remove, color: Colors.white),
            )
          : null,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _changeMonth(-1),
                ),
                InkWell(
                  onTap: _pickMonthYear,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat(
                            'MMMM yyyy',
                            locale,
                          ).format(_selectedDate).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('todos', lang.filterAll),
                const SizedBox(width: 8),
                _buildFilterChip('pendentes', lang.filterPending),
                const SizedBox(width: 8),
                _buildFilterChip('dinheiro', lang.paymentCash),
                const SizedBox(width: 8),
                _buildFilterChip('cartao', lang.paymentCard),
                const SizedBox(width: 8),
                _buildFilterChip('plano', lang.paymentPlan),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C2C2C), AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  _getTopBannerText(lang),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.accent)
                    : Text(
                        _formatCurrency(_netBalance),
                        style: TextStyle(
                          color: _selectedFilter == 'pendentes'
                              ? Colors.orange
                              : (_netBalance >= 0
                                    ? AppColors.accent
                                    : AppColors.error),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 16),

                if (!_isLoading && _selectedFilter == 'todos')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                            size: 16,
                          ),
                          Text(
                            _formatCurrency(_totalRevenue),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 20, color: Colors.white24),
                      Column(
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          Text(
                            _formatCurrency(_totalExpenses),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        Text(
                          lang.financeEmpty,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _records.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _records[index];
                      final isExpense = item['type'] == 'expense';
                      final isPending = item['type'] == 'pending';
                      final valColor = _getTypeColor(item['type']);
                      final int? itemId = item['id'];

                      String displayTitle = '';
                      String displaySubtitle = '';
                      String displayMethod = '';

                      if (isExpense) {
                        displayTitle =
                            item['titleRaw'] ?? lang.labelExpenseTitle;
                        displaySubtitle = lang.labelExpenseSubtitle;
                        displayMethod = 'N/A';
                      } else {
                        displayTitle = item['title'];
                        displaySubtitle = item['subtitle'];

                        if (isPending) {
                          displayMethod = lang.statusAwaitingPayment;
                        } else {
                          final rawMethod = item['rawMethod'];
                          if (rawMethod == null) {
                            displayMethod = lang.labelWithoutRegistration;
                          } else if ([
                            'dinheiro',
                            'Dinheiro',
                            'Cash',
                            'Efectivo',
                          ].contains(rawMethod)) {
                            displayMethod = lang.paymentCash;
                          } else if ([
                            'cartao',
                            'Cartão',
                            'Card',
                            'Tarjeta',
                          ].contains(rawMethod)) {
                            displayMethod = lang.paymentCard;
                          } else if ([
                            'plano',
                            'Plano Mensal',
                            'Monthly Plan',
                            'Plan Mensual',
                          ].contains(rawMethod)) {
                            displayMethod = lang.paymentPlan;
                          } else {
                            displayMethod = rawMethod;
                          }
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatDate(item['date']).split('/')[0],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: valColor,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(item['date']).split('/')[1],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isPending
                                        ? '⏳ $displaySubtitle'
                                        : displaySubtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isPending
                                          ? Colors.orange.shade700
                                          : Colors.grey[600],
                                      fontWeight: isPending
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${isExpense ? '-' : (isPending ? '' : '+')}${_formatCurrency(item['value'])}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: valColor,
                                  ),
                                ),
                                if (displayMethod != 'N/A')
                                  Text(
                                    displayMethod,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                              ],
                            ),

                            if (isPending && itemId != null)
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                onSelected: (value) {
                                  if (value == 'pay') {
                                    _showPaymentDialog(itemId);
                                  } else if (value == 'cancel') {
                                    _updateAppointmentStatus(
                                      itemId,
                                      'cancelado',
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'pay',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(lang.btnConfirmPayment),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'cancel',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.cancel,
                                          color: AppColors.error,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(lang.btnCancelAppointment),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else if (isExpense && itemId != null)
                              PopupMenuButton<String>(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                ),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteExpense(itemId);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          color: AppColors.error,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(lang.btnDelete),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String internalValue, String displayLabel) {
    final isSelected = _selectedFilter == internalValue;
    return FilterChip(
      label: Text(displayLabel),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) _changeFilter(internalValue);
      },
      selectedColor: AppColors.accent,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
    );
  }
}
