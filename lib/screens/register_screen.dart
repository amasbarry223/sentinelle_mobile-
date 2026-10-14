import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/api_exception.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/djenne_logo.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _isBambara = false;
  bool _enableBiometrics = true;
  bool _autoScanSms = true;
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.riskCritical,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                _isBambara
                    ? 'Gundo-kodew tɛ kɛ kelen ye!'
                    : 'Les deux mots de passe ne correspondent pas.',
              ),
            ],
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (!mounted) return;

    final appState = Provider.of<AppState>(context, listen: false);
    final chosenName = _nameController.text.trim().isNotEmpty
        ? _nameController.text.trim()
        : (_isBambara ? "Kalan-Mogo" : "Sentinelle_223");
    final username = chosenName.replaceAll(RegExp(r'\s+'), '_');

    try {
      await appState.register(
        username: username,
        email: _emailController.text.trim(),
        password: _pinController.text,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.riskCritical,
          behavior: SnackBarBehavior.floating,
          content: Text(e.message),
        ),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isBambara ? 'Kɔnti daɲɛna ka ɲa !' : 'Compte créé avec succès !',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    _isBambara
                        ? 'I ka telefoni lakana sisan.'
                        : 'Votre coffre-fort local est activé.',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DjenneLogo(size: 26),
            const SizedBox(width: 8),
            Text(
              'Sentinelle Mali',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Language Switcher in AppBar
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () {
                setState(() => _isBambara = !_isBambara);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
              ),
              child: Text(
                _isBambara ? '🇫🇷 FR' : '🇲🇱 BM',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Audio Bambara helper
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      final spokenText = _isBambara
                          ? "I ka kɔnti dabɔ ka i yɛrɛ lakana. I ka gundo-kode don telefoni kan."
                          : "Créez votre compte pour sécuriser vos historiques et verrouiller votre coffre-fort local.";
                      appState.playBambaraAudio(spokenText, context);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.ochre.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.ochre.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volume_up_rounded, color: AppColors.ochreDark, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '🔊 Écouter en Bambara',
                            style: TextStyle(
                              color: AppColors.ochreDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title & Subtitle
                Text(
                  _isBambara ? 'Kɔnti kura dabɔ' : 'Créer un compte',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _isBambara
                      ? 'I ka kɛlɛli ni signalementw lakana i ka telefoni kan.'
                      : 'Activez votre protection personnalisée et verrouillez vos données sensibles.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),

                // Privacy Trust Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFA5D6A7), width: 1.1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_rounded, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isBambara ? 'Gundo lakana 100%' : 'Protection 100% Locale',
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isBambara
                                  ? 'Kɔnti bɛ to i yɛrɛ ka telefoni kɔnɔ, foyi tɛ taga intɛrinɛti kan.'
                                  : 'Votre profil et vos historiques restent chiffrés sur votre appareil.',
                              style: TextStyle(
                                color: AppColors.primaryGreen.withValues(alpha: 0.85),
                                fontSize: 11.5,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pseudonym Field
                      Text(
                        _isBambara ? 'I tɔgɔ walima gundo-tɔgɔ' : 'Nom ou Pseudonyme',
                        style: AppTypography.titleSmall.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: _isBambara ? 'Ex: Aïcha walima Citoyen_223' : 'Ex: Aïcha ou Citoyen223',
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primaryGreen, size: 22),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Phone Number Field (Optional)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isBambara ? 'Telefoni nimɔrɔ' : 'Numéro de téléphone',
                            style: AppTypography.titleSmall.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.ochre.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _isBambara ? 'A ma wajibiya' : 'Optionnel',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.ochreDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: '70 00 00 00',
                          prefixIcon: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇲🇱 +223', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                SizedBox(width: 8),
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(color: Colors.grey, thickness: 1),
                                ),
                              ],
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // PIN Code (4 digits)
                      Text(
                        _isBambara ? 'Gundo-kode (chiffres 4)' : 'Code secret PIN Sentinelle (4 chiffres)',
                        style: AppTypography.titleSmall.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: _obscurePin,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return _isBambara
                                ? 'Gundo-kode ka kan ka kɛ chiffres 4 ye'
                                : 'Le code PIN doit comporter exactement 4 chiffres';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.ochre, size: 22),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePin = !_obscurePin),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm PIN Code
                      Text(
                        _isBambara ? 'Gundo-kode lasɔmɔ' : 'Confirmer le code PIN',
                        style: AppTypography.titleSmall.copyWith(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPinController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: _obscureConfirmPin,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return _isBambara
                                ? 'I ka gundo-kode lasɔmɔ'
                                : 'Veuillez confirmer votre code PIN';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '••••',
                          prefixIcon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryGreen, size: 22),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPin ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscureConfirmPin = !_obscureConfirmPin),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Security Switches Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder, width: 1.1),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _enableBiometrics,
                        activeThumbColor: AppColors.primaryGreen,
                        onChanged: (val) => setState(() => _enableBiometrics = val),
                        secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryGreen, size: 26),
                        title: Text(
                          _isBambara ? 'Bolokɔnɔ bolodɛmɛ (Empreinte)' : 'Déverrouillage biométrique',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                        subtitle: Text(
                          _isBambara ? 'Don kɔnɔ n’i bolokɔnɔ ye' : 'Accès ultra-rapide par empreinte digitale',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                        ),
                      ),
                      const Divider(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _autoScanSms,
                        activeThumbColor: AppColors.primaryGreen,
                        onChanged: (val) => setState(() => _autoScanSms = val),
                        secondary: const Icon(Icons.shield_outlined, color: AppColors.ochreDark, size: 26),
                        title: Text(
                          _isBambara ? 'SMS kɔrɔbɔri dɛmɛ' : 'Vigilance Mobile Money',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                        subtitle: Text(
                          _isBambara ? 'Orange Money, Moov, Wave lakanana' : 'Détection préventive des faux SMS de transfert',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.shield_rounded, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              _isBambara ? 'Kɔnti dabɔ ka daminɛ' : 'Créer mon compte sécurisé',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // Already have an account link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: _isBambara ? 'Kɔnti bɛ i fɛ kaban ? ' : 'Vous avez déjà un compte ? ',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13.5),
                        children: const [
                          TextSpan(
                            text: 'Se connecter',
                            style: TextStyle(
                              color: AppColors.ochreDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
