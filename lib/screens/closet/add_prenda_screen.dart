import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../services/firestore_service.dart';

class AddPrendaScreen extends StatefulWidget {
  const AddPrendaScreen({super.key});

  @override
  State<AddPrendaScreen> createState() => _AddPrendaScreenState();
}

class _AddPrendaScreenState extends State<AddPrendaScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _marcaCtrl  = TextEditingController();
  final _colorCtrl  = TextEditingController();

  String _tipo      = 'Camiseta';
  String _categoria = 'superior';
  String _talla     = 'M';
  bool   _guardando = false;

  static const _tipos = [
    'Camiseta', 'Camisa', 'Polo', 'Sudadera', 'Chaqueta', 'Abrigo',
    'Pantalón', 'Vaquero', 'Short', 'Chándal',
    'Zapatilla', 'Zapato', 'Bota', 'Sandalia',
    'Cinturón', 'Gorra', 'Bufanda', 'Reloj',
  ];

  static const _tallas = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL',
    '28', '30', '32', '34', '36', '38', '40', '42', '44',
    'Única',
  ];

  String _categoriaParaTipo(String tipo) {
    const superiores = ['Camiseta', 'Camisa', 'Polo', 'Sudadera', 'Chaqueta', 'Abrigo'];
    const inferiores = ['Pantalón', 'Vaquero', 'Short', 'Chándal'];
    const calzado    = ['Zapatilla', 'Zapato', 'Bota', 'Sandalia'];
    if (superiores.contains(tipo)) return 'superior';
    if (inferiores.contains(tipo)) return 'inferior';
    if (calzado.contains(tipo))    return 'calzado';
    return 'accesorio';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final nueva = Prenda(
      id:        const Uuid().v4(),
      nombre:    _nombreCtrl.text.trim(),
      tipo:      _tipo,
      categoria: _categoria,
      color:     _colorCtrl.text.trim(),
      talla:     _talla,
      marca:     _marcaCtrl.text.trim(),
    );

    try {
      await FirestoreService().addPrenda(nueva);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.surface,
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppTheme.blue, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Prenda añadida correctamente',
                  style: GoogleFonts.dmSans(color: AppTheme.white),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }

    setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        title: const Text('NUEVA PRENDA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _guardando ? null : _guardar,
            child: _guardando
                ? const SizedBox(
              width: 18, height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2, color: AppTheme.blue,
              ),
            )
                : Text(
              'GUARDAR',
              style: GoogleFonts.dmSans(
                color: AppTheme.blue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Foto ──────────────────────────────────────────
              Center(
                child: Container(
                  width: 140, height: 180,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.blue.withOpacity(0.4), width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_photo_alternate_outlined,
                          color: AppTheme.blue, size: 40),
                      const SizedBox(height: 8),
                      Text('Añadir foto',
                          style: GoogleFonts.dmSans(
                              color: AppTheme.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Nombre ────────────────────────────────────────
              _Etiqueta('NOMBRE'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreCtrl,
                style: const TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(
                    hintText: 'Ej: Camiseta Selección Española'),
                validator: (v) =>
                v!.isEmpty ? 'El nombre es obligatorio' : null,
              ),

              const SizedBox(height: 20),

              // ── Tipo ──────────────────────────────────────────
              _Etiqueta('TIPO'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _tipo,
                dropdownColor: AppTheme.surface2,
                style: const TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(),
                items: _tipos
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _tipo      = v!;
                  _categoria = _categoriaParaTipo(v);
                }),
              ),

              const SizedBox(height: 20),

              // ── Categoría (automática) ────────────────────────
              _Etiqueta('CATEGORÍA'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.blue.withOpacity(0.4), width: 0.5),
                ),
                child: Row(
                  children: [
                    Text(
                      '${Categorias.iconos[_categoria]}  ${Categorias.labels[_categoria]}',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text('Auto',
                        style: GoogleFonts.dmSans(
                            color: AppTheme.grey, fontSize: 11)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Color y Marca ─────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Etiqueta('COLOR'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _colorCtrl,
                          style: const TextStyle(color: AppTheme.white),
                          decoration: const InputDecoration(hintText: 'Ej: Rojo'),
                          validator: (v) =>
                          v!.isEmpty ? 'Obligatorio' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Etiqueta('MARCA'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _marcaCtrl,
                          style: const TextStyle(color: AppTheme.white),
                          decoration: const InputDecoration(hintText: 'Ej: Nike'),
                          validator: (v) =>
                          v!.isEmpty ? 'Obligatorio' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Talla ─────────────────────────────────────────
              _Etiqueta('TALLA'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _tallas.map((t) {
                  final sel = _talla == t;
                  return GestureDetector(
                    onTap: () => setState(() => _talla = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                          fontSize: 13,
                          fontWeight: sel
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // ── Botón guardar ─────────────────────────────────
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppTheme.white,
                  ),
                )
                    : const Text('GUARDAR PRENDA'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String text;
  const _Etiqueta(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        letterSpacing: 2,
        color: AppTheme.grey,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}