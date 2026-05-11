import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';

class FirestoreService {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // ── Referencia base del usuario ───────────────────────────────────
  DocumentReference get _userDoc =>
      _db.collection('usuarios').doc(_uid);

  // ═══════════════════════════════════════════════════════════════════
  // PRENDAS
  // ═══════════════════════════════════════════════════════════════════

  Stream<List<Prenda>> prendasStream() {
    if (_uid == null) return const Stream.empty();
    return _userDoc
        .collection('prendas')
        .orderBy('creadoEn', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Prenda.fromFirestore(d)).toList());
  }

  Future<void> addPrenda(Prenda p) async {
    if (_uid == null) return;
    await _userDoc.collection('prendas').doc(p.id).set(p.toFirestore());
  }

  Future<void> updatePrenda(Prenda p) async {
    if (_uid == null) return;
    await _userDoc.collection('prendas').doc(p.id).update(p.toFirestore());
  }

  Future<void> deletePrenda(String id) async {
    if (_uid == null) return;
    await _userDoc.collection('prendas').doc(id).delete();
  }

  // Subir prendas iniciales al registrarse (solo si no tiene ninguna)
  Future<void> subirPrendasIniciales(List<Prenda> prendas) async {
    if (_uid == null) return;
    final col  = _userDoc.collection('prendas');
    final snap = await col.limit(1).get();
    if (snap.docs.isNotEmpty) return;

    // Firestore batch tiene límite de 500 — dividimos en grupos
    const chunkSize = 400;
    for (var i = 0; i < prendas.length; i += chunkSize) {
      final chunk = prendas.sublist(
        i, i + chunkSize > prendas.length ? prendas.length : i + chunkSize,
      );
      final batch = _db.batch();
      for (final p in chunk) {
        batch.set(col.doc(p.id), p.toFirestore());
      }
      await batch.commit();
    }
  }

  // ═══════════════════════════════════════════════════════════════════
  // FAVORITOS
  // ═══════════════════════════════════════════════════════════════════

  // Añadir a favoritos
  Future<void> addFavorito(String prendaId) async {
    if (_uid == null) return;
    await _userDoc.update({
      'favoritos': FieldValue.arrayUnion([prendaId]),
    });
  }

  // Quitar de favoritos
  Future<void> removeFavorito(String prendaId) async {
    if (_uid == null) return;
    await _userDoc.update({
      'favoritos': FieldValue.arrayRemove([prendaId]),
    });
  }

  // Stream de favoritos en tiempo real
  Stream<List<String>> favoritosStream() {
    if (_uid == null) return const Stream.empty();
    return _userDoc.snapshots().map((doc) {
      if (!doc.exists) return [];
      final data = doc.data() as Map<String, dynamic>;
      final favs = data['favoritos'];
      if (favs == null || favs is! List) return [];
      return List<String>.from(favs);
    });
  }

  // ═══════════════════════════════════════════════════════════════════
  // CONJUNTOS
  // ═══════════════════════════════════════════════════════════════════

  Stream<List<Conjunto>> conjuntosStream() {
    if (_uid == null) return const Stream.empty();
    return _userDoc
        .collection('conjuntos')
        .orderBy('creadoEn', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Conjunto.fromFirestore(d)).toList());
  }

  Future<void> addConjunto(Conjunto c) async {
    if (_uid == null) return;
    await _userDoc.collection('conjuntos').doc(c.id).set(c.toFirestore());
  }

  Future<void> updateConjunto(Conjunto c) async {
    if (_uid == null) return;
    await _userDoc.collection('conjuntos').doc(c.id).update(c.toFirestore());
  }

  Future<void> deleteConjunto(String id) async {
    if (_uid == null) return;
    await _userDoc.collection('conjuntos').doc(id).delete();
  }

  // ═══════════════════════════════════════════════════════════════════
  // CALENDARIO
  // ═══════════════════════════════════════════════════════════════════

  // Guardar outfit del día (clave: 'yyyy-MM-dd')
  Future<void> guardarOutfitDia(String fecha, String conjuntoId) async {
    if (_uid == null) return;
    await _userDoc.collection('calendario').doc(fecha).set({
      'conjuntoId': conjuntoId,
      'fecha':      fecha,
      'actualizadoEn': FieldValue.serverTimestamp(),
    });
  }

  // Obtener outfit de un día concreto
  Future<String?> getOutfitDia(String fecha) async {
    if (_uid == null) return null;
    final doc = await _userDoc.collection('calendario').doc(fecha).get();
    if (!doc.exists) return null;
    return (doc.data() as Map<String, dynamic>)['conjuntoId'] as String?;
  }

  // Stream del calendario completo
  Stream<Map<String, String>> calendarioStream() {
    if (_uid == null) return const Stream.empty();
    return _userDoc
        .collection('calendario')
        .snapshots()
        .map((s) {
      final map = <String, String>{};
      for (final doc in s.docs) {
        final data = doc.data();
        map[doc.id] = data['conjuntoId'] ?? '';
      }
      return map;
    });
  }

  Future<void> eliminarOutfitDia(String fecha) async {
    if (_uid == null) return;
    await _userDoc.collection('calendario').doc(fecha).delete();
  }
}