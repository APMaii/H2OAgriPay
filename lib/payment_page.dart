import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const double _kHorizontalPadding = 24.0;
  static const double _kVerticalPadding = 32.0;

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  String? _selectedImagePath;

  // Card data - In production, this should come from a secure source
  final CardDetails _cardDetails = const CardDetails(
    number: '1234 5678 9012 3456',
    holderName: 'John Doe',
    expiryDate: '12/25',
  );

  Future<String> _fetchDebitNumber() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return '293223';
    } catch (e) {
      throw Exception('Failed to fetch debit ammount');
    }
  }

  Future<void> _handleImageSelection() async {
    // TODO: Implement image picker
    setState(() => _selectedImagePath = 'path/to/image.jpg');
  }

  Future<void> _handleSubmit() async {
    try {
      _isLoading.value = true;
      // Simulate form submission
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment details submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: _kHorizontalPadding,
                vertical: _kVerticalPadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildCreditCard(theme),
                  const SizedBox(height: 32),
                  _buildDebitNumber(),
                  const SizedBox(height: 32),
                  _buildImageUpload(theme),
                  const SizedBox(height: 48),
                  _buildSubmitButton(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard(ThemeData theme) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 32,
            left: 24,
            child: Image.asset(
              'assets/chip.png',
              height: 40,
              width: 40,
            ),
          ),
          Positioned(
            top: 90,
            left: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _copyToClipboard(_cardDetails.number),
                  child: Text(
                    _cardDetails.number,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _copyToClipboard(_cardDetails.holderName),
                  child: Text(
                    _cardDetails.holderName.toUpperCase(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: Text(
              _cardDetails.expiryDate,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebitNumber() {
    return FutureBuilder<String>(
      future: _fetchDebitNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            'Failed to fetch debit number',
            style: TextStyle(color: Colors.red),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.grey),
              const SizedBox(width: 12),
              Text(
                'Debit Ammount: ${snapshot.data}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageUpload(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _selectedImagePath != null ? Icons.image : Icons.cloud_upload,
            color: theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedImagePath ?? 'Upload payment proof',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          IconButton(
            onPressed: _handleImageSelection,
            icon: const Icon(Icons.add_a_photo),
            color: theme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return FilledButton(
          onPressed: isLoading ? null : _handleSubmit,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : const Text(
            'Submit Payment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}

class CardDetails {
  final String number;
  final String holderName;
  final String expiryDate;

  const CardDetails({
    required this.number,
    required this.holderName,
    required this.expiryDate,
  });
}
