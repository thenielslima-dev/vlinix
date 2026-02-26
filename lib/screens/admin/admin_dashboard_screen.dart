import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vlinix/theme/app_colors.dart';
import 'package:vlinix/screens/login_screen.dart';
import 'admin_user_details_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  int _totalUsers = 0;
  double _totalPlatformRevenue = 0.0;
  List<Map<String, dynamic>> _usersList = [];

  // --- VARIÁVEIS PARA O FILTRO DE DATA ---
  DateTime? _startDate;
  DateTime? _endDate;

  // --- NOVA VARIÁVEL: CONTROLADOR DA PESQUISA ---
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPlatformData();

    // Fica escutando a barra de pesquisa para atualizar a lista em tempo real
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- FUNÇÕES DE FILTRO RÁPIDO DE DATA ---
  void _applyQuickFilter(String type) {
    final now = DateTime.now();
    setState(() {
      if (type == 'all') {
        _startDate = null;
        _endDate = null;
      } else if (type == 'today') {
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else if (type == '7days') {
        _startDate = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 6));
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
      } else if (type == 'month') {
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      }
    });
    _loadPlatformData();
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Filtrar Faturamento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.all_inclusive,
                    color: AppColors.primary,
                  ),
                  title: const Text('Todo o período'),
                  onTap: () {
                    Navigator.pop(context);
                    _applyQuickFilter('all');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.today, color: AppColors.primary),
                  title: const Text('Hoje'),
                  onTap: () {
                    Navigator.pop(context);
                    _applyQuickFilter('today');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.view_week,
                    color: AppColors.primary,
                  ),
                  title: const Text('Últimos 7 dias'),
                  onTap: () {
                    Navigator.pop(context);
                    _applyQuickFilter('7days');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                  ),
                  title: const Text('Este mês'),
                  onTap: () {
                    Navigator.pop(context);
                    _applyQuickFilter('month');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.date_range,
                    color: AppColors.accent,
                  ),
                  title: const Text(
                    'Data personalizada...',
                    style: TextStyle(color: AppColors.accent),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickDateRange();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
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
        _startDate = picked.start;
        _endDate = DateTime(
          picked.end.year,
          picked.end.month,
          picked.end.day,
          23,
          59,
          59,
        );
        _loadPlatformData();
      });
    }
  }

  void _clearDateFilter() {
    _applyQuickFilter('all');
  }

  Future<void> _loadPlatformData() async {
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      final profilesData = await supabase
          .from('profiles')
          .select()
          .order('full_name');

      var query = supabase
          .from('appointments')
          .select('tip_amount, appointment_services(price), services(price)')
          .eq('status', 'concluido');

      if (_startDate != null && _endDate != null) {
        query = query
            .gte('start_time', _startDate!.toUtc().toIso8601String())
            .lte('start_time', _endDate!.toUtc().toIso8601String());
      }

      final appointmentsData = await query;

      double totalRev = 0.0;
      for (var apt in appointmentsData) {
        double aptTotal = 0.0;
        if (apt['appointment_services'] != null &&
            (apt['appointment_services'] as List).isNotEmpty) {
          for (var srv in apt['appointment_services']) {
            aptTotal += (srv['price'] ?? 0.0);
          }
        } else if (apt['services'] != null) {
          aptTotal += (apt['services']['price'] ?? 0.0);
        }
        double tip = (apt['tip_amount'] ?? 0.0).toDouble();
        totalRev += (aptTotal + tip);
      }

      if (mounted) {
        setState(() {
          final adminEmails = [
            'theniels.lima@gmail.com',
            'daniel.admin@admin.com',
          ];
          _usersList = profilesData
              .where((user) => !adminEmails.contains(user['email']))
              .toList();

          _totalUsers = _usersList.length;
          _totalPlatformRevenue = totalRev;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Erro Admin Dashboard: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);
  }

  @override
  Widget build(BuildContext context) {
    String dateLabel = 'Histórico Total (Todo o período)';
    if (_startDate != null && _endDate != null) {
      final startStr = DateFormat('dd/MM/yyyy').format(_startDate!);
      final endStr = DateFormat('dd/MM/yyyy').format(_endDate!);
      dateLabel = startStr == endStr ? startStr : '$startStr até $endStr';
    }

    // --- NOVA LÓGICA: FILTRA A LISTA PARA MOSTRAR NA TELA ---
    final filteredUsers = _usersList.where((user) {
      final name = (user['full_name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || email.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Painel VIP - Vlinix'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.error),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : RefreshIndicator(
              onRefresh: _loadPlatformData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1A1A1A), AppColors.primary],
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
                          const Text(
                            'FATURAMENTO DA PLATAFORMA',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatCurrency(_totalPlatformRevenue),
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _showFilterMenu,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: AppColors.accent,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    dateLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (_startDate != null) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _clearDateFilter,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.business_center,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$_totalUsers Usuários Cadastrados',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- NOVA SEÇÃO: PESQUISA E TÍTULO ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Usuários Cadastrados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        // Badge mostrando quantos usuários a pesquisa encontrou
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${filteredUsers.length}',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Barra de pesquisa
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar por nome ou e-mail...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- LISTA FILTRADA ---
                    if (filteredUsers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhum usuário encontrado.',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          // Usando a lista filtrada agora!
                          final user = filteredUsers[index];
                          final name = user['full_name'] ?? 'Usuário sem nome';

                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.accent.withValues(
                                  alpha: 0.2,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.accent,
                                ),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                user['email'] ?? 'Sem e-mail cadastrado',
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminUserDetailsScreen(user: user),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
