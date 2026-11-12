import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/reservation_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/validators.dart';
import '../../widgets/section_eyebrow.dart';

/// Reservations tab — lets a guest claim a table for a given date/time.
/// The booking is sent to the backend (same endpoint as the website form),
/// so it appears in Admin → Reservations. On success the form is swapped for
/// a confirmation view, matching the website's UX.
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
  bool _submitting = false;
  String? _error;

  /// What the API needs: "YYYY-MM-DD" and 24-hour "HH:mm". The text fields
  /// show friendlier versions ("Fri, 20 Nov 2026" / "7:30 PM").
  String? _isoDate;
  String? _time24;

  @override
  void initState() {
    super.initState();
    // Signed-in users don't have to retype their details. The saved sign-in
    // may still be restoring when this tab is built, so also fill in once
    // it arrives (only into fields the user hasn't typed in yet).
    _prefillFromUser();
    AuthService.instance.addListener(_prefillFromUser);
  }

  void _prefillFromUser() {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    if (_nameController.text.isEmpty) _nameController.text = user.name;
    if (_emailController.text.isEmpty) _emailController.text = user.email;
    if (_phoneController.text.isEmpty) _phoneController.text = user.phone ?? '';
  }

  @override
  void dispose() {
    AuthService.instance.removeListener(_prefillFromUser);
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
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      setState(() {
        _isoDate =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _dateController.text = '${days[picked.weekday - 1]}, ${picked.day} ${months[picked.month - 1]} ${picked.year}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null && mounted) {
      setState(() {
        _time24 = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _saveTable() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final error = await ReservationService.instance.book(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      date: _isoDate ?? '',
      time: _time24 ?? '',
      partySize: _partySize,
      requests: _notesController.text,
    );

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = error;
      _isSaved = error == null;
    });
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
      _error = null;
      _isoDate = null;
      _time24 = null;
      _prefillFromUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // Extra bottom space so the floating cart button never covers
        // the "Save My Table" button.
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 104),
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
      // Show/clear each field's error as the user edits it, not only on submit.
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Best number to reach you',
            ),
            validator: (v) => Validators.phone(v),
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
            maxLength: 500,
            decoration: const InputDecoration(
              labelText: 'Cravings, allergies, or a celebration we should know about?',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _saveTable,
              child: Text(_submitting ? 'Saving…' : 'Save My Table'),
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
