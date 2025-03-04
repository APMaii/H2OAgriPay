import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';

class TurnoverPage extends StatefulWidget {
  const TurnoverPage({super.key});

  @override
  State<TurnoverPage> createState() => _TurnoverPageState();
}

class _TurnoverPageState extends State<TurnoverPage> {
  // Initialize formatters
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  final DateFormat _dateFormatter = DateFormat('MMM d, y');

  // Mock transactions data
  final List<Transaction> _transactions = [
    Transaction(date: DateTime(2025, 2, 20), amount: 25.99),
    Transaction(date: DateTime(2025, 2, 19), amount: 15.50),
    Transaction(date: DateTime(2025, 2, 18), amount: 45.00),
    Transaction(date: DateTime(2025, 2, 17), amount: 10.25),
    Transaction(date: DateTime(2025, 2, 16), amount: 30.75),
    Transaction(date: DateTime(2025, 2, 20), amount: 23.99),
    Transaction(date: DateTime(2025, 2, 19), amount: 115.50),
    Transaction(date: DateTime(2025, 2, 18), amount: 455.00),
    Transaction(date: DateTime(2025, 2, 17), amount: 100.25),
    Transaction(date: DateTime(2025, 2, 16), amount: 330.75),
  ];

  double get _totalAmount => _transactions.fold(0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(theme),
          SliverToBoxAdapter(
            child: _buildTotalDisplay(theme),
          ),
          _buildTransactionsList(theme),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(ThemeData theme) {
    return SliverAppBar.large(
      title: const Text('Turnover'),
      automaticallyImplyLeading: false,
      centerTitle: true,
      pinned: true,
      stretch: true,
      expandedHeight: 150,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDisplay(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 180,
            height: 180,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _totalAmount),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Paid',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      child: Text(
                        _currencyFormatter.format(value),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(ThemeData theme) {
    return SliverList.builder(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        final isLastItem = index == _transactions.length - 1;

        return Column(
          children: [
            Card(
              margin: EdgeInsets.fromLTRB(16, 8, 16, isLastItem ? 16 : 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () => _showTransactionDetails(transaction),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.payments_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dateFormatter.format(transaction.date),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currencyFormatter.format(transaction.amount),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'Transaction Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('Date', _dateFormatter.format(transaction.date)),
                    _buildDetailRow('Amount', _currencyFormatter.format(transaction.amount)),
                    // Add more transaction details as needed
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}