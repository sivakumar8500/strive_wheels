import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step6BankDetails extends StatefulWidget {
  const Step6BankDetails({super.key});

  @override
  State<Step6BankDetails> createState() => _Step6BankDetailsState();
}

class _Step6BankDetailsState extends State<Step6BankDetails> {
  final _accountHolderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _confirmAccountNumberController = TextEditingController();
  final _upiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _accountHolderController.text = data.bankAccountHolderName ?? '';
    _bankNameController.text = data.bankName ?? '';
    _ifscController.text = data.bankIfscCode ?? '';
    _accountNumberController.text = data.bankAccountNumber ?? '';
    _confirmAccountNumberController.text = data.bankAccountNumber ?? '';
    _upiController.text = data.bankUpiId ?? '';
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _bankNameController.dispose();
    _ifscController.dispose();
    _accountNumberController.dispose();
    _confirmAccountNumberController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bank Details',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Payouts will be credited to this account. Ensure the details are accurate to avoid payment delays.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 14, color: AppColors.primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      'SECURE BANKING',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Account Holder Name',
              hintText: 'ALEXANDER REED',
              controller: _accountHolderController,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Bank Name',
              hintText: 'CITIZENS BANK',
              controller: _bankNameController,
              suffixIcon: Icon(
                Icons.account_balance,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'AUTO-DETECTED FROM IFSC',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'IFSC Code',
              hintText: 'CTZN0001402',
              controller: _ifscController,
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'VALIDATED',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Account Number',
              hintText: '8821449201',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm Account Number',
              hintText: '8821449201',
              controller: _confirmAccountNumberController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'UPI ID (Optional)',
              hintText: 'e.g. username@bank',
              controller: _upiController,
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Cancelled Cheque / Passbook',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark.withValues(alpha: 0.5)
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dividerLight),
              ),
              child: Column(
                children: [
                  Icon(Icons.upload_file, color: AppColors.darkBlue, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Choose File or Take Photo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Supported: JPG, PNG, PDF (Max 5MB). Ensure IFSC is visible.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.read<RegistrationBloc>().add(
                    UpdateBankDetailsEvent(
                      bankAccountHolderName: _accountHolderController.text,
                      bankName: _bankNameController.text,
                      bankIfscCode: _ifscController.text,
                      bankAccountNumber: _accountNumberController.text,
                      bankUpiId: _upiController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save & Continue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your data is protected by industry-standard encryption',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
