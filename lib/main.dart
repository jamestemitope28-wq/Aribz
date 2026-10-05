import 'package:flutter/material.dart';

void main() => runApp(const AribzApp());

class AribzApp extends StatelessWidget {
  const AribzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARIBZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4A8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AribzHome(),
    );
  }
}

class AribzHome extends StatefulWidget {
  const AribzHome({super.key});

  @override
  State<AribzHome> createState() => _AribzHomeState();
}

class _AribzHomeState extends State<AribzHome> {
  int tab = 0;
  bool botOn = false;

  final pages = const [
    DashboardPage(),
    SignalsPage(),
    TradesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ARIBZ',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2)),
        actions: [
          IconButton(
            tooltip: 'Bot status',
            onPressed: () => setState(() => botOn = !botOn),
            icon: Icon(
              botOn ? Icons.smart_toy : Icons.smart_toy_outlined,
              color: botOn ? const Color(0xFF00D4A8) : Colors.white70,
            ),
          ),
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bolt_outlined), selectedIcon: Icon(Icons.bolt), label: 'Signals'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Trades'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget card(String title, String value, IconData icon, {Color? color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: (color ?? const Color(0xFF00D4A8)).withOpacity(.14),
              child: Icon(icon, color: color ?? const Color(0xFF00D4A8)),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 5),
                Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Good trading starts with discipline.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        const Text('ARIBZ • XAUUSD Sniper Engine',
            style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Colors.orange, size: 12),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Bot is OFF',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Configure'),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        card('Account Balance', '\$20.00', Icons.account_balance_wallet_outlined),
        card('Today P/L', '\$0.00', Icons.trending_up),
        card('Risk / Trade', '1.0%', Icons.shield_outlined),
        const SizedBox(height: 12),
        const Text('Market', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Text('X')),
            title: const Text('XAUUSD'),
            subtitle: const Text('Gold • M5'),
            trailing: const Text('--',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class SignalsPage extends StatelessWidget {
  const SignalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Sniper Signals',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Liquidity + S/R + CHOCH confirmation',
            style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(children: [
                  Icon(Icons.hourglass_empty, color: Colors.amber),
                  SizedBox(width: 10),
                  Text('WAITING FOR SETUP',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: 14),
                Text('XAUUSD • M5'),
                SizedBox(height: 8),
                Text('No confirmed CHOCH yet.',
                    style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TradesPage extends StatelessWidget {
  const TradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Trade History',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('No trades yet'),
            subtitle: Text('Connected trades will appear here.'),
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double risk = 1.0;
  bool autoTrade = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Bot Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Auto Trading'),
                subtitle: const Text('Allow ARIBZ to execute confirmed setups'),
                value: autoTrade,
                onChanged: (v) => setState(() => autoTrade = v),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Risk per trade'),
                subtitle: Text('${risk.toStringAsFixed(1)}%'),
              ),
              Slider(
                value: risk,
                min: .5,
                max: 3,
                divisions: 5,
                label: '${risk.toStringAsFixed(1)}%',
                onChanged: (v) => setState(() => risk = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Push Notifications'),
                value: notifications,
                onChanged: (v) => setState(() => notifications = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Safety'),
            subtitle: const Text('Daily loss and drawdown protection will be added to the trading engine.'),
          ),
        ),
      ],
    );
  }
}
