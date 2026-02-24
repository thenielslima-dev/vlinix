import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:vlinix/theme/app_colors.dart';
import 'package:vlinix/l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddClientScreen extends StatefulWidget {
  final Map<String, dynamic>? clientToEdit;

  const AddClientScreen({super.key, this.clientToEdit});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // --- NOVOS CONTROLES DE ENDEREÇO ---
  final _zipController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  bool _isLoading = false;
  bool _isSearchingZip = false;

  // Estado para controlar qual país está selecionado (Padrão: BR)
  String _selectedCountry = 'BR';

  // --- DEFINIÇÃO DAS MÁSCARAS ---
  final maskBR = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final maskUS = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final maskMX = MaskTextInputFormatter(
    mask: '(##) #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  MaskTextInputFormatter get _currentMask {
    switch (_selectedCountry) {
      case 'US':
        return maskUS;
      case 'MX':
        return maskMX;
      default:
        return maskBR;
    }
  }

  String get _countryPrefix {
    switch (_selectedCountry) {
      case 'US':
        return '+1 ';
      case 'MX':
        return '+52 ';
      default:
        return '+55 ';
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.clientToEdit != null) {
      _nameController.text = widget.clientToEdit!['full_name'] ?? '';
      _phoneController.text = widget.clientToEdit!['phone'] ?? '';
      _emailController.text = widget.clientToEdit!['email'] ?? '';

      // Como o endereço antigo era uma string única, colocamos na 'Rua' para o usuário não perder a info
      _streetController.text = widget.clientToEdit!['address'] ?? '';
    }
  }

  // --- BUSCA AUTOMÁTICA DE ENDEREÇO (CEP / ZIPCODE) ---
  Future<void> _searchZipCode() async {
    final zip = _zipController.text.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '');
    if (zip.isEmpty) return;

    setState(() => _isSearchingZip = true);

    try {
      if (_selectedCountry == 'BR') {
        // API para Brasil (ViaCEP)
        final res = await http.get(
          Uri.parse('https://viacep.com.br/ws/$zip/json/'),
        );
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          if (data['erro'] == null) {
            setState(() {
              _streetController.text = data['logradouro'] ?? '';
              _cityController.text = data['localidade'] ?? '';
              _stateController.text = data['uf'] ?? '';
            });
          }
        }
      } else if (_selectedCountry == 'US') {
        // API para Estados Unidos (Zippopotam)
        final res = await http.get(
          Uri.parse('https://api.zippopotam.us/us/$zip'),
        );
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final places = data['places'] as List;
          if (places.isNotEmpty) {
            setState(() {
              _cityController.text = places[0]['place name'] ?? '';
              _stateController.text = places[0]['state abbreviation'] ?? '';
            });
          }
        }
      } else if (_selectedCountry == 'MX') {
        // API para México (Zippopotam)
        final res = await http.get(
          Uri.parse('https://api.zippopotam.us/mx/$zip'),
        );
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final places = data['places'] as List;
          if (places.isNotEmpty) {
            setState(() {
              _cityController.text = places[0]['place name'] ?? '';
              _stateController.text = places[0]['state abbreviation'] ?? '';
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar CEP/Zip: $e');
    } finally {
      setState(() => _isSearchingZip = false);
    }
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final lang = AppLocalizations.of(context)!;

    try {
      final supabase = Supabase.instance.client;
      final fullPhone = _phoneController.text.trim();

      // Montar o endereço em uma string formatada para salvar no banco
      List<String> addressParts = [];
      if (_streetController.text.isNotEmpty) {
        String street = _streetController.text.trim();
        if (_numberController.text.isNotEmpty)
          street += ', ${_numberController.text.trim()}';
        addressParts.add(street);
      }
      if (_cityController.text.isNotEmpty) {
        String cityState = _cityController.text.trim();
        if (_stateController.text.isNotEmpty)
          cityState += ' - ${_stateController.text.trim()}';
        addressParts.add(cityState);
      }
      if (_zipController.text.isNotEmpty)
        addressParts.add(_zipController.text.trim());

      final finalAddress = addressParts.join(' | ');

      final data = {
        'full_name': _nameController.text.trim(),
        'phone': fullPhone,
        'email': _emailController.text.trim(),
        'address': finalAddress,
      };

      if (widget.clientToEdit == null) {
        await supabase.from('clients').insert(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.msgClientCreated),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        await supabase
            .from('clients')
            .update(data)
            .eq('id', widget.clientToEdit!['id']);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lang.msgClientUpdated),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.msgErrorGeneric(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.clientToEdit != null;
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? lang.titleEditClient : lang.titleNewClient),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DADOS PESSOAIS ---
                    Text(
                      lang.labelProfileInfo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: lang.labelName,
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? lang.msgEmptyName
                          : null,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountry,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCountry = newValue!;
                                  _phoneController.clear();
                                  _zipController
                                      .clear(); // Limpa CEP ao trocar país
                                });
                              },
                              items: const [
                                DropdownMenuItem(
                                  value: 'BR',
                                  child: Text('🇧🇷 BR'),
                                ),
                                DropdownMenuItem(
                                  value: 'US',
                                  child: Text('🇺🇸 US'),
                                ),
                                DropdownMenuItem(
                                  value: 'MX',
                                  child: Text('🇲🇽 MX'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [_currentMask],
                            decoration: InputDecoration(
                              labelText: lang.labelPhone,
                              prefixIcon: const Icon(Icons.phone),
                              prefixText: _countryPrefix,
                              hintText: _currentMask.getMask(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: lang.labelEmail,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(),
                    ),

                    // --- ENDEREÇO COM AUTOCOMPLETAR ---
                    Text(
                      lang.labelAddress,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _zipController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: lang.labelZipcode,
                              prefixIcon: const Icon(
                                Icons.markunread_mailbox_outlined,
                              ),
                              suffixIcon: _isSearchingZip
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppColors.accent,
                                      ),
                                      onPressed:
                                          _searchZipCode, // CLIQUE NA LUPA PARA BUSCAR
                                    ),
                            ),
                            onFieldSubmitted: (_) =>
                                _searchZipCode(), // ENTER PARA BUSCAR
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _numberController,
                            decoration: InputDecoration(
                              labelText: lang.labelNumber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        labelText: lang.labelStreet,
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: lang.labelCity,
                              prefixIcon: const Icon(Icons.location_city),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: lang.labelState,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // BOTÃO SALVAR
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveClient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          lang.btnSave.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
