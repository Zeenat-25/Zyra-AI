import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/core/utils/validators.dart';
import 'package:zyra/core/widgets/common/app_button.dart';
import 'package:zyra/core/widgets/common/app_text_field.dart';
import 'package:zyra/features/contacts/domain/entities/contact.dart';
import 'package:zyra/features/contacts/presentation/providers/contacts_provider.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _relationshipController = TextEditingController();
  bool _isEmergency = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final userId = ModalRoute.of(context)?.settings.arguments as int?;
    if (userId == null) return;

    final contact = Contact(
      userId: userId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      relationship: _relationshipController.text.trim().isEmpty
          ? null
          : _relationshipController.text.trim(),
      isEmergencyContact: _isEmergency,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<ContactsProvider>().addContact(contact);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _nameController,
                hintText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outlined),
                validator: Validators.name,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: Validators.phone,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                hintText: 'Email (optional)',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _relationshipController,
                hintText: 'Relationship (optional)',
                prefixIcon: const Icon(Icons.favorite_outline),
              ),
              const SizedBox(height: 24),
              Card(
                child: SwitchListTile(
                  title: const Text('Emergency Contact'),
                  subtitle: const Text(
                    'This contact will be notified during SOS alerts',
                  ),
                  value: _isEmergency,
                  onChanged: (value) => setState(() => _isEmergency = value),
                  activeColor: AppTheme.sosRed,
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Save Contact',
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
