import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SahedApp());
}

class SahedApp extends StatelessWidget {
  const SahedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ── Splash Screen ──────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      _requestPermissionsAndNavigate();
    });
  }

  Future<void> _requestPermissionsAndNavigate() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DialerScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1A3A5C),
              Color(0xFF0D1B2A),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A73E8), Color(0xFF00C2FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A73E8).withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone_in_talk_rounded,
                      size: 55,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Sahed',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'VoIP Dialer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF90CAF9),
                      letterSpacing: 4,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFF00C2FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dialer Screen ──────────────────────────────────────────────
class DialerScreen extends StatefulWidget {
  const DialerScreen({super.key});

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _hasError = false;

  static const String _url = 'https://amarip.net/#dialer';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0D1B2A))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() {
            _isLoading = false;
            _hasError = true;
          }),
          onPermissionRequest: (request) => request.grant(),
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _webViewController.loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1B2A), Color(0xFF1A3A5C)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x441A73E8),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A73E8), Color(0xFF00C2FF)],
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Sahed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF00C2FF),
                      ),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xFF90CAF9)),
                  onPressed: _reload,
                  tooltip: 'Reload',
                ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_hasError)
            _buildErrorWidget()
          else
            WebViewWidget(controller: _webViewController),
          if (_isLoading && !_hasError)
            Container(
              color: const Color(0xFF0D1B2A),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF1A73E8),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Connecting...',
                      style: TextStyle(
                        color: Color(0xFF90CAF9),
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFF0D1B2A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Color(0xFF1A73E8),
            ),
            const SizedBox(height: 20),
            const Text(
              'সংযোগ ব্যর্থ হয়েছে',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ইন্টারনেট সংযোগ চেক করুন',
              style: TextStyle(color: Color(0xFF90CAF9), fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('আবার চেষ্টা করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
