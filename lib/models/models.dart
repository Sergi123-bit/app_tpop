import 'package:cloud_firestore/cloud_firestore.dart';

class Prenda {
  final String id;
  final String nombre;
  final String tipo;
  final String categoria;
  final String color;
  final String talla;
  final String marca;
  final String? imagenUrl;
  final bool disponible;

  const Prenda({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.categoria,
    required this.color,
    required this.talla,
    required this.marca,
    this.imagenUrl,
    this.disponible = true,
  });

  factory Prenda.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Prenda(
      id:         doc.id,
      nombre:     d['nombre']     ?? '',
      tipo:       d['tipo']       ?? '',
      categoria:  d['categoria']  ?? '',
      color:      d['color']      ?? '',
      talla:      d['talla']      ?? '',
      marca:      d['marca']      ?? '',
      imagenUrl:  d['imagenUrl'],
      disponible: d['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'nombre':     nombre,
    'tipo':       tipo,
    'categoria':  categoria,
    'color':      color,
    'talla':      talla,
    'marca':      marca,
    'imagenUrl':  imagenUrl,
    'disponible': disponible,
    'creadoEn':   FieldValue.serverTimestamp(),
  };
}

// ── Conjunto ──────────────────────────────────────────────────────────
class Conjunto {
  final String id;
  final String nombre;
  final List<String> prendaIds;
  final String? ocasion;

  const Conjunto({
    required this.id,
    required this.nombre,
    required this.prendaIds,
    this.ocasion,
  });

  // ✅ NUEVO — leer desde Firestore
  factory Conjunto.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Conjunto(
      id:        doc.id,
      nombre:    d['nombre']   ?? '',
      prendaIds: List<String>.from(d['prendaIds'] ?? []),
      ocasion:   d['ocasion'],
    );
  }

  // ✅ NUEVO — guardar en Firestore
  Map<String, dynamic> toFirestore() => {
    'nombre':    nombre,
    'prendaIds': prendaIds,
    'ocasion':   ocasion,
    'creadoEn':  FieldValue.serverTimestamp(),
  };
}

// ── PrendasData ───────────────────────────────────────────────────────
class PrendasData {
  static final List<Prenda> prendas = [
    // Superiores
    const Prenda(id: '1',  nombre: 'Camiseta Azul Manga Larga',     tipo: 'Camiseta', categoria: 'superior', color: 'Azul',    talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_azul_manga_larga.jpg'),
    const Prenda(id: '2',  nombre: 'Camiseta Azul Manga Larga 2',   tipo: 'Camiseta', categoria: 'superior', color: 'Azul',    talla: 'L',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_azul_manga_larga2.jpg'),
    const Prenda(id: '3',  nombre: 'Camiseta Azul Sin Mangas',      tipo: 'Camiseta', categoria: 'superior', color: 'Azul',    talla: 'S',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_azul_sin_mangas.jpg'),
    const Prenda(id: '4',  nombre: 'Camiseta Blanca',               tipo: 'Camiseta', categoria: 'superior', color: 'Blanco',  talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_blanca.jpg'),
    const Prenda(id: '5',  nombre: 'Camiseta Blanca Manga Larga',   tipo: 'Camiseta', categoria: 'superior', color: 'Blanco',  talla: 'L',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_blanca_manga_larga.jpg'),
    const Prenda(id: '6',  nombre: 'Camiseta Blanca Manga Larga 2', tipo: 'Camiseta', categoria: 'superior', color: 'Blanco',  talla: 'L',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_blanca_manga_larga2.jpg'),
    const Prenda(id: '7',  nombre: 'Camiseta Blanca Sin Mangas',    tipo: 'Camiseta', categoria: 'superior', color: 'Blanco',  talla: 'S',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_blanca_sin_mangas.jpg'),
    const Prenda(id: '8',  nombre: 'Camiseta Blanca Tirantes',      tipo: 'Camiseta', categoria: 'superior', color: 'Blanco',  talla: 'XS', marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_blanca_tirantes.jpg'),
    const Prenda(id: '9',  nombre: 'Camiseta Cyan Deporte',         tipo: 'Camiseta', categoria: 'superior', color: 'Cyan',    talla: 'M',  marca: 'Joma',     imagenUrl: 'assets/ropa/camiseta_cyan.jpg'),
    const Prenda(id: '10', nombre: 'Camiseta Gris Manga Larga',     tipo: 'Camiseta', categoria: 'superior', color: 'Gris',    talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_gris_manga_larga.jpg'),
    const Prenda(id: '11', nombre: 'Camiseta Naranja Manga Larga',  tipo: 'Camiseta', categoria: 'superior', color: 'Naranja', talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_naranja_manga_larga.jpg'),
    const Prenda(id: '12', nombre: 'Camiseta Negra',                tipo: 'Camiseta', categoria: 'superior', color: 'Negro',   talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_negra.jpg'),
    const Prenda(id: '13', nombre: 'Camiseta Negra Gato',           tipo: 'Camiseta', categoria: 'superior', color: 'Negro',   talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_negra_gato.jpg'),
    const Prenda(id: '14', nombre: 'Camiseta Negra Manga Larga',    tipo: 'Camiseta', categoria: 'superior', color: 'Negro',   talla: 'L',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_negra_manga_larga.jpg'),
    const Prenda(id: '15', nombre: 'Camiseta Negra Sin Mangas',     tipo: 'Camiseta', categoria: 'superior', color: 'Negro',   talla: 'S',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_negra_sin_mangas.jpg'),
    const Prenda(id: '16', nombre: 'Camiseta Roja Sin Mangas',      tipo: 'Camiseta', categoria: 'superior', color: 'Rojo',    talla: 'M',  marca: 'Genérico', imagenUrl: 'assets/ropa/camiseta_roja_sin_mangas.jpg'),
    const Prenda(id: '17', nombre: 'Camiseta Trek',                 tipo: 'Camiseta', categoria: 'superior', color: 'Negro',   talla: 'L',  marca: 'Trek',     imagenUrl: 'assets/ropa/camiseta_trek.jpg'),
    const Prenda(id: '18', nombre: 'Sudadera con Símbolo',          tipo: 'Sudadera', categoria: 'superior', color: 'Negro',   talla: 'L',  marca: 'Genérico', imagenUrl: 'assets/ropa/sudadera_simbolo.jpg'),
    // Inferiores
    const Prenda(id: '19', nombre: 'Bermuda Azul',        tipo: 'Short',    categoria: 'inferior', color: 'Azul',   talla: 'M', marca: 'Genérico', imagenUrl: 'assets/ropa/bermuda_azul.jpg'),
    const Prenda(id: '20', nombre: 'Chándal Gris',        tipo: 'Chándal',  categoria: 'inferior', color: 'Gris',   talla: 'M', marca: 'Genérico', imagenUrl: 'assets/ropa/chandal_gris.jpg'),
    const Prenda(id: '21', nombre: 'Chándal Negro',       tipo: 'Chándal',  categoria: 'inferior', color: 'Negro',  talla: 'M', marca: 'Genérico', imagenUrl: 'assets/ropa/chandal_negro.jpg'),
    const Prenda(id: '22', nombre: 'Chándal Negro Nike',  tipo: 'Chándal',  categoria: 'inferior', color: 'Negro',  talla: 'L', marca: 'Nike',     imagenUrl: 'assets/ropa/chandal_negro2.jpg'),
    const Prenda(id: '23', nombre: 'Pantalón Blanco',     tipo: 'Pantalón', categoria: 'inferior', color: 'Blanco', talla: 'M', marca: 'Genérico', imagenUrl: 'assets/ropa/pantalon_blanco.jpg'),
    const Prenda(id: '24', nombre: 'Pantalón Cargo Azul', tipo: 'Pantalón', categoria: 'inferior', color: 'Azul',   talla: 'L', marca: 'Genérico', imagenUrl: 'assets/ropa/pantalon_cargo_azul.jpg'),
    const Prenda(id: '25', nombre: 'Pantalón Cargo Gris', tipo: 'Pantalón', categoria: 'inferior', color: 'Gris',   talla: 'L', marca: 'Genérico', imagenUrl: 'assets/ropa/pantalon_cargo_gris.jpg'),
    const Prenda(id: '26', nombre: 'Pantalón Dickies',    tipo: 'Pantalón', categoria: 'inferior', color: 'Negro',  talla: 'M', marca: 'Dickies',  imagenUrl: 'assets/ropa/pantalon_dickies.jpg'),
    const Prenda(id: '27', nombre: 'Pantalón Negro',      tipo: 'Pantalón', categoria: 'inferior', color: 'Negro',  talla: 'M', marca: 'Genérico', imagenUrl: 'assets/ropa/pantalon_negro.jpg'),
    const Prenda(id: '28', nombre: 'Pantalón Negro 2',    tipo: 'Pantalón', categoria: 'inferior', color: 'Negro',  talla: 'S', marca: 'Genérico', imagenUrl: 'assets/ropa/pantalon_negro2.jpg'),
    const Prenda(id: '29', nombre: 'Vaquero Biker',       tipo: 'Vaquero',  categoria: 'inferior', color: 'Azul',   talla: 'M', marca: 'Bershka',  imagenUrl: 'assets/ropa/vaquero_biker.jpg'),
    // Calzado
    const Prenda(id: '30', nombre: 'Zapatilla Azul Skechers', tipo: 'Zapatilla', categoria: 'calzado', color: 'Azul',   talla: '42', marca: 'Skechers', imagenUrl: 'assets/ropa/zapatilla_azul_skechers.jpg'),
    const Prenda(id: '31', nombre: 'Zapatilla Azul Slip-on',  tipo: 'Zapatilla', categoria: 'calzado', color: 'Azul',   talla: '41', marca: 'Genérico', imagenUrl: 'assets/ropa/zapatilla_azul_slipon.jpg'),
    const Prenda(id: '32', nombre: 'Zapatilla Blanca',        tipo: 'Zapatilla', categoria: 'calzado', color: 'Blanco', talla: '42', marca: 'Genérico', imagenUrl: 'assets/ropa/zapatilla_blanca.jpg'),
    const Prenda(id: '33', nombre: 'Zapatilla Negra',         tipo: 'Zapatilla', categoria: 'calzado', color: 'Negro',  talla: '42', marca: 'Genérico', imagenUrl: 'assets/ropa/zapatilla_negra.jpg'),
    const Prenda(id: '34', nombre: 'Zapatilla Negra Fila',    tipo: 'Zapatilla', categoria: 'calzado', color: 'Negro',  talla: '42', marca: 'Fila',     imagenUrl: 'assets/ropa/zapatilla_negra_fila.jpg'),
    const Prenda(id: '35', nombre: 'Zapatilla Negra Slip-on', tipo: 'Zapatilla', categoria: 'calzado', color: 'Negro',  talla: '41', marca: 'Genérico', imagenUrl: 'assets/ropa/zapatilla_negra_slipon.jpg'),
    const Prenda(id: '36', nombre: 'Zapatilla Negra S',       tipo: 'Zapatilla', categoria: 'calzado', color: 'Negro',  talla: '40', marca: 'Genérico', imagenUrl: 'assets/ropa/zapatilla_negra_s.jpg'),
    const Prenda(id: '37', nombre: 'Zapatilla Salomon',       tipo: 'Zapatilla', categoria: 'calzado', color: 'Negro',  talla: '42', marca: 'Salomon',  imagenUrl: 'assets/ropa/zapatilla_salomon.jpg'),
    const Prenda(id: '38', nombre: 'Zapato Casual',           tipo: 'Zapato',    categoria: 'calzado', color: 'Negro',  talla: '42', marca: 'Genérico', imagenUrl: 'assets/ropa/zapato_casual.jpg'),
    const Prenda(id: '39', nombre: 'Zapato Formal',           tipo: 'Zapato',    categoria: 'calzado', color: 'Negro',  talla: '42', marca: 'Genérico', imagenUrl: 'assets/ropa/zapato_formal.jpg'),
    // Accesorios
    const Prenda(id: '40', nombre: 'Gafas Azul Cristalino', tipo: 'Gafas', categoria: 'accesorio', color: 'Azul',   talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/gafas_azul_cristalino.jpg'),
    const Prenda(id: '41', nombre: 'Gafas Negras',          tipo: 'Gafas', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/gafas_negras.jpg'),
    const Prenda(id: '42', nombre: 'Reloj Blanco',          tipo: 'Reloj', categoria: 'accesorio', color: 'Blanco', talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_blanco.jpg'),
    const Prenda(id: '43', nombre: 'Reloj L',               tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_L.jpg'),
    const Prenda(id: '44', nombre: 'Reloj Negro',           tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_negro.jpg'),
    const Prenda(id: '45', nombre: 'Reloj Para Salir',      tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_para_salir.jpg'),
    const Prenda(id: '46', nombre: 'Reloj Plata Moderno',   tipo: 'Reloj', categoria: 'accesorio', color: 'Plata',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_plata_moderno.jpg'),
    const Prenda(id: '47', nombre: 'Reloj tactil',          tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_tactil.jpg'),
    const Prenda(id: '48', nombre: 'Reloj Tecnológico',     tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_tecnologico.jpg'),
    const Prenda(id: '49', nombre: 'Reloj Militar',         tipo: 'Reloj', categoria: 'accesorio', color: 'Negro',  talla: 'Única', marca: 'Genérico', imagenUrl: 'assets/ropa/reloj_militar.jpg'),
  ];
}

class Categorias {
  static const List<String> todas = ['superior', 'inferior', 'calzado', 'accesorio'];
  static const Map<String, String> labels = {
    'superior': 'Superior', 'inferior': 'Inferior',
    'calzado': 'Calzado',   'accesorio': 'Accesorio',
  };
  static const Map<String, String> iconos = {
    'superior': '👕', 'inferior': '👖',
    'calzado':  '👟', 'accesorio': '⌚',
  };
}