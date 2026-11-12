import 'package:flutter/material.dart';
import '../../services/business_service.dart';
import '../../data/menu_item.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../utils/validators.dart';
import '../auth/login_screen.dart';

/// A single row shown in the order summary at the top of checkout.
class CheckoutLine {
  final String name;
  final int quantity;
  final String priceLabel;

  const CheckoutLine({
    required this.name,
    required this.quantity,
    required this.priceLabel,
  });

  double get lineTotal => parsePrice(priceLabel) * quantity;
}

/// Real checkout: a delivery address/phone/notes form that places an order
/// for whatever line items are passed in — either a single dish+quantity
/// (from the dish detail screen) or the full tray (from [CartService]).
/// Placing the order requires an account — if the visitor isn't signed in,
/// this screen sends them to [LoginScreen] first, then returns here with
/// the items still queued up.
class CheckoutScreen extends StatefulWidget {
  /// `{menu_item_id: quantity}` sent to `OrderService.placeOrder`.
  final Map<int, int> items;

  /// What to show in the order summary card.
  final List<CheckoutLine> summaryLines;

  /// Called after the order is placed successfully (e.g. to clear the
  /// tray). Optional — the single-dish flow doesn't need it.
  final VoidCallback? onOrderPlaced;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.summaryLines,
    this.onOrderPlaced,
  });

  /// Checkout for a single dish + quantity, as picked on the dish detail
  /// screen.
  factory CheckoutScreen.singleItem({
    Key? key,
    required MenuItem item,
    required int quantity,
  }) {
    return CheckoutScreen(
      key: key,
      items: {item.id: quantity},
      summaryLines: [
        CheckoutLine(name: item.name, quantity: quantity, priceLabel: item.price),
      ],
    );
  }

  /// Checkout for everything currently in the tray.
  factory CheckoutScreen.fromCart({Key? key}) {
    final lines = CartService.instance.lines;
    return CheckoutScreen(
      key: key,
      items: CartService.instance.toOrderItems(),
      summaryLines: [
        for (final line in lines)
          CheckoutLine(
            name: line.item.name,
            quantity: line.quantity,
            priceLabel: line.item.price,
          ),
      ],
      onOrderPlaced: CartService.instance.clear,
    );
  }

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double get _subtotal => widget.summaryLines.fold<double>(0, (sum, l) => sum + l.lineTotal);
  double get _fee => BusinessService.instance.deliveryFee.toDouble();

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = AuthService.instance.currentUser?.phone ?? '';
  }

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
      items: widget.items,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = error;
      _success = error == null;
    });
    if (_success) widget.onOrderPlaced?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: _success ? _buildSuccess(context) : _buildForm(context),
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
            Icon(Icons.check_circle, color: AppColors.success, size: 56),
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
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              child: const Text('Back to Menu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in widget.summaryLines)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${line.quantity} × ${line.name}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          // Line total (2 × Rs. 700 = Rs. 1,400), not the unit price.
                          Text(
                            formatRs(line.lineTotal),
                            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  Divider(height: 20, color: AppColors.border),
                  _SummaryRow('Subtotal', formatRs(_subtotal)),
                  _SummaryRow('Delivery', _fee > 0 ? formatRs(_fee) : 'Free'),
                  _SummaryRow('Payment', 'Cash on delivery'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Total', style: TextStyle(color: AppColors.foregroundMuted)),
                      ),
                      Text(
                        formatRs(_subtotal + _fee),
                        style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ],
                  ),
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
                child: Text(_error!, style: TextStyle(color: AppColors.danger)),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              style: TextStyle(color: AppColors.foreground),
              decoration: const InputDecoration(labelText: 'Delivery Address *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Delivery address is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: AppColors.foreground),
              decoration: const InputDecoration(labelText: 'Phone *'),
              validator: (v) => Validators.phone(v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              style: TextStyle(color: AppColors.foreground),
              maxLength: 1000,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _ensureSignedInThenSubmit,
              child: _loading
                  ? SizedBox(
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: AppColors.foregroundMuted, fontSize: 13))),
          Text(value, style: TextStyle(color: AppColors.foreground, fontSize: 13)),
        ]),
      );
}
