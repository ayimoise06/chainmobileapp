import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import 'dart:typed_data';
import 'services/web3_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chain Cacao',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFC67A3F),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Fond très sombre
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC67A3F),
          secondary: Color(0xFF864415),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ==========================================
// 0. ECRAN D'ACCUEIL (ONBOARDING)
// ==========================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808), // Fond noir du design
      body: Stack(
        children: [
          // Background Rings Custom Paint (Effet d'ondes elliptiques)
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundRingsPainter(),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top logo text
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'CHAIN CACAO',
                      style: TextStyle(
                        color: Color(0xFFC67A3F),
                        fontSize: 16,
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Corps de la page
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'BIENVENUE',
                          style: TextStyle(
                            color: Color(0xFFC67A3F),
                            fontSize: 12,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "L'art du cacao\nparfait",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Découvrez l'excellence du cacao tracé, de la fève à l'exportation via la puissance de la Blockchain.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        // Bouton d'action principal
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB56A35), Color(0xFF864415)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC67A3F).withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Commencer ici',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Badges en bas
                        _buildBadge(Icons.shield_outlined, "Traçabilité totale"),
                        const SizedBox(height: 12),
                        _buildBadge(Icons.link, "Blockchain sécurisée"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFC67A3F), size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Dessine les cercles elliptiques en fond
class BackgroundRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC67A3F).withOpacity(0.03) // Très subtil
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Dessine plusieurs ellipses concentriques
    for (int i = 1; i <= 6; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center, 
          width: 140.0 * i, 
          height: 280.0 * i,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// 1. ECRAN CHOIX DE ROLE
// ==========================================
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CHAIN CACAO',
                      style: TextStyle(
                        color: Color(0xFFC67A3F),
                        fontSize: 16,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(Icons.help_outline, color: Colors.white54, size: 24),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Logo CC
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                      color: const Color(0xFF1A1A1A),
                    ),
                    child: const Center(
                      child: Text(
                        'CC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Titles
                const Text(
                  'Bienvenue sur Chain Cacao',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Souhaitez-vous vous inscrire en tant que...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 32),
                
                // Role Cards
                _buildRoleCard(
                  id: 'agriculteur',
                  title: 'Agriculteur',
                  subtitle: 'Producteur de fèves',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildRoleCard(
                  id: 'cooperative',
                  title: 'Coopérative',
                  subtitle: 'Union locale',
                  icon: Icons.groups_outlined,
                ),
                const SizedBox(height: 12),
                _buildRoleCard(
                  id: 'regulateur',
                  title: 'Régulateur',
                  subtitle: 'Certification',
                  icon: Icons.gavel_outlined,
                ),
                const SizedBox(height: 12),
                _buildRoleCard(
                  id: 'exportateur',
                  title: 'Exportateur',
                  subtitle: 'Marché inter.',
                  icon: Icons.local_shipping_outlined,
                ),
                
                const SizedBox(height: 24),
                
                // Banner Image
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/cocoa_pod.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRAÇABILITÉ TOTALE',
                        style: TextStyle(
                          color: Color(0xFFC67A3F),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "De la fève à l'exportation via Blockchain.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _selectedRole != null
                      ? () {
                          // Navigate to next step
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC67A3F),
                    disabledBackgroundColor: const Color(0xFFC67A3F).withOpacity(0.3),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white54,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Continuer', style: TextStyle(fontSize: 16)),
                ),
                
                const SizedBox(height: 16),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ? ', style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Quit Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.white54, size: 16),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "QUITTER L'APPLICATION",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFC67A3F) : Colors.white10,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFC67A3F),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1.5. ECRAN D'INSCRIPTION
// ==========================================
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscurePassword = true;
  String _selectedRole = "Agriculteur"; // Default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/cocoa_beans_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Header
                  const Center(
                    child: Text(
                      'CHAIN CACAO',
                      style: TextStyle(
                        color: Color(0xFFC67A3F),
                        fontSize: 16,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'Inscription',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Rejoignez l'écosystème du cacao de spécialité.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Form Container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputField(
                          label: 'Nom',
                          hint: 'Doe',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: 'Prénom',
                          hint: 'John',
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: 'Numéro de téléphone',
                          hint: '+33 6 12 34 56 78',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: 'Mot de passe',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Role Selector for Registration
                        const Text(
                          "S'INSCRIRE EN TANT QUE",
                          style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildRoleOption("Agriculteur", Icons.eco_outlined, _selectedRole == "Agriculteur"),
                            const SizedBox(width: 12),
                            _buildRoleOption("Coopérative", Icons.business_outlined, _selectedRole == "Coopérative"),
                            const SizedBox(width: 12),
                            _buildRoleOption("Exportateur", Icons.local_shipping_outlined, _selectedRole == "Exportateur"),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Submit Button
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedRole == "Agriculteur") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainScreen()),
                              );
                            } else if (_selectedRole == "Coopérative") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const CooperativeMainScreen()),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const ExporterMainScreen()),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC67A3F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("S'inscrire", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Déjà un compte ? ', style: TextStyle(color: Colors.white54)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            obscureText: isPassword && _obscurePassword,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: icon != null 
                  ? Icon(icon, color: Colors.white30, size: 20) 
                  : null,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white30,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption(String role, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC67A3F).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFC67A3F) : Colors.white10,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFC67A3F) : Colors.white38, size: 20),
              const SizedBox(height: 8),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1.8. ECRAN DE CONNEXION
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: "kouassi@cacao.tg");
  final TextEditingController _passController = TextEditingController(text: "password123");
  bool _obscurePassword = true;
  String _selectedRole = "Agriculteur";

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC67A3F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Connexion',
          style: TextStyle(
            color: Color(0xFFC67A3F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                
                // Logo CC
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'CC',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Titles
                const Text(
                  'Chain Cacao',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ravis de vous revoir.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 48),
                
                // Form Fields
                _buildInputField(
                  label: 'IDENTIFIANT',
                  hint: "Email ou Nom d'utilisateur",
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  label: 'MOT DE PASSE',
                  hint: '••••••••',
                  isPassword: true,
                ),
                
                const SizedBox(height: 16),
                
                // Role Selector
                const Text(
                  'SE CONNECTER EN TANT QUE',
                  style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildRoleOption("Agriculteur", Icons.eco_outlined, _selectedRole == "Agriculteur"),
                    const SizedBox(width: 12),
                    _buildRoleOption("Coopérative", Icons.business_outlined, _selectedRole == "Coopérative"),
                    const SizedBox(width: 12),
                    _buildRoleOption("Exportateur", Icons.local_shipping_outlined, _selectedRole == "Exportateur"),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        color: Color(0xFFC67A3F),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Farmer Dashboard
                    if (_selectedRole == "Agriculteur") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    } else if (_selectedRole == "Coopérative") {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const CooperativeMainScreen()),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ExporterMainScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC67A3F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28), // Pill shape
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Se connecter', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pas encore de compte ? ', style: TextStyle(color: Colors.white54)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                        );
                      },
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role, IconData icon, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC67A3F).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFC67A3F) : Colors.white10,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? const Color(0xFFC67A3F) : Colors.white38, size: 20),
              const SizedBox(height: 8),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: TextField(
            obscureText: isPassword && _obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.white30,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 1.9. ECRAN ACCUEIL AGRICULTEUR
// ==========================================
class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  String _selectedCrop = "Café";
  final TextEditingController _quantityController = TextEditingController(text: "0.00");
  final TextEditingController _obsController = TextEditingController();
  int _currentIndex = 1;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();
  final Web3Service _web3Service = Web3Service();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Récolté', '1,250 kg', Icons.auto_graph, const Color(0xFFC67A3F))),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Gains (EST.)', '0.84 ETH', Icons.account_balance_wallet, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipCard(),
            const SizedBox(height: 24),
            
            // Weather and Cooperative Row
            Row(
              children: [
                Expanded(child: _buildWeatherCard()),
                const SizedBox(width: 12),
                Expanded(child: _buildCoopCard()),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildRecentLotsSection(),
            const SizedBox(height: 40),

            const Text(
              'Enregistrer un lot de\nculture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Documentez l\'état de votre parcelle en temps réel.',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Photo Area
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(color: Colors.white10),
                  image: _imageBytes != null
                      ? DecorationImage(
                          image: MemoryImage(_imageBytes!),
                          fit: BoxFit.cover,
                        )
                      : const DecorationImage(
                          image: AssetImage('assets/images/cocoa_field.png'),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _imageBytes != null ? Colors.transparent : Colors.black38,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC67A3F),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _imageBytes != null ? Icons.check : Icons.camera_alt, 
                          color: Colors.white, 
                          size: 28
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _imageBytes != null ? 'Photo capturée !' : 'Prendre une photo du lot',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // GPS Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Color(0xFFC67A3F), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Localisation GPS',
                            style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.refresh, color: Color(0xFFC67A3F), size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Actualiser',
                              style: TextStyle(color: Color(0xFFC67A3F), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Atakpamé',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 8),
                      SizedBox(width: 8),
                      Text(
                        'Signal fort (Précision 3m)',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Type de culture',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCropCard('Café', Icons.coffee_outlined),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCropCard('Cacao', Icons.eco_outlined),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'Quantité produite',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _quantityController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                        hintStyle: TextStyle(color: Colors.white24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('kg', style: TextStyle(color: Colors.white)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'Observations',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _obsController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Notes sur la santé des feuilles, l\'irrigation...',
                  hintStyle: TextStyle(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB56A35), Color(0xFF864415)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  final batchData = {
                    "id": "#TRC-8829",
                    "type": _selectedCrop,
                    "weight": "${_quantityController.text}kg",
                    "origin": "TOGO",
                    "producer": "Kouassi",
                    "timestamp": DateTime.now().toIso8601String(),
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BatchConfirmationScreen(batchData: batchData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'VALIDER ET GÉNÉRER LE QR CODE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100), // Bottom padding for FAB/Nav
          ],
        ),
      );
  }

  Widget _buildCropCard(String title, IconData icon) {
    final isSelected = _selectedCrop == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCrop = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFC67A3F) : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Icon(icon, color: isSelected ? const Color(0xFFC67A3F) : Colors.white54),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Positioned(
                top: -8,
                right: 8,
                child: Icon(Icons.check_circle, color: Color(0xFFC67A3F), size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFC67A3F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFC67A3F), size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              Icon(icon, color: Colors.white38, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFC67A3F).withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC67A3F).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFC67A3F).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: Color(0xFFC67A3F), size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conseil du jour',
                  style: TextStyle(color: Color(0xFFC67A3F), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'L\'irrigation matinale réduit le risque de moisissure sur les cabosses.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.wb_sunny_outlined, color: Colors.orangeAccent, size: 24),
              Text('28°C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          SizedBox(height: 12),
          Text('MÉTÉO', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Ensoleillé', style: TextStyle(color: Colors.white70, fontSize: 13)),
          SizedBox(height: 2),
          Text('Humidité: 65%', style: TextStyle(color: Colors.white24, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCoopCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.business_outlined, color: Color(0xFFC67A3F), size: 24),
              Icon(Icons.verified, color: Colors.blue, size: 16),
            ],
          ),
          SizedBox(height: 12),
          Text('COOPÉRATIVE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('San José Ltd.', style: TextStyle(color: Colors.white70, fontSize: 13, overflow: TextOverflow.ellipsis)),
          SizedBox(height: 2),
          Text('Atakpamé, TG', style: TextStyle(color: Colors.white24, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildRecentLotsSection() {
    final history = _web3Service.history;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lots Récents',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Voir tout',
              style: TextStyle(color: Color(0xFFC67A3F), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (history.isEmpty)
          const Text('Aucun lot enregistré.', style: TextStyle(color: Colors.white24, fontSize: 14))
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: history.length,
              itemBuilder: (context, index) {
                final batch = history[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(batch['id'], style: const TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 14)),
                      const Spacer(),
                      Text(batch['type'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      Text(batch['weight'], style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFarmerDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: Colors.black, size: 40),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kouassi',
                          style: TextStyle(color: Color(0xFFC67A3F), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Agriculteur Premium',
                          style: TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Voir le profil',
                        style: TextStyle(color: Color(0xFFC67A3F), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Color(0xFFC67A3F), size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', true, () {
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.history, 'Historique', false, () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BatchHistoryScreen()),
                  );
                }),
                _buildDrawerItem(Icons.settings_outlined, 'Parametres', false, () {}),
                _buildDrawerItem(Icons.help_outline, 'Aide & Support', false, () {}),
              ],
            ),
          ),

          // Footer Logout
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Color(0xFFE57373), size: 24),
                  SizedBox(width: 16),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(left: BorderSide(color: Color(0xFFC67A3F), width: 4))
            : null,
        gradient: isSelected
            ? LinearGradient(
                colors: [const Color(0xFFC67A3F).withOpacity(0.15), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? const Color(0xFFC67A3F) : Colors.white54),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFC67A3F) : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// 1.9.5. ECRAN DE CONFIRMATION (QR CODE)
// ==========================================
class BatchConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> batchData;
  const BatchConfirmationScreen({super.key, required this.batchData});

  @override
  State<BatchConfirmationScreen> createState() => _BatchConfirmationScreenState();
}

class _BatchConfirmationScreenState extends State<BatchConfirmationScreen> {
  final Web3Service _web3Service = Web3Service();
  String _batchHash = "";
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _batchHash = _web3Service.generateBatchHash(widget.batchData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC67A3F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirmation',
          style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // QR Code Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: _batchHash,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Scannez pour vérifier les\ndonnées de traçabilité',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Details Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Details',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Verifié',
                  style: TextStyle(color: Color(0xFFC67A3F), fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Grid of Details
            Row(
              children: [
                Expanded(child: _buildDetailBox('BATCH ID', widget.batchData['id'])),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailBox('TYPE', widget.batchData['type'])),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDetailBox('WEIGHT', widget.batchData['weight'])),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailBox('ORIGIN', widget.batchData['origin'])),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Producteur Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFC67A3F),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PRODUCTEUR',
                        style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.batchData['producer'],
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.verified, color: Color(0xFFC67A3F), size: 24),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Publish Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isPublishing ? null : () async {
                  setState(() => _isPublishing = true);
                  final txHash = await _web3Service.publishToBlockchain(widget.batchData, _batchHash);
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicationSuccessScreen(txHash: txHash),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF864415),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isPublishing)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    else
                      const Icon(Icons.cloud_upload_outlined, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      _isPublishing ? 'PUBLICATION...' : 'Publier sur la Blockchain',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 1.9.6. ECRAN DE SUCCÈS DE PUBLICATION
// ==========================================
class PublicationSuccessScreen extends StatelessWidget {
  final String txHash;
  const PublicationSuccessScreen({super.key, required this.txHash});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Publication',
          style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon with Glow
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A1A1A),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC67A3F).withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFFC67A3F),
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Success Text
            const Text(
              'Publication Réussie',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre lot a été enregistré sur la\nblockchain avec succès.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            
            const SizedBox(height: 48),
            
            // Transaction Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ID TRANSACTION',
                        style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        txHash.length > 20 ? "${txHash.substring(0, 10)}...${txHash.substring(txHash.length - 10)}" : txHash,
                        style: TextStyle(color: const Color(0xFFC67A3F).withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/cocoa_pod.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cacao Criollo - Grade A',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Lot #42 • Coopérative San José',
                            style: TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Download Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR Code enregistré dans la galerie !')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC67A3F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_2, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Télécharger mon QR Code',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Dashboard Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Retour au tableau de bord',
                  style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 1.9.7. ECRAN HISTORIQUE DES LOTS
// ==========================================
class BatchHistoryScreen extends StatefulWidget {
  const BatchHistoryScreen({super.key});

  @override
  State<BatchHistoryScreen> createState() => _BatchHistoryScreenState();
}

class _BatchHistoryScreenState extends State<BatchHistoryScreen> {
  final Web3Service _web3Service = Web3Service();

  @override
  Widget build(BuildContext context) {
    final history = _web3Service.history;
    return history.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, color: Colors.white10, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Aucun lot publié pour le moment.',
                  style: TextStyle(color: Colors.white38),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final batch = history[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          batch['id'],
                          style: const TextStyle(
                            color: Color(0xFFC67A3F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatDate(batch['publishDate']),
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildMiniInfo(Icons.eco_outlined, batch['type']),
                        const SizedBox(width: 16),
                        _buildMiniInfo(Icons.monitor_weight_outlined, batch['weight']),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Colors.white38, size: 14),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "TX: ${batch['txHash'].substring(0, 20)}...",
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const Icon(Icons.verified, color: Colors.green, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildMiniInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

// ==========================================
// 2. MAIN SCREEN AGRICULTEUR (Navigation)
// ==========================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to "Nouveau" (Dashboard)
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _screens = [
    const BatchHistoryScreen(),
    const FarmerDashboardScreen(),
    const Center(child: Text('Coopérative', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Météo', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: _buildFarmerDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFC67A3F)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'CHAIN CACAO',
          style: TextStyle(
            color: Color(0xFFC67A3F),
            fontSize: 18,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1A1A1A),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: const Icon(Icons.person, color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.assignment_outlined, 'Lots', 0),
            _buildNavItem(Icons.add_circle, 'Nouveau', 1),
            _buildNavItem(Icons.people_outline, 'Coop', 2),
            _buildNavItem(Icons.map_outlined, 'Météo', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFC67A3F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(icon, color: const Color(0xFFC67A3F), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                Icon(icon, color: Colors.white38, size: 24),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFarmerDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC67A3F),
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/farmer_profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kouassi Yao',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'ID: #F-99283',
                            style: TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        'Voir le profil',
                        style: TextStyle(color: Color(0xFFC67A3F), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Color(0xFFC67A3F), size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(Icons.dashboard_outlined, 'Dashboard', _currentIndex == 1, () {
                  _pageController.jumpToPage(1);
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.history, 'Historique', _currentIndex == 0, () {
                  _pageController.jumpToPage(0);
                  Navigator.pop(context);
                }),
                _buildDrawerItem(Icons.settings_outlined, 'Paramètres', false, () {}),
                _buildDrawerItem(Icons.help_outline, 'Aide & Support', false, () {}),
              ],
            ),
          ),

          // Footer Logout
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Color(0xFFE57373), size: 24),
                  SizedBox(width: 16),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: isSelected
            ? const Border(left: BorderSide(color: Color(0xFFC67A3F), width: 4))
            : null,
        gradient: isSelected
            ? LinearGradient(
                colors: [const Color(0xFFC67A3F).withOpacity(0.15), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? const Color(0xFFC67A3F) : Colors.white54),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFFC67A3F) : Colors.white54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class CooperativeMainScreen extends StatefulWidget {
  const CooperativeMainScreen({super.key});

  @override
  State<CooperativeMainScreen> createState() => _CooperativeMainScreenState();
}

class _CooperativeMainScreenState extends State<CooperativeMainScreen> {
  int _currentIndex = 0; // Let's start on Dashboard now that we have a real one
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: _buildCoopDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white54),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'CHAIN CACAO',
          style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC67A3F), width: 1.5),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          const CooperativeDashboardScreen(),
          const CooperativeScanScreen(),
          const CooperativeInventoryScreen(),
          const Center(child: Text('Profile Coopérative', style: TextStyle(color: Colors.white))),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view_rounded, 'DASHBOARD', _currentIndex == 0, 0),
            _buildScanNavItem(_currentIndex == 1),
            _buildNavItem(Icons.inventory_2_outlined, 'INVENTAIRE', _currentIndex == 2, 2),
            _buildNavItem(Icons.person_outline, 'PROFILE', _currentIndex == 3, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildCoopDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC67A3F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('San José Ltd.', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Admin Panel', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.analytics_outlined, 'Statistiques Avancées'),
          _buildDrawerItem(Icons.people_alt_outlined, 'Gérer les Agriculteurs'),
          _buildDrawerItem(Icons.account_balance_wallet_outlined, 'Paiements & Factures'),
          _buildDrawerItem(Icons.settings_outlined, 'Configuration'),
          const Spacer(),
          _buildDrawerItem(Icons.logout, 'Déconnexion', color: Colors.redAccent),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white70),
      title: Text(title, style: TextStyle(color: color ?? Colors.white70)),
      onTap: () {},
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, int index) {
    return InkWell(
      onTap: () => _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFC67A3F) : Colors.white38, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC67A3F) : Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanNavItem(bool isActive) {
    return InkWell(
      onTap: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFC67A3F) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? null : Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(Icons.qr_code_scanner, color: isActive ? Colors.white : Colors.white54, size: 20),
            if (isActive) ...[
              const SizedBox(width: 8),
              const Text('SCAN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ]
          ],
        ),
      ),
    );
  }
}

class CooperativeDashboardScreen extends StatelessWidget {
  const CooperativeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Bienvenue,',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          const Text(
            'Coopérative San José',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Main Stats Card (Valorisation)
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC67A3F), Color(0xFF8B4A1E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC67A3F).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('VALORISATION DU STOCK', style: TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                const Text('48.50 ETH', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
                          SizedBox(width: 4),
                          Text('+12%', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text('Depuis le mois dernier', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Grid Stats
          Row(
            children: [
              _buildStatCard('TONNAGE TOTAL', '12.5T', Icons.inventory_2_outlined),
              const SizedBox(width: 16),
              _buildStatCard('PRODUCTEURS', '84', Icons.people_outline),
            ],
          ),
          const SizedBox(height: 24),

          // Chart Section (Mock)
          const Text('Collectes de la Semaine', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            height: 150,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(0.4, 'Lun'),
                _buildBar(0.7, 'Mar'),
                _buildBar(0.5, 'Mer'),
                _buildBar(0.9, 'Jeu'),
                _buildBar(0.6, 'Ven'),
                _buildBar(0.3, 'Sam'),
                _buildBar(0.1, 'Dim'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Collectes Récentes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildCollectionItem('Agriculteur Kouassi', 'Lot #TRC-8829', '250 kg', 'Vérifié'),
          _buildCollectionItem('Mme. Amina', 'Lot #TRC-8830', '420 kg', 'Vérifié'),
          _buildCollectionItem('Jean-Paul', 'Lot #TRC-8831', '180 kg', 'En attente'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFC67A3F), size: 20),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double heightFactor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 80 * heightFactor,
          decoration: BoxDecoration(
            color: const Color(0xFFC67A3F),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildCollectionItem(String name, String lot, String weight, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.receipt_long_outlined, color: Color(0xFFC67A3F)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(lot, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(weight, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: status == "Vérifié" ? Colors.green : Colors.orange, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }
}

class CooperativeScanScreen extends StatefulWidget {
  const CooperativeScanScreen({super.key});

  @override
  State<CooperativeScanScreen> createState() => _CooperativeScanScreenState();
}

class _CooperativeScanScreenState extends State<CooperativeScanScreen> with SingleTickerProviderStateMixin {
  final Web3Service _web3Service = Web3Service();
  bool _isScanning = false;
  late AnimationController _animationController;
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !_isScanning) {
      setState(() { _isScanning = true; });
      HapticFeedback.heavyImpact(); // Haptic feedback on detection
      
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        final Map<String, String> batchData = _parseBatchCode(code);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DigitalSignatureScreen(batchData: batchData),
            ),
          );
        }
      }
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isScanning = false);
      });
    }
  }

  Map<String, String> _parseBatchCode(String raw) {
    try {
      final parts = raw.split('|');
      final Map<String, String> data = {};
      for (final part in parts) {
        final kv = part.split(':');
        if (kv.length >= 2) data[kv[0].trim()] = kv.sublist(1).join(':').trim();
      }
      return {
        'id': data['id'] ?? '#TRC-8829',
        'producteur': data['producteur'] ?? 'Kouassi',
        'type': data['type'] ?? 'Cacao Criollo',
        'qualite': data['qualite'] ?? 'Grade A',
        'poids': data['poids'] ?? '250kg',
        'origine': data['origine'] ?? 'TOGO',
        'hash': raw,
      };
    } catch (_) {
      return {
        'id': '#TRC-8829',
        'producteur': 'Kouassi',
        'type': 'Cacao Criollo',
        'qualite': 'Grade A',
        'poids': '250kg',
        'origine': 'TOGO',
        'hash': raw,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Camera Layer
        MobileScanner(
          controller: _scannerController,
          onDetect: _onDetect,
        ),
          
        // 2. Blur Overlay (Optimized Viewfinder)
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 3. UI Layer (Interactive elements)
        Column(
          children: [
            const SizedBox(height: 10),
            
            // Viewfinder Frame & Animation (Middle)
            Expanded(
              child: Center(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Stack(
                    children: [
                      _buildCorner(0, 0, true, true), // TL
                      _buildCorner(1, 0, false, true), // TR
                      _buildCorner(0, 1, true, false), // BL
                      _buildCorner(1, 1, false, false), // BR
                      
                      // Animated Scanning Line
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Positioned(
                            top: 240 * _animationController.value,
                            left: 20,
                            right: 20,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC67A3F),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFC67A3F).withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom UI Panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Alignez le QR code du lot',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'La détection est automatique.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  
                  // Optimized Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconButton(
                          icon: Icons.flashlight_on_outlined,
                          label: 'Lampe',
                          onTap: () => _scannerController.toggleTorch(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildIconButton(
                          icon: Icons.keyboard_outlined,
                          label: 'Saisie',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Status Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Scanner prêt',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        
        if (_isScanning)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFC67A3F)),
            ),
          ),
      ],
    );
  }

  Widget _buildCorner(double x, double y, bool left, bool top) {
    return Positioned(
      left: x == 0 ? 0 : null,
      right: x == 1 ? 0 : null,
      top: y == 0 ? 0 : null,
      bottom: y == 1 ? 0 : null,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            bottom: !top ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            left: left ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            right: !left ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFC67A3F), size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2.3. ECRAN DE SIGNATURE NUMÉRIQUE
// ==========================================
class DigitalSignatureScreen extends StatelessWidget {
  final Map<String, String> batchData;
  const DigitalSignatureScreen({super.key, required this.batchData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFFC67A3F)),
          onPressed: () {},
        ),
        title: const Text(
          'Chain Cacao',
          style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1A1A1A),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const Icon(Icons.person, color: Colors.white30, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Success Check Icon
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC67A3F).withOpacity(0.2), width: 1),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFC67A3F),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Scan Réussi',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 100), // Replacement for Spacer in ScrollView

            // Signature Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFC67A3F).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SIGNATURE NUMÉRIQUE GÉNÉRÉE',
                            style: TextStyle(
                              color: Color(0xFFC67A3F), 
                              fontSize: 10, 
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '0x7f8e...3a2b1c9d8e7f6a5b4c3d2e1f0',
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Icon(Icons.fingerprint, color: Color(0xFFC67A3F), size: 28),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),

            // Send Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScanSuccessScreen(batchData: batchData),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF864415),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Envoyer',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100), // Replacement for Spacer in ScrollView
            
            // Bottom Nav Placeholder
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSimpleNavItem(Icons.grid_view, 'Dashboard', false),
                  _buildSimpleNavItem(Icons.qr_code_scanner, 'Scanning', true),
                  _buildSimpleNavItem(Icons.inventory_2_outlined, 'Inventaire', false),
                  _buildSimpleNavItem(Icons.person_outline, 'Profile', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleNavItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? const Color(0xFFC67A3F) : Colors.white24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? const Color(0xFFC67A3F) : Colors.white24, fontSize: 10)),
      ],
    );
  }
}

class CooperativeInventoryScreen extends StatelessWidget {
  const CooperativeInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inventaire Global',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: Color(0xFFC67A3F)),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.white24, size: 20),
                hintText: 'Chercher un lot ou un producteur...',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Summary Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              _buildFilterChip('Tout', true),
              _buildFilterChip('En Stock', false),
              _buildFilterChip('Expédié', false),
              _buildFilterChip('Grade A', false),
              _buildFilterChip('Cacao Criollo', false),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Inventory List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildInventoryItem('#TRC-8829', 'Agriculteur Kouassi', '250 kg', 'Grade A', 'Il y a 2h'),
              _buildInventoryItem('#TRC-8830', 'Mme. Amina', '420 kg', 'Grade A', 'Il y a 5h'),
              _buildInventoryItem('#TRC-8825', 'Jean-Paul', '180 kg', 'Grade B', 'Hier'),
              _buildInventoryItem('#TRC-8820', 'Koffi Adama', '310 kg', 'Grade A', 'Hier'),
              _buildInventoryItem('#TRC-8818', 'Saliou', '290 kg', 'Grade C', '2 jours'),
              _buildInventoryItem('#TRC-8815', 'Pauline', '500 kg', 'Grade A', '3 jours'),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFC67A3F) : const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: active ? null : Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String id, String producer, String weight, String grade, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // Grade indicator
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC67A3F).withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                grade.split(' ').last,
                style: const TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(id, style: const TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: const TextStyle(color: Colors.white24, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(producer, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.scale_outlined, color: Colors.white38, size: 14),
                    const SizedBox(width: 4),
                    Text(weight, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    const Text('En Stock', style: TextStyle(color: Colors.green, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white10),
        ],
      ),
    );
  }
}

class ScanSuccessScreen extends StatelessWidget {
  final Map<String, String> batchData;
  const ScanSuccessScreen({super.key, required this.batchData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.white54),
                  const Text(
                    'Chain Cacao',
                    style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFC67A3F), width: 1.5),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Success Icon + Title
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC67A3F), Color(0xFF8B4A1E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFC67A3F).withOpacity(0.4),
                                  blurRadius: 24,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Scan Réussi',
                            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ce lot a été vérifiée avec\nsuccès sur la blockchain.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Détails du Lot Label
                    Text(
                      'Détails du Lot',
                      style: TextStyle(color: const Color(0xFFC67A3F).withOpacity(0.9), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const SizedBox(height: 16),

                    // Batch ID Card
                    _buildInfoCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('BATCH ID', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              const SizedBox(height: 6),
                              Text(
                                batchData['id'] ?? '#TRC-8829',
                                style: const TextStyle(color: Color(0xFFC67A3F), fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Icon(Icons.verified_outlined, color: Colors.white24, size: 28),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Producteur Card
                    _buildInfoCard(
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('farmer_kouassi_profile_1777643510738.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PRODUCTEUR', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              const SizedBox(height: 4),
                              Text(
                                batchData['producteur'] ?? 'Kouassi',
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Type & Qualité Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TYPE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                const SizedBox(height: 6),
                                Text(
                                  batchData['type'] ?? 'Cacao Criollo',
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('QUALITÉ', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Color(0xFFC67A3F), size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      batchData['qualite'] ?? 'Grade A',
                                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Poids & Origine Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('POIDS', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                const SizedBox(height: 6),
                                Text(
                                  batchData['poids'] ?? '250kg',
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInfoCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ORIGINE', style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, color: Colors.white38, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      batchData['origine'] ?? 'TOGO',
                                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Map / Localisation Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('cocoa_hills_landscape_1777643915230.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Overlay gradient
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 14,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(color: Color(0xFFC67A3F), shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Localisation Certifiée',
                                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Continuer Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC67A3F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'Continuer',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Signaler une anomalie
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Signaler une anomalie',
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Navigation (miroir coopérative)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF141414),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomIcon(Icons.grid_view_rounded, 'Dashboard', false),
                  _bottomIconActive(Icons.qr_code_scanner, 'Scanning'),
                  _bottomIcon(Icons.inventory_2_outlined, 'Inventaire', false),
                  _bottomIcon(Icons.person_outline, 'Profile', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _bottomIcon(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? const Color(0xFFC67A3F) : Colors.white38, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: active ? const Color(0xFFC67A3F) : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _bottomIconActive(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC67A3F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

// ==========================================
// 4. ECRAN EXPORTATEUR (Dashboard & Validation)
// ==========================================

class ExporterMainScreen extends StatefulWidget {
  const ExporterMainScreen({super.key});

  @override
  State<ExporterMainScreen> createState() => _ExporterMainScreenState();
}

class _ExporterMainScreenState extends State<ExporterMainScreen> {
  int _currentIndex = 1; // Default to History/List
  bool _isSuccess = false;
  final PageController _pageController = PageController(initialPage: 1);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: _buildExporterDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isSuccess ? 'Publication Réussie' : 'Validation Export',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          if (!_isSuccess)
            _currentIndex == 0
                ? IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white54, size: 24),
                    onPressed: () {},
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        _currentIndex == 1 ? 'EXPR-01' : '',
                        style: const TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  'OBSIDIAN',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
        ],
      ),
      body: _isSuccess 
          ? ExporterSuccessScreen(onBack: () => setState(() => _isSuccess = false))
          : PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              children: [
                const ExporterScanScreen(),
                ExporterDashboardScreen(onValidate: () => setState(() => _isSuccess = true)),
                const Center(child: Text('Profil Exportateur', style: TextStyle(color: Colors.white))),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.qr_code_scanner, 'SCAN', 0),
            _buildNavItem(Icons.history, 'HISTORY', 1),
            _buildNavItem(Icons.person_outline, 'PROFILE', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFFC67A3F) : Colors.white38, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC67A3F) : Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExporterDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF141414)),
            child: Center(
              child: Text(
                'CHAIN CACAO EXPORT',
                style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Déconnexion', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen())),
          ),
        ],
      ),
    );
  }
}

class ExporterDashboardScreen extends StatelessWidget {
  final VoidCallback onValidate;
  const ExporterDashboardScreen({super.key, required this.onValidate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          // Lot Card Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: const DecorationImage(
                image: AssetImage('assets/images/cocoa_beans_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUT : PRÊT',
                    style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '#TRC-2024',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard('POIDS TOTAL', '500 kg'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('QUALITÉ', 'AA+', hasStar: true),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'Parcours du Lot',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 24),
          
          // Timeline
          _buildTimelineItem(
            'Créé par Producteur',
            'Ferme El Mirador, Huehuetenango. Récolte manuelle sélective.',
            '10 Jan',
            Icons.eco_outlined,
            isFirst: true,
          ),
          _buildTimelineItem(
            'Collecté par Coop',
            'Transport sécurisé vers le centre de traitement centralisé.',
            '15 Jan',
            Icons.local_shipping_outlined,
          ),
          _buildTimelineItem(
            'Prêt pour Export',
            'Validation qualité effectuée. Lot certifié.',
            'Aujourd\'hui',
            Icons.check_circle_outline,
            isLast: true,
            isActive: true,
          ),
          
          const SizedBox(height: 32),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onValidate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Valider pour export',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, {bool hasStar = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (hasStar) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Color(0xFFC67A3F), size: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, String date, IconData icon, {bool isFirst = false, bool isLast = false, bool isActive = false}) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? const Color(0xFFC67A3F) : Colors.transparent,
                  border: Border.all(color: isActive ? const Color(0xFFC67A3F) : Colors.white24, width: 2),
                ),
                child: isActive ? null : Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24))),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.white10,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isActive ? const Color(0xFFC67A3F).withOpacity(0.3) : Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: isActive ? const Color(0xFFC67A3F) : Colors.white54, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: TextStyle(color: isActive ? const Color(0xFFC67A3F) : Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      Text(
                        date,
                        style: const TextStyle(color: Colors.white38, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExporterScanScreen extends StatefulWidget {
  const ExporterScanScreen({super.key});

  @override
  State<ExporterScanScreen> createState() => _ExporterScanScreenState();
}

class _ExporterScanScreenState extends State<ExporterScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Camera Layer
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            // Logic handled by the controller/state
          },
        ),
        
        // 2. Dark Overlay with Viewfinder cutout
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.8),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 3. UI Layer (Viewfinder and Buttons)
        Positioned.fill(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Viewfinder Frame & Animation (Middle)
                  Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Stack(
                        children: [
                          _buildCorner(0, 0, true, true), // TL
                          _buildCorner(1, 0, false, true), // TR
                          _buildCorner(0, 1, true, false), // BL
                          _buildCorner(1, 1, false, false), // BR
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  const Text(
                    'Prêt à scanner',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Alignez le QR Code du lot pour validation',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Manual Entry Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white10),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xFF141414).withOpacity(0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard_outlined, color: Color(0xFFC67A3F), size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Saisir manuellement le code',
                            style: TextStyle(color: Color(0xFFC67A3F), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Next Lot Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.inventory_2_outlined, color: Color(0xFFC67A3F)),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PROCHAIN LOT ATTENDU',
                                  style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lot #BRW-2024-082',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white24),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(double x, double y, bool left, bool top) {
    return Positioned(
      left: x == 0 ? 0 : null,
      right: x == 1 ? 0 : null,
      top: y == 0 ? 0 : null,
      bottom: y == 1 ? 0 : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            bottom: !top ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            left: left ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
            right: !left ? const BorderSide(color: Color(0xFFC67A3F), width: 4) : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: left && top ? const Radius.circular(15) : Radius.zero,
            topRight: !left && top ? const Radius.circular(15) : Radius.zero,
            bottomLeft: left && !top ? const Radius.circular(15) : Radius.zero,
            bottomRight: !left && !top ? const Radius.circular(15) : Radius.zero,
          ),
        ),
      ),
    );
  }
}

class ExporterSuccessScreen extends StatelessWidget {
  final VoidCallback onBack;
  const ExporterSuccessScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Success Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC67A3F).withOpacity(0.2), width: 8),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF141414),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Color(0xFFC67A3F), size: 40),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                const Text('Exporté', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Exportation Validée',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Le lot a été marqué comme exporté et l\'événement a été enregistré sur la blockchain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.5),
          ),
          
          const SizedBox(height: 40),
          
          // Hash Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hash de Transaction', style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                    Icon(Icons.copy, color: Colors.white38, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '0x7a2d4f8e91c0b3d6f5a2e1c9d8b7a6f\n5e4d3c2b1a0f9e8d7c6b5a4f3e2d1c0',
                  style: TextStyle(color: const Color(0xFFC67A3F).withOpacity(0.8), fontSize: 12, fontFamily: 'monospace', height: 1.5),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Info Row
          Row(
            children: [
              Expanded(child: _buildInfoCard('Lot ID', '#LOT-882-ESPR')),
              const SizedBox(width: 16),
              Expanded(child: _buildInfoCard('Destination', 'Anvers, BE')),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onBack,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67A3F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grid_view_outlined, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Retour au tableau de bord',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
