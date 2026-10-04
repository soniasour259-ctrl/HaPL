import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HackSimApp());
}

// ─────────────────────────────────────────────
// الألوان
// ─────────────────────────────────────────────
class C {
  static const wall = Color(0xFF1B1A2E);
  static const floor = Color(0xFF2A2238);
  static const desk = Color(0xFF4A3426);
  static const kaliBg = Color(0xFF0E1117);
  static const kaliPanel = Color(0xFF161B26);
  static const kaliBlue = Color(0xFF367BF0);
  static const termBg = Color(0xFF05070A);
  static const green = Color(0xFF3DDC84);
  static const amber = Color(0xFFFFB02E);
  static const red = Color(0xFFFF4D4D);
  static const dim = Color(0xFF7D8590);
  static const text = Color(0xFFD7DEE7);
}

class HackSimApp extends StatelessWidget {
  const HackSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpSec Sim',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: C.kaliBg,
      ),
      // واجهة عربية (من اليمين لليسار)، والـ Terminal نفسه LTR
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const RoomScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// الشاشة الأولى: الغرفة
// ─────────────────────────────────────────────
class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  void _openPc() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const KaliScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.wall,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final floorH = box.maxHeight * 0.30;
          return Stack(
            children: [
              // الأرضية
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: floorH,
                child: Container(color: C.floor),
              ),
              // النص العلوي
              const Positioned(
                top: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('غرفتي',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: C.text)),
                    SizedBox(height: 6),
                    Text('الساعة 2:14 فجرًا. الكل نائم، والجيب فاضي.',
                        style: TextStyle(fontSize: 14, color: C.dim)),
                  ],
                ),
              ),
              // الشباك
              Positioned(
                top: 110,
                left: 28,
                width: 100,
                height: 130,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0B1330), Color(0xFF1C2A5A)],
                    ),
                    border: Border.all(color: const Color(0xFF3B3560), width: 4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Align(
                    alignment: Alignment(0.5, -0.6),
                    child: Icon(Icons.nightlight_round,
                        color: Color(0xFFF3E9B5), size: 30),
                  ),
                ),
              ),
              // السرير
              Positioned(
                right: 16,
                bottom: floorH - 24,
                width: 130,
                height: 74,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3F6B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 34,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD2E8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              // المكتب + الكمبيوتر
              Positioned(
                left: 16,
                bottom: floorH - 20,
                width: 172,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _openPc,
                      child: AnimatedBuilder(
                        animation: _glow,
                        builder: (context, _) {
                          final g = 8 + 18 * _glow.value;
                          return Container(
                            width: 128,
                            height: 86,
                            decoration: BoxDecoration(
                              color: C.termBg,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: const Color(0xFF2B3140), width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: C.kaliBlue.withOpacity(0.55),
                                  blurRadius: g,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.terminal,
                                      color: C.kaliBlue, size: 30),
                                  SizedBox(height: 4),
                                  Text('Kali Linux',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: C.text,
                                          fontSize: 12,
                                          fontFamily: 'monospace')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(width: 14, height: 10, color: const Color(0xFF2B3140)),
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: C.desk,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 10, height: 52, color: C.desk),
                        Container(width: 10, height: 52, color: C.desk),
                      ],
                    ),
                  ],
                ),
              ),
              // زر التشغيل
              Positioned(
                left: 24,
                right: 24,
                bottom: 28,
                child: FilledButton.icon(
                  onPressed: _openPc,
                  style: FilledButton.styleFrom(
                    backgroundColor: C.kaliBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('شغّل الكمبيوتر',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// الشاشة الثانية: Kali Linux + Terminal
// ─────────────────────────────────────────────
class _Line {
  final String text;
  final Color color;
  const _Line(this.text, this.color);
}

class KaliScreen extends StatefulWidget {
  const KaliScreen({super.key});

  @override
  State<KaliScreen> createState() => _KaliScreenState();
}

class _KaliScreenState extends State<KaliScreen> {
  final TextEditingController _input = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scroll = ScrollController();
  final List<_Line> _lines = [];

  double _trace = 0; // 0 → 100
  int _money = 0;
  bool _scanned = false; // هل تم الفحص؟
  bool _logsCleared = true; // هل السجلات نظيفة؟
  bool _missionDone = false;
  bool _busy = false;
  bool _ended = false;

  @override
  void initState() {
    super.initState();
    _lines.addAll(const [
      _Line('Kali GNU/Linux Rolling (used laptop, 4GB RAM)', C.text),
      _Line('Target: small online shop with a wallet system.', C.dim),
      _Line("Type 'help' to see available commands.", C.dim),
    ]);
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ── مساعدات الطباعة ──
  void _add(String text, [Color color = C.text]) {
    if (!mounted) return;
    setState(() => _lines.add(_Line(text, color)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _print(String text,
      [Color color = C.text, int ms = 380]) async {
    await Future.delayed(Duration(milliseconds: ms));
    _add(text, color);
  }

  void _setTrace(double v) {
    if (!mounted) return;
    setState(() => _trace = v.clamp(0, 100).toDouble());
  }

  // ── تنفيذ الأوامر ──
  Future<void> _run(String raw) async {
    final cmd = raw.trim().toLowerCase();
    if (cmd.isEmpty || _busy || _ended) return;
    _input.clear();
    setState(() => _busy = true);
    _add('root@kali:~# $raw', C.green);

    switch (cmd) {
      case 'help':
        await _help();
        break;
      case 'scan':
        await _scan();
        break;
      case 'exploit':
        await _exploit();
        break;
      case 'clear_logs':
        await _clearLogs();
        break;
      case 'exit':
        if (mounted) Navigator.of(context).pop();
        return;
      default:
        _add('bash: $cmd: command not found', C.red);
    }

    if (!mounted) return;
    setState(() => _busy = false);
    _focus.requestFocus();
  }

  Future<void> _help() async {
    _add('Available commands:', C.text);
    _add('  scan        scan the target website for weaknesses', C.dim);
    _add('  exploit     try to use the weakness found by scan', C.dim);
    _add('  clear_logs  wipe your traces from the server logs', C.dim);
    _add('  exit        shut down the computer', C.dim);
  }

  Future<void> _scan() async {
    if (_missionDone) {
      _add('[i] Target is already drained. Nothing left here.', C.dim);
      return;
    }
    await _print('[*] Scanning shop-demo.local (192.168.1.50) ...', C.text);
    await _print('[*] Enumerating endpoints', C.dim);
    await _print('[+] /login    200 OK', C.green);
    await _print('[+] /search   200 OK', C.green);
    await _print('[+] /wallet   200 OK', C.green, 300);
    await _print('[!] VULNERABILITY FOUND: SQL Injection', C.amber, 600);
    await _print('[!] Location: /search?q=  (input is not sanitized)', C.amber);
    await _print('[!] Severity: HIGH', C.amber, 250);
    await _print('[i] The server logged your IP during the scan. (+25% trace)',
        C.red, 500);

    _scanned = true;
    _logsCleared = false;
    _setTrace(_trace + 25);
    if (_trace >= 100) await _gameOver('كثرة الفحص تركت أثرًا كبيرًا في السجلات.');
  }

  Future<void> _clearLogs() async {
    if (_logsCleared) {
      _add('[i] Logs are already clean.', C.dim);
      return;
    }
    await _print('[*] Connecting to log service ...', C.text);
    await _print('[*] Removing entries that match your IP', C.dim, 500);
    await _print('[*] Rewriting access.log  ... done', C.dim, 500);
    await _print('[+] Logs cleaned. Trace level reduced.', C.green, 400);
    _logsCleared = true;
    _setTrace(5);
  }

  Future<void> _exploit() async {
    if (_missionDone) {
      _add('[i] Target is already drained. Nothing left here.', C.dim);
      return;
    }
    if (!_scanned) {
      _add('[x] No target selected. Run scan first.', C.red);
      return;
    }

    await _print('[*] Preparing exploit for /search ...', C.text);
    await _print('[*] Sending request to target', C.dim, 500);

    if (!_logsCleared) {
      // أخطأ اللاعب: لم يمسح السجلات
      await _print('[!] Request matched your IP already stored in logs!', C.red, 450);
      await _print('[!] ALERT: admin notified', C.red, 300);
      _setTrace(100);
      await _gameOver('نفّذت الاستغلال قبل ما تمسح السجلات.');
      return;
    }

    await _print('[+] Access granted to wallet table', C.green, 600);
    await _print('[*] Moving funds to your account ...', C.dim, 600);
    await _print('[+] Transferred: \$350', C.green, 600);

    _missionDone = true;
    if (!mounted) return;
    setState(() => _money += 350);
    _add("[i] Mission complete. Type 'exit' to leave the computer.", C.amber);
    await _showSuccess();
  }

  Future<void> _gameOver(String reason) async {
    if (_ended) return;
    _ended = true;
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => GameOverScreen(reason: reason)),
    );
  }

  Future<void> _showSuccess() async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: C.kaliPanel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('نجحت المهمة الأولى'),
        content: const Text(
            'سحبت 350\$ ولا أحد لاحظ شي. نظّفت السجلات في الوقت المناسب.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('متابعة'),
          ),
        ],
      ),
    );
  }

  // ── الواجهة ──
  Color _traceColor(double t) => t < 50
      ? Color.lerp(C.green, C.amber, t / 50)!
      : Color.lerp(C.amber, C.red, (t - 50) / 50)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.kaliBg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _traceBar(),
            Expanded(child: _terminal()),
            _quickCommands(),
            _inputRow(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      color: C.kaliPanel,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.shield_moon, color: C.kaliBlue, size: 22),
          const SizedBox(width: 8),
          const Text('Kali Linux',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontWeight: FontWeight.w700, color: C.text)),
          const Spacer(),
          Text('رصيدك: \$$_money',
              style: const TextStyle(color: C.green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _traceBar() {
    final color = _traceColor(_trace);
    return Container(
      color: C.kaliPanel,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              const Text('مستوى الأثر',
                  style: TextStyle(color: C.dim, fontSize: 13)),
              const Spacer(),
              Text('${_trace.toStringAsFixed(0)}%',
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _trace / 100),
              duration: const Duration(milliseconds: 450),
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 10,
                backgroundColor: const Color(0xFF232A38),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _terminal() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      decoration: BoxDecoration(
        color: C.termBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF232A38)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF11151D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Row(
              textDirection: TextDirection.ltr,
              children: [
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFF5F56)),
                SizedBox(width: 6),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFFFFBD2E)),
                SizedBox(width: 6),
                CircleAvatar(radius: 5, backgroundColor: Color(0xFF27C93F)),
                SizedBox(width: 12),
                Text('Terminal - root@kali: ~',
                    style: TextStyle(
                        color: C.dim, fontSize: 12, fontFamily: 'monospace')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: _lines.length,
              itemBuilder: (context, i) {
                final l = _lines[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l.text,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: l.color,
                        fontSize: 13,
                        height: 1.35,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCommands() {
    const cmds = ['help', 'scan', 'exploit', 'clear_logs', 'exit'];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: cmds.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ActionChip(
          backgroundColor: C.kaliPanel,
          side: const BorderSide(color: Color(0xFF2B3140)),
          label: Text(cmds[i],
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                  color: C.text, fontFamily: 'monospace', fontSize: 13)),
          onPressed: () => _run(cmds[i]),
        ),
      ),
    );
  }

  Widget _inputRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 4, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: C.termBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF232A38)),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          const Text('root@kali:~# ',
              style: TextStyle(
                  color: C.green, fontFamily: 'monospace', fontSize: 13)),
          Expanded(
            child: TextField(
              controller: _input,
              focusNode: _focus,
              textDirection: TextDirection.ltr,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.send,
              onSubmitted: _run,
              cursorColor: C.green,
              style: const TextStyle(
                  color: C.text, fontFamily: 'monospace', fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'type a command',
                hintStyle: TextStyle(color: C.dim, fontSize: 13),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: C.kaliBlue, size: 20),
            onPressed: () => _run(_input.text),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// شاشة النهاية: تم كشفك
// ─────────────────────────────────────────────
class GameOverScreen extends StatelessWidget {
  final String reason;
  const GameOverScreen({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120506),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('100%',
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      color: C.red,
                      fontFamily: 'monospace')),
              const SizedBox(height: 8),
              const Text('تم كشفك. انتهت اللعبة.',
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w700, color: C.text)),
              const SizedBox(height: 14),
              Text(reason,
                  style: const TextStyle(fontSize: 16, color: C.dim, height: 1.5)),
              const SizedBox(height: 6),
              const Text('الدرس: امسح أثرك قبل ما تتحرك.',
                  style: TextStyle(fontSize: 16, color: C.dim, height: 1.5)),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const RoomScreen()),
                    (route) => false,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: C.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('حاول مرة ثانية',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
