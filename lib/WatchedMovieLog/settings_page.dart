import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'database.dart';
import 'edit_database_page.dart';
import 'export_database_page.dart';

class SettingsPage extends StatefulWidget {
  final MovieDatabase database;

  const SettingsPage({
    Key? key,
    required this.database,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late PackageInfo packageInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Edit Database'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDatabasePage(
                            database: widget.database,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('Export Database'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExportDatabasePage(
                            database: widget.database,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('App Version'),
                    subtitle: Text(packageInfo.version),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('Build Number'),
                    subtitle: Text(packageInfo.buildNumber),
                  ),
                ),
              ],
            ),
    );
  }
}
