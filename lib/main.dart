import 'package:flutter/material.dart';
import 'global_variables.dart';
import 'fragment_webview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PML 13',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5FD4C3),
          primary: const Color(0xFF5E54C7),
        ),
        useMaterial3: true,
      ),
      home: const MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  int _selectedIndex = 0;
  bool _isWebViewVisible = false;
  GlobalKey<FragmentWebViewState> _fragmentKey = GlobalKey<FragmentWebViewState>();

  /// URL targets matching requirements
  static const String _urlYoutube = "https://www.youtube.com";
  static const String _urlTiktok = "https://www.tiktok.com";

  // Link Instagram untuk Send Message
  static const String _urlMessage = "https://www.instagram.com";

  // Google Maps: Lokasi PSDKU Politeknik Negeri Malang di Kota Kediri (tetap di webview)
  static const String _urlLocation =
      "https://www.google.com/maps/place/PSDKU+Politeknik+Negeri+Malang+di+Kota+Kediri/@-7.8025621,111.9772606,17z/data=!3m1!4b1!4m6!3m5!1s0x2e7856c8ee550497:0x3f8ff2e0bc9b9718!8m2!3d-7.8025674!4d111.9798355!16s%2Fg%2F11c6f2rz1c?entry=ttu";

  // Profil Polinema (Website resmi Polinema yang aktif)
  static const String _urlProfile =
      "https://www.polinema.ac.id/profil/sejarah-singkat/";
  static const String _urlShop = "https://www.shopee.co.id";

  /// Replaces the current fragment with a new WebView showing [url],
  /// matching replaceFragment(url: String) from Kotlin.
  void replaceFragment(String url) {
    GlobalVariables.url = url;
    setState(() {
      _fragmentKey = GlobalKey<FragmentWebViewState>();
      _isWebViewVisible = true;
    });
  }

  /// Handles BottomNavigationBar selection matching onNavigationItemSelected
  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0: // itemHome
        setState(() {
          _isWebViewVisible = false;
        });
        break;
      case 1: // itemLoc
        replaceFragment(_urlLocation);
        break;
      case 2: // itemShop
        replaceFragment(_urlShop);
        break;
      case 3: // itemProfil
        replaceFragment(_urlProfile);
        break;
    }
  }

  /// Handles Back button matching onKeyDown from Kotlin
  Future<void> _handlePop() async {
    if (_isWebViewVisible) {
      final webState = _fragmentKey.currentState;
      if (webState != null && await webState.canGoBack()) {
        await webState.goBack();
      } else {
        setState(() {
          _isWebViewVisible = false;
          _selectedIndex = 0; // Return to Home
        });
      }
    }
  }

  Widget _buildHomeButtons() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Button TikTok
          SizedBox(
            width: 150,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E54C7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              onPressed: () => replaceFragment(_urlTiktok),
              child: const Text(
                'Tiktok',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Button YouTube
          SizedBox(
            width: 150,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E54C7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              onPressed: () => replaceFragment(_urlYoutube),
              child: const Text(
                'Youtube',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Button Send Message
          SizedBox(
            width: 150,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E54C7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
              ),
              onPressed: () => replaceFragment(_urlMessage),
              child: const Text(
                'Send Message',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isWebViewVisible,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handlePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        appBar: AppBar(
          title: const Text(
            'PML 13',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black26,
        ),
        body: Stack(
          children: [
            // Home buttons view (always underneath)
            _buildHomeButtons(),

            // WebView view (FrameLayout equivalent)
            if (_isWebViewVisible)
              Positioned.fill(
                child: FragmentWebView(
                  key: _fragmentKey,
                ),
              ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF5FD4C3),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF5FD4C3),
            selectedItemColor: const Color(0xFF105B50),
            unselectedItemColor: const Color(0xFF105B50),
            currentIndex: _selectedIndex,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            onTap: _onNavigationItemSelected,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'Lokasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
