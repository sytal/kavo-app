import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _loading = true;
  String? _error;
  List<CafeOrder> _orders = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final result = await OrderService.instance.myOrders();
    if (!mounted) return;
    setState(() {
      _orders = result.orders;
      _error = result.error;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Order History')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: _loading
              ? Center(child: CircularProgressIndicator(color: AppColors.gold))
              : _error != null
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.danger),
                          ),
                        ),
                      ],
                    )
                  : _orders.isEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                "You haven't placed any orders yet.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: _orders.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) => _OrderCard(order: _orders[index]),
                        ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CafeOrder order;
  const _OrderCard({required this.order});

  Color _statusColor() {
    switch (order.status) {
      case 'Completed':
        return AppColors.success;
      case 'Cancelled':
        return AppColors.danger;
      default:
        return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #${order.id}', style: Theme.of(context).textTheme.titleMedium),
                    if (order.createdAt != null)
                      Text(
                        formatDateTime(order.createdAt!),
                        style: TextStyle(color: AppColors.foregroundMuted, fontSize: 12),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor().withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor().withValues(alpha: 0.5)),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(color: _statusColor(), fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Divider(height: 20, color: AppColors.border),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity} × ${item.name}',
                      style: TextStyle(color: AppColors.foregroundMuted),
                    ),
                  ),
                  Text(
                    formatRs(item.price * item.quantity),
                    style: TextStyle(color: AppColors.foregroundMuted),
                  ),
                ],
              ),
            ),
          Divider(height: 20, color: AppColors.border),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: AppColors.foregroundMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.deliveryAddress,
                  style: TextStyle(color: AppColors.foregroundMuted, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: TextStyle(color: AppColors.foregroundMuted)),
              Text(
                formatRs(order.total),
                style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
