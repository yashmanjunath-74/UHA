import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unified_health_alliance/core/theme/app_colors.dart';
import 'package:unified_health_alliance/features/registration/lab/providers/lab_registration_provider.dart';

class LabAdminBankScreen extends ConsumerStatefulWidget {
  const LabAdminBankScreen({super.key});

  @override
  ConsumerState<LabAdminBankScreen> createState() => _LabAdminBankScreenState();
}

class _LabAdminBankScreenState extends ConsumerState<LabAdminBankScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _accountHolderController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingController = TextEditingController();

  String? _selectedBank;
  bool _showOtp = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(labRegistrationProvider);
    _emailController.text = state.adminEmail ?? '';
    _phoneController.text = state.mobileNumber ?? '';
    _accountHolderController.text = state.accountHolder ?? '';
    _accountNumberController.text = state.accountNumber ?? '';
    _routingController.text = state.routingCode ?? '';
    _selectedBank = state.bankName;
    _agreed = state.agreedToTerms;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _routingController.dispose();
    super.dispose();
  }

  void _onBack() {
    ref.read(labRegistrationProvider.notifier).previousStep();
    Navigator.pop(context);
  }

  Future<void> _onSubmit() async {
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms to proceed.')),
      );
      return;
    }

    ref
        .read(labRegistrationProvider.notifier)
        .updateField(
          adminEmail: _emailController.text,
          mobileNumber: _phoneController.text,
          bankName: _selectedBank,
          accountHolder: _accountHolderController.text,
          accountNumber: _accountNumberController.text,
          routingCode: _routingController.text,
          agreedToTerms: _agreed,
        );

    final success = await ref
        .read(labRegistrationProvider.notifier)
        .submitRegistration();

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/registration/lab_verification',
        (route) => false,
      );
    }
  }

  void _onGetOtp() {
    ref.read(labRegistrationProvider.notifier).sendOtp();
    setState(() => _showOtp = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin & Bank Setup',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide the authorized administrator details and settlement bank account for payout processing.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.neutral500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Admin Details Section
                    _buildSectionHeader(
                      'Admin Details',
                      Icons.admin_panel_settings,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Authorized Admin Email',
                      controller: _emailController,
                      hint: 'admin@labname.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildPhoneInput(),
                    if (_showOtp) ...[
                      const SizedBox(height: 16),
                      _buildOtpInput(),
                    ],

                    const SizedBox(height: 32),
                    const Divider(color: AppColors.neutral200),
                    const SizedBox(height: 32),

                    // Bank Details Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader(
                          'Bank Settlement',
                          Icons.account_balance,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.lock,
                                size: 12,
                                color: AppColors.neutral500,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Encrypted',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Bank Name',
                      value: _selectedBank,
                      items: [
                        'Chase Bank',
                        'Bank of America',
                        'Wells Fargo',
                        'HDFC Bank',
                        'ICICI Bank',
                      ],
                      onChanged: (val) => setState(() => _selectedBank = val),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Account Holder Name',
                      controller: _accountHolderController,
                      hint: 'e.g. Universal Health Labs Inc.',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Account Number / IBAN',
                      controller: _accountNumberController,
                      hint: '0000 0000 0000',
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Routing / Swift Code',
                      controller: _routingController,
                      hint: 'XXXXXX',
                      icon: Icons.code,
                      isUppercase: true,
                    ),

                    const SizedBox(height: 32),

                    // Agreement
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _agreed,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _agreed = val!),
                          ),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.neutral600,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'UHA Laboratory Standards Agreement',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' and certify that the banking details provided are correct for settlements.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _onBack,
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: AppColors.neutral600,
          ),
          const Text(
            'Setup',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step 3 of 3',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Finalizing',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isUppercase = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: isUppercase
                ? TextCapitalization.characters
                : TextCapitalization.none,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.neutral300),
              suffixIcon: Icon(icon, color: AppColors.neutral400, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.neutral200),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Text(
                            'US', // Mock country code
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.neutral600,
                            ),
                          ),
                          Icon(
                            Icons.expand_more,
                            size: 16,
                            color: AppColors.neutral400,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '+1 (555) 000-0000',
                          hintStyle: TextStyle(color: AppColors.neutral300),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _onGetOtp,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Get OTP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 6, left: 4),
          child: Text(
            "We'll send a code to verify this number.",
            style: TextStyle(fontSize: 10, color: AppColors.neutral400),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  bottom: BorderSide(color: AppColors.neutral300, width: 2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          'Resend Code (24s)',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text(
                'Select your bank',
                style: TextStyle(color: AppColors.neutral300),
              ),
              icon: const Icon(Icons.expand_more, color: AppColors.neutral400),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.neutral100)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit for Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
