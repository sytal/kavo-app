import 'package:flutter/material.dart';
import '../../data/menu_item.dart';
import '../../services/auth_service.dart';
import '../../services/order_service.dart';
import '../../theme/app_colors.dart';
import '../auth/login_screen.dart';

/// Minimal real checkout: one dish + quantity (passed in from the dish
/// detail screen) plus the required delivery address/phone. Placing the
/// order requires an account — if the visitor isn't signed in, this screen
/// sends them to [LoginScreen] first, then returns here with the dish
/// still queued up.
class CheckoutScreen extends StatefulWidget {
  final MenuItem item;
  final int quantity;

  const CheckoutScreen({super.key, required this.item, required this.quantity});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _ensureSignedInThenSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!AuthService.instance.isAuthenticated) {
      final signedIn = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (signedIn != true || !mounted) return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final error = await OrderService.instance.placeOrder(
      deliveryAddress: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      items: {widget.item.id: widget.quantity},
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
      _success = error == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: _success ? _buildSuccess(context) : _buildForm(context, item),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 56),
            const SizedBox(height: 16),
            Text('Order placed!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'We will start preparing it shortly.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MenuItem item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.quantity} × ${item.name}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(item.price, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.danger)),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              style: const TextStyle(color: AppColors.foreground),
              decoration: const InputDecoration(labelText: 'Delivery Address *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Delivery address is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.foreground),
              decoration: const InputDecoration(labelText: 'Phone *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              style: const TextStyle(color: AppColors.foreground),
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _ensureSignedInThenSubmit,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.background),
                    )
                  : const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
