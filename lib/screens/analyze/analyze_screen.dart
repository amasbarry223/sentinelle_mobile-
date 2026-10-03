import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/privacy_banner.dart';
import 'analyzing_screen.dart';

class AnalyzeScreen extends StatefulWidget {
  final int initialTabIndex;

  const AnalyzeScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  late int _selectedTab; // 0: Message, 1: Lien, 2: Numéro, 3: Mobile Money

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mmDescController = TextEditingController();

  // Mobile money questions
  String? _selectedSituation = "Un agent me demande mon code";
  bool _askPin = true;
  bool _isUrgent = true;
  bool _askPayment = false;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _linkController.dispose();
    _phoneController.dispose();
    _mmDescController.dispose();
    super.dispose();
  }

  void _triggerAnalysis({
    required String type,
    required String content,
  }) {
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez saisir ou coller un contenu à analyser"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnalyzingScreen(
          type: type,
          content: content,
          askPin: _askPin,
          isUrgent: _isUrgent,
          askPayment: _askPayment,
          situationTag: _selectedSituation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analyser'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Privacy Banner
              const PrivacyBanner(),
              const SizedBox(height: 18),

              // 2. Segmented Tabs
              _buildSegmentedTabs(),
              const SizedBox(height: 20),

              // 3. Tab Specific Body
              if (_selectedTab == 0) _buildMessageTab(),
              if (_selectedTab == 1) _buildLinkTab(),
              if (_selectedTab == 2) _buildPhoneTab(),
              if (_selectedTab == 3) _buildMobileMoneyTab(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    final tabs = ['Message', 'Lien', 'Numéro', 'Mobile Money'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECE7DE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- TAB 0: MESSAGE ---
  Widget _buildMessageTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Area
        Container(
          height: 170,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Collez ici le SMS ou le message reçu...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 14),

        // Quick Input Action Buttons
        Row(
          children: [
            // Coller button
            InkWell(
              onTap: () async {
                final data = await Clipboard.getData('text/plain');
                if (data?.text != null) {
                  setState(() => _messageController.text = data!.text!);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.paste_rounded, size: 16, color: AppColors.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      'Coller',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Importer un SMS
            InkWell(
              onTap: () {
                setState(() {
                  _messageController.text =
                      "Orange Money : Vous avez gagné 500 000 FCFA ! Envoyez votre code PIN au 76 12 34 56 pour valider.";
                });
              },
              child: Row(
                children: [
                  const Icon(Icons.file_download_outlined, size: 18, color: AppColors.ochreDark),
                  const SizedBox(width: 6),
                  Text(
                    'Importer un SMS',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.ochreDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Scanner une capture
        InkWell(
          onTap: () {
            setState(() {
              _messageController.text =
                  "Votre compte Moov sera mis à jour. Cliquez ici : bit.ly/moov-mali avant ce soir.";
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Capture analysée et transcrite avec succès !")),
            );
          },
          child: Row(
            children: [
              const Icon(Icons.crop_free_rounded, size: 18, color: AppColors.ochreDark),
              const SizedBox(width: 6),
              Text(
                'Scanner une capture',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.ochreDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Example Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip('Ex. gain 500 000 F', () {
              setState(() {
                _messageController.text =
                    "Orange Money : Vous avez gagné 500 000 FCFA ! Envoyez votre code PIN au 76 12 34 56 pour récupérer votre lot.";
              });
            }),
            _buildPresetChip('Ex. mise à jour compte', () {
              setState(() {
                _messageController.text =
                    "Votre compte Moov sera mis à jour. Cliquez ici : bit.ly/moov-mali avant ce soir.";
              });
            }),
            _buildPresetChip('Ex. message normal', () {
              setState(() {
                _messageController.text =
                    "Bonjour, c'est Fatoumata. Le marché c'est demain à 9h, n'oublie pas le tissu.";
              });
            }),
          ],
        ),
        const SizedBox(height: 28),

        // Main Submit Button
        _buildAnalyzeCta(
          onTap: () => _triggerAnalysis(
            type: 'SMS',
            content: _messageController.text,
          ),
        ),
      ],
    );
  }

  // --- TAB 1: LIEN ---
  Widget _buildLinkTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input text field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: TextField(
            controller: _linkController,
            decoration: const InputDecoration(
              hintText: 'Collez le lien ici...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
            ),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 12),

        // Hint
        Text(
          'Astuce : partagez directement depuis WhatsApp.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),

        // Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip('Ex. orange-money-mali.xyz', () {
              setState(() => _linkController.text = "orange-money-mali.xyz/remboursement");
            }),
            _buildPresetChip('Ex. bit.ly', () {
              setState(() => _linkController.text = "bit.ly/moov-mali-promo");
            }),
            _buildPresetChip('Ex. site officiel', () {
              setState(() => _linkController.text = "https://www.orangemali.com");
            }),
          ],
        ),
        const SizedBox(height: 28),

        _buildAnalyzeCta(
          onTap: () => _triggerAnalysis(
            type: 'Lien',
            content: _linkController.text,
          ),
        ),
      ],
    );
  }

  // --- TAB 2: NUMERO ---
  Widget _buildPhoneTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number input with +223 pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+223',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '76 12 34 56',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTypography.titleMedium.copyWith(letterSpacing: 1.2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Chips
        Wrap(
          spacing: 8,
          children: [
            _buildPresetChip('Ex. numéro signalé', () {
              setState(() => _phoneController.text = "76 12 34 56");
            }),
            _buildPresetChip('Ex. numéro inconnu', () {
              setState(() => _phoneController.text = "66 44 22 10");
            }),
          ],
        ),
        const SizedBox(height: 28),

        _buildAnalyzeCta(
          label: 'Vérifier le numéro',
          onTap: () => _triggerAnalysis(
            type: 'Numéro',
            content: "+223 ${_phoneController.text}",
          ),
        ),
      ],
    );
  }

  // --- TAB 3: MOBILE MONEY ---
  Widget _buildMobileMoneyTab() {
    final situations = [
      "Un agent me demande mon code",
      "Faux transfert reçu",
      "On me dit que j'ai gagné",
      "On me demande un remboursement",
      "Mon compte serait bloqué",
      "Autre situation",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Situation Grid (6 cards)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: situations.map((sit) {
            final isSelected = _selectedSituation == sit;
            return GestureDetector(
              onTap: () => setState(() => _selectedSituation = sit),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEFF8F2) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryGreen : AppColors.cardBorder,
                    width: isSelected ? 1.8 : 1.2,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  sit,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
                    fontSize: 12.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // 3 Question Cards with Oui / Non toggles
        _buildQuestionRow(
          question: "On vous demande votre PIN ou code ?",
          isYes: _askPin,
          onChanged: (val) => setState(() => _askPin = val),
        ),
        const SizedBox(height: 10),

        _buildQuestionRow(
          question: "C'est présenté comme urgent ?",
          isYes: _isUrgent,
          onChanged: (val) => setState(() => _isUrgent = val),
        ),
        const SizedBox(height: 10),

        _buildQuestionRow(
          question: "Un paiement est demandé avant ?",
          isYes: _askPayment,
          onChanged: (val) => setState(() => _askPayment = val),
        ),
        const SizedBox(height: 16),

        // Optional Message Box
        Container(
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: TextField(
            controller: _mmDescController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Décrivez ou collez le message (facultatif)',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 24),

        _buildAnalyzeCta(
          label: 'Analyser la situation',
          onTap: () {
            final content = _mmDescController.text.trim().isNotEmpty
                ? _mmDescController.text
                : (_selectedSituation ?? "Situation Mobile Money");
            _triggerAnalysis(
              type: 'Mobile Money',
              content: content,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionRow({
    required String question,
    required bool isYes,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              question,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Segmented Oui / Non
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFEA),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(2),
            child: Row(
              children: [
                _buildSegmentOption(
                  label: "Oui",
                  isSelected: isYes,
                  onTap: () => onChanged(true),
                ),
                _buildSegmentOption(
                  label: "Non",
                  isSelected: !isYes,
                  onTap: () => onChanged(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: AppTypography.badgeText.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeCta({
    String label = 'Analyser',
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFDFB67B), // Sahel gold tone
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.center_focus_strong_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
