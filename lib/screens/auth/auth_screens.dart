import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LOGIN
// ─────────────────────────────────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _hidePass   = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AppState>().login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );
    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 48),

                // logo lobo imagen real
                _WolfLogo(),

                const SizedBox(height: 24),

                // título
                Text(
                  'T-POP',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                    letterSpacing: 10,
                    color: AppTheme.white,
                  ),
                ),
                Text(
                  'TU ARMARIO DIGITAL',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    letterSpacing: 4,
                    color: AppTheme.grey,
                  ),
                ),

                const SizedBox(height: 48),

                // email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                  v!.isEmpty ? 'Introduce tu email' : null,
                ),

                const SizedBox(height: 16),

                // contraseña
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _hidePass,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                  validator: (v) =>
                  v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),

                const SizedBox(height: 12),

                // error
                if (state.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.red.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      state.error!,
                      style: const TextStyle(
                        color: AppTheme.redLight,
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 28),

                // botón entrar
                ElevatedButton(
                  onPressed: state.loading ? null : _login,
                  child: state.loading
                      ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.white,
                    ),
                  )
                      : const Text('ENTRAR'),
                ),

                const SizedBox(height: 16),

                // ir a registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Sin cuenta? ',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Regístrate',
                        style: GoogleFonts.dmSans(
                          color: AppTheme.goldWhite,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.goldWhite,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REGISTER
// ─────────────────────────────────────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _nombreCtrl   = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _pass2Ctrl    = TextEditingController();
  bool _hidePass      = true;
  bool _hidePass2     = true;
  String _talla       = 'M';

  static const _tallas = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AppState>().registrar(
      nombre:   _nombreCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      password: _passCtrl.text,
      talla:    _talla,
    );
    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 8),

                // título
                Text(
                  'CREAR CUENTA',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 36,
                    letterSpacing: 4,
                    color: AppTheme.white,
                  ),
                ),
                Text(
                  'Únete a T-POP',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 32),

                // nombre
                TextFormField(
                  controller: _nombreCtrl,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                  v!.isEmpty ? 'El nombre es obligatorio' : null,
                ),

                const SizedBox(height: 14),

                // username
                TextFormField(
                  controller: _usernameCtrl,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(
                      Icons.alternate_email,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                  v!.isEmpty ? 'El username es obligatorio' : null,
                ),

                const SizedBox(height: 14),

                // email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                  ),
                  validator: (v) =>
                  v!.isEmpty ? 'El email es obligatorio' : null,
                ),

                const SizedBox(height: 14),

                // contraseña
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _hidePass,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                  validator: (v) =>
                  v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),

                const SizedBox(height: 14),

                // confirmar contraseña
                TextFormField(
                  controller: _pass2Ctrl,
                  obscureText: _hidePass2,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppTheme.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _hidePass2 = !_hidePass2),
                    ),
                  ),
                  validator: (v) => v != _passCtrl.text
                      ? 'Las contraseñas no coinciden'
                      : null,
                ),

                const SizedBox(height: 24),

                // talla
                Text(
                  'MI TALLA',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    letterSpacing: 2,
                    color: AppTheme.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tallas.map((t) {
                    final sel = _talla == t;
                    return GestureDetector(
                      onTap: () => setState(() => _talla = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppTheme.blue.withOpacity(0.2)
                              : AppTheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel ? AppTheme.blue : AppTheme.border,
                            width: sel ? 1 : 0.5,
                          ),
                        ),
                        child: Text(
                          t,
                          style: GoogleFonts.dmSans(
                            color: sel ? AppTheme.blue : AppTheme.greyLight,
                            fontWeight: sel
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // error
                if (state.error != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppTheme.red.withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      state.error!,
                      style: const TextStyle(
                        color: AppTheme.redLight,
                        fontSize: 13,
                      ),
                    ),
                  ),

                const SizedBox(height: 28),

                // botón registrar
                ElevatedButton(
                  onPressed: state.loading ? null : _registrar,
                  child: state.loading
                      ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.white,
                    ),
                  )
                      : const Text('CREAR CUENTA'),
                ),

                const SizedBox(height: 16),

                // ir a login
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      '¿Ya tienes cuenta? Inicia sesión',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.goldWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.goldWhite,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LOGO LOBO — imagen real
// ─────────────────────────────────────────────────────────────────────────────
class _WolfLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.blue, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset('assets/ropa/logo_del_Lobo.png', fit: BoxFit.cover),
      ),
    );
  }
}