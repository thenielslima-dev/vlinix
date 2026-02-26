import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vlinix/theme/app_colors.dart';
import 'package:vlinix/l10n/app_localizations.dart';

// Import das telas filhas
import 'package:vlinix/screens/home_screen.dart';
import 'package:vlinix/screens/clients_screen.dart';
import 'package:vlinix/screens/all_vehicles_screen.dart';
import 'package:vlinix/screens/services_screen.dart';
import 'package:vlinix/screens/finance_screen.dart';
import 'package:vlinix/screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  Timer? _sessionTimer;

  // --- OPÇÃO 2: Variável do Canal Realtime ---
  RealtimeChannel? _securitySubscription;

  final List<Widget> _screens = [
    const ClientsScreen(),
    const AllVehiclesScreen(),
    const HomeScreen(),
    const ServicesScreen(),
    const FinanceScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkDemoUser(); // Mantém sua lógica de 10 min
    _setupRealtimeSecurity(); // <--- ATIVA O "SEGURANÇA" EM TEMPO REAL
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    // --- OPÇÃO 2: Desliga o rádio ao sair ---
    if (_securitySubscription != null) {
      Supabase.instance.client.removeChannel(_securitySubscription!);
    }
    super.dispose();
  }

  // --- OPÇÃO 2: LÓGICA DE ESCUTA EM TEMPO REAL ---
  void _setupRealtimeSecurity() {
    final supabase = Supabase.instance.client;
    final myUserId = supabase.auth.currentUser?.id;

    if (myUserId == null) return;

    // Escuta mudanças na tabela 'profiles' para o ID do usuário logado
    _securitySubscription = supabase
        .channel('public:profiles')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'profiles',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: myUserId,
          ),
          callback: (payload) {
            final isActive = payload.newRecord['is_active'];
            // Se o admin mudar para false, expulsamos na hora
            if (isActive == false) {
              _forceLogout(isSuspended: true);
            }
          },
        )
        .subscribe();
  }

  // --- LÓGICA DE LOGOUT (UNIFICADA) ---
  // Adicionei o parâmetro opcional isSuspended para mudar a mensagem
  Future<void> _forceLogout({bool isSuspended = false}) async {
    if (!mounted) return;

    await Supabase.instance.client.auth.signOut();

    if (mounted) {
      final lang = AppLocalizations.of(context)!;

      // Define qual mensagem mostrar
      String message = isSuspended
          ? "Sua conta foi suspensa pelo administrador." // Você pode criar essa chave no l10n depois
          : lang.msgDemoModeEnded;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // --- LÓGICA DE TEMPO LIMITE (MANTIDA) ---
  void _checkDemoUser() {
    final user = Supabase.instance.client.auth.currentUser;
    const emailDeTeste = 'visitante@vlinix.com';

    if (user?.email == emailDeTeste) {
      debugPrint('⏳ Modo Demonstração iniciado: 10 minutos restantes.');
      _sessionTimer = Timer(const Duration(minutes: 10), () {
        _forceLogout();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final lang = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.msgDemoModeStarted),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... (O restante do seu código de build permanece exatamente igual)
    final lang = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        // ... (seu código de navegação)
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              label: lang.menuClients,
            ),
            NavigationDestination(
              icon: const Icon(Icons.directions_car_outlined),
              label: lang.menuVehicles,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_month_outlined),
              label: lang.menuAgenda,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_offer_outlined),
              label: lang.menuServices,
            ),
            NavigationDestination(
              icon: const Icon(Icons.attach_money),
              label: lang.menuFinance,
            ),
          ],
        ),
      ),
    );
  }
}
