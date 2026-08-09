import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zyra/core/theme/app_theme.dart';
import 'package:zyra/core/utils/responsive_utils.dart';
import 'package:zyra/features/auth/presentation/providers/auth_provider.dart';
import 'package:zyra/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:zyra/routes/app_router.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUser?.id != null) {
        context.read<ContactsProvider>().loadContacts(auth.currentUser!.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactsProvider = context.watch<ContactsProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (auth.currentUser?.id != null) {
            Navigator.pushNamed(
              context,
              AppRouter.addContact,
              arguments: auth.currentUser!.id,
            );
          }
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: contactsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : contactsProvider.contacts.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    if (auth.currentUser?.id != null) {
                      await contactsProvider.loadContacts(auth.currentUser!.id!);
                    }
                  },
                  child: ListView(
                    padding: ResponsiveUtils.screenPadding(context),
                    children: [
                      if (contactsProvider.emergencyContacts.isNotEmpty) ...[
                        _buildSectionHeader('Emergency Contacts'),
                        ...contactsProvider.emergencyContacts.map(_buildContactCard),
                        const SizedBox(height: 16),
                      ],
                      final nonEmergency = contactsProvider.contacts
                          .where((c) => !c.isEmergencyContact)
                          .toList();
                      if (nonEmergency.isNotEmpty) ...[
                        _buildSectionHeader('Other Contacts'),
                        ...nonEmergency.map(_buildContactCard),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Emergency Contacts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add contacts who will be notified\nin case of an emergency',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Text(
            contact.name[0].toUpperCase(),
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.phone),
            if (contact.relationship != null)
              Text(
                contact.relationship!,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'toggle_emergency') {
              contactsProvider.toggleEmergencyStatus(contact);
            } else if (value == 'delete') {
              _confirmDelete(contact);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle_emergency',
              child: Text(
                contact.isEmergencyContact
                    ? 'Remove from Emergency'
                    : 'Mark as Emergency',
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: AppTheme.sosRed)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Remove ${contact.name} from your contacts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              contactsProvider.deleteContact(
                contact.id!,
                contact.userId,
              );
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppTheme.sosRed)),
          ),
        ],
      ),
    );
  }
}
