import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/registration_provider.dart';
import '../../providers/auth_provider.dart';

class Step3Security extends ConsumerStatefulWidget {
  const Step3Security({super.key});

  @override
  ConsumerState<Step3Security> createState() => _Step3SecurityState();
}

class _Step3SecurityState extends ConsumerState<Step3Security> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(registrationProvider);
    _emailController.text = state.email;
    _passwordController.text = state.password;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _syncState() {
    ref
        .read(registrationProvider.notifier)
        .updateSecurity(
          email: _emailController.text,
          password: _passwordController.text,
          isGoogle: false, // Reset Google Auth if user is typing
        );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(registrationProvider.notifier);
    const emeraldGreen = Color(0xFF00A67E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Secure Your Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create a secure password to protect your personal health data.',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
        ),
        const SizedBox(height: 32),

        // Google Sign Up Option
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () async {
              // Trigger Google Sign In and then define isGoogleAuth = true in provider
              try {
                await ref.read(authProvider.notifier).signInWithGoogle();
                // If successful, we update provider
                notifier.updateSecurity(isGoogle: true);
                // And ideally complete registration automagically or move to success?
                // For now, let's just mark it.
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Google Sign Up failed: $e')),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon placeholder
                const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Sign up with Google',
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider(color: Color(0xFFE5E7EB))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or with Email',
                style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFE5E7EB))),
          ],
        ),
        const SizedBox(height: 24),

        // Email Address
        const Text(
          'Email Address',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          onChanged: (_) => _syncState(),
          decoration: InputDecoration(
            hintText: 'alex.doe@example.com',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: const Icon(
              Icons.check_circle,
              color: emeraldGreen,
              size: 20,
            ), // Valid indicator static for now
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Password
        const Text(
          'Create Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => _syncState(),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Strength bar simulator
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: emeraldGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: emeraldGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: emeraldGreen,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        RichText(
          text: const TextSpan(
            text: 'Strength: ',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            children: [
              TextSpan(
                text: 'Good',
                style: TextStyle(
                  color: emeraldGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Confirm Password
        const Text(
          'Confirm Password',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF9CA3AF),
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Terms
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _agreedToTerms,
                activeColor: emeraldGreen,
                onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(color: Color(0xFF374151), fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: emeraldGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: emeraldGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
