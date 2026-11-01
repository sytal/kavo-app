import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/section_eyebrow.dart';

/// Reservations tab — lets a guest claim a table for a given date/time.
/// Pure UI: no backend, no persistence. A successful "save" swaps the form
/// for a simple confirmation view, matching the sibling website's UX.
class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  int _partySize = 2;
  bool _isSaved = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _saveTable() {
    if (_formKey.currentState?.validate() != true) return;
    setState(() => _isSaved = true);
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _dateController.clear();
      _timeController.clear();
      _notesController.clear();
      _partySize = 2;
      _isSaved = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: _isSaved ? _ConfirmationView(
          name: _nameController.text,
          date: _dateController.text,
          time: _timeController.text,
          onBookAnother: _resetForm,
        ) : _buildForm(context),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionEyebrow('Save Your Seat'),
          const SizedBox(height: 10),
          Text('Reserve a Table', style: textTheme.displaySmall),
          const SizedBox(height: 10),
          Text(
            "Claim your table before the kitchen runs out of today's "
            'cravings. We hold reservations for fifteen minutes past the '
            'booked time.',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.foregroundMuted,
            ),
          ),
          const SizedBox(height: 28),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Who's joining the feast?",
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Where should we send confirmation?',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Best number to reach you',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _partySize,
            decoration: const InputDecoration(labelText: 'Party Size'),
            items: List.generate(10, (i) => i + 1)
                .map((n) => DropdownMenuItem(
                      value: n,
                      child: Text(n == 1 ? '1 guest' : '$n guests'),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _partySize = v);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: _pickDate,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.calendar_today_outlined),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _timeController,
            readOnly: true,
            onTap: _pickTime,
            decoration: const InputDecoration(
              labelText: 'Time',
              suffixIcon: Icon(Icons.access_time_rounded),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Cravings, allergies, or a celebration we should know about?',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveTable,
              child: const Text('Save My Table'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationView extends StatelessWidget {
  final String name;
  final String date;
  final String time;
  final VoidCallback onBookAnother;

  const _ConfirmationView({
    required this.name,
    required this.date,
    required this.time,
    required this.onBookAnother,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final who = name.trim().isEmpty ? 'you' : name.trim();
    final when = [date, time].where((s) => s.isNotEmpty).join(' at ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your Table Is Saved',
            style: textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            when.isEmpty
                ? "We'll see $who soon at Crunches Cafe."
                : "We'll see $who on $when. Faisalabad's favorite fast food hangout is ready for you.",
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.foregroundMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onBookAnother,
              child: const Text('Book Another Table'),
            ),
          ),
        ],
      ),
    );
  }
}
