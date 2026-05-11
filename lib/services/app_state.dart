import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {

  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;
  final _fs   = FirestoreService();

  bool    _loggedIn   = false;
  String  _nombre     = '';
  String  _email      = '';
  String  _username   = '';
  String  _talla      = '';
  String? _fotoUrl;
  bool    _loading    = false;
  String? _error;
  bool    _temaOscuro = true;
  final List<String> _favoritos = [];

  bool         get isLoggedIn  => _loggedIn;
  String       get nombre      => _nombre;
  String       get email       => _email;
  String       get username    => _username;
  String       get talla       => _talla;
  String?      get fotoUrl     => _fotoUrl;
  bool         get loading     => _loading;
  String?      get error       => _error;
  bool         get temaOscuro  => _temaOscuro;
  List<String> get favoritos   => List.unmodifiable(_favoritos);

  void toggleTema() {
    _temaOscuro = !_temaOscuro;
    notifyListeners();
  }

  AppState() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        _loggedIn = true;
        _email    = user.email ?? '';
        await _cargarPerfil(user.uid);
        _fs.favoritosStream().listen((favs) {
          _favoritos
            ..clear()
            ..addAll(favs);
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _nombre = _email = _username = _talla = '';
        _fotoUrl = null;
        _favoritos.clear();
      }
      notifyListeners();
    });
  }

  Future<void> _cargarPerfil(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        final d   = doc.data()!;
        _nombre   = d['nombre']   ?? '';
        _username = d['username'] ?? '';
        _talla    = d['talla']    ?? '';
        _fotoUrl  = d['fotoUrl'];
        _favoritos.clear();
        final favs = d['favoritos'];
        if (favs is List) _favoritos.addAll(List<String>.from(favs));
      }
    } catch (e) {
      debugPrint('Error cargando perfil: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true); _clearError();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mensajeError(e.code));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registrar({
    required String nombre,
    required String username,
    required String email,
    required String password,
    required String talla,
  }) async {
    _setLoading(true); _clearError();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      final uid = cred.user!.uid;

      await _db.collection('usuarios').doc(uid).set({
        'nombre':    nombre,
        'username':  username,
        'email':     email.trim(),
        'talla':     talla,
        'fotoUrl':   null,
        'favoritos': <String>[],
        'creadoEn':  FieldValue.serverTimestamp(),
      });

      _fs.subirPrendasIniciales(PrendasData.prendas).catchError((e) {
        debugPrint('Error subiendo prendas: $e');
      });

      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mensajeError(e.code));
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async => await _auth.signOut();

  Future<void> toggleFavorito(String prendaId) async {
    if (_favoritos.contains(prendaId)) {
      _favoritos.remove(prendaId);
      await _fs.removeFavorito(prendaId);
    } else {
      _favoritos.add(prendaId);
      await _fs.addFavorito(prendaId);
    }
    notifyListeners();
  }

  bool esFavorito(String prendaId) => _favoritos.contains(prendaId);

  Future<void> actualizarPerfil({
    String? nombre, String? username, String? talla, String? fotoUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final datos = <String, dynamic>{};
    if (nombre   != null) { _nombre   = nombre;   datos['nombre']   = nombre; }
    if (username != null) { _username = username; datos['username'] = username; }
    if (talla    != null) { _talla    = talla;    datos['talla']    = talla; }
    if (fotoUrl  != null) { _fotoUrl  = fotoUrl;  datos['fotoUrl']  = fotoUrl; }
    if (datos.isNotEmpty) {
      await _db.collection('usuarios').doc(user.uid).update(datos);
    }
    notifyListeners();
  }

  // ✅ Guardar cuestionario de estilo en Firestore
  Future<void> actualizarCuestionario({
    required String estilo,
    required String colores,
    required String ocasion,
    required String temperatura,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _db.collection('usuarios').doc(user.uid).update({
      'cuestionario': {
        'estilo':      estilo,
        'colores':     colores,
        'ocasion':     ocasion,
        'temperatura': temperatura,
      },
    });
  }

  String _mensajeError(String code) {
    switch (code) {
      case 'user-not-found':       return 'No existe ninguna cuenta con ese email';
      case 'wrong-password':       return 'Contraseña incorrecta';
      case 'email-already-in-use': return 'Ya existe una cuenta con ese email';
      case 'weak-password':        return 'La contraseña debe tener al menos 6 caracteres';
      case 'invalid-email':        return 'El formato del email no es válido';
      case 'too-many-requests':    return 'Demasiados intentos. Espera un momento';
      default:                     return 'Error de autenticación. Inténtalo de nuevo';
    }
  }

  void _setLoading(bool v) { _loading = v; notifyListeners(); }
  void _setError(String m)  { _error = m;  notifyListeners(); }
  void _clearError()         { _error = null; notifyListeners(); }
}