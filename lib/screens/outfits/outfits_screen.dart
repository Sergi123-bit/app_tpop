import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  final List<Conjunto> _conjuntos = [
    const Conjunto(
      id: '1',
      nombre: 'Look Casual',
      prendaIds: ['1', '2', '3'],
      ocasion: 'casual',
    ),
    const Conjunto(
      id: '2',
      nombre: 'Outfit Deportivo',
      prendaIds: ['4', '6'],
      ocasion: 'deporte',
    ),
    const Conjunto(
      id: '3',
      nombre: 'Estilo Japonés',
      prendaIds: ['7', '2', '3'],
      ocasion: 'evento',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: Column(
          children: [

            // ── Cabecera ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Text(
                    'CONJUNTOS',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 28,
                      letterSpacing: 4,
                      color: AppTheme.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _crearConjunto(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.blue.withOpacity(0.4),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: AppTheme.blue, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Nuevo',
                            style: GoogleFonts.dmSans(
                              color: AppTheme.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '${_conjuntos.length} looks guardados',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Lista de conjuntos ─────────────────────────────────
            Expanded(
              child: _conjuntos.isEmpty
                  ? _SinConjuntos()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _conjuntos.length,
                itemBuilder: (_, i) => _TarjetaConjunto(
                  conjunto: _conjuntos[i],
                  onEliminar: () => setState(() => _conjuntos.removeAt(i)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _crearConjunto(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final Set<String> seleccionadas = {};

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.ash,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'NUEVO CONJUNTO',
                style: GoogleFonts.bebasNeue(
                  fontSize: 22,
                  letterSpacing: 3,
                  color: AppTheme.white,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: nombreCtrl,
                style: const TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(hintText: 'Nombre del conjunto'),
              ),

              const SizedBox(height: 16),

              Text(
                'SELECCIONA PRENDAS',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: AppTheme.grey,
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Lista de prendas con miniatura de imagen
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: PrendasData.prendas.length,
                  itemBuilder: (_, i) {
                    final p = PrendasData.prendas[i];
                    final sel = seleccionadas.contains(p.id);
                    return GestureDetector(
                      onTap: () => setModalState(() {
                        sel ? seleccionadas.remove(p.id) : seleccionadas.add(p.id);
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppTheme.blue.withOpacity(0.15)
                              : AppTheme.surface2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel ? AppTheme.blue : AppTheme.border,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // ✅ Miniatura real en lugar de emoji
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: p.imagenUrl != null
                                  ? Image.asset(
                                p.imagenUrl!,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _EmojiPlaceholder(p.categoria),
                              )
                                  : _EmojiPlaceholder(p.categoria),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                p.nombre,
                                style: GoogleFonts.dmSans(
                                  color: AppTheme.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            if (sel)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.blue,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  if (nombreCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _conjuntos.add(Conjunto(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: nombreCtrl.text.trim(),
                      prendaIds: seleccionadas.toList(),
                    ));
                  });
                  Navigator.pop(context);
                },
                child: const Text('GUARDAR CONJUNTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tarjeta de conjunto ───────────────────────────────────────────────────
class _TarjetaConjunto extends StatelessWidget {
  final Conjunto conjunto;
  final VoidCallback onEliminar;

  const _TarjetaConjunto({
    required this.conjunto,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final prendas = PrendasData.prendas
        .where((p) => conjunto.prendaIds.contains(p.id))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // cabecera
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    conjunto.nombre,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 20,
                      letterSpacing: 2,
                      color: AppTheme.white,
                    ),
                  ),
                ),
                if (conjunto.ocasion != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.blue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      conjunto.ocasion!,
                      style: GoogleFonts.dmSans(
                        color: AppTheme.blue,
                        fontSize: 11,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onEliminar,
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.grey,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Prendas con imagen real en scroll horizontal
          SizedBox(
            height: 100,
            child: prendas.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sin prendas asignadas',
                style: GoogleFonts.dmSans(
                  color: AppTheme.grey,
                  fontSize: 12,
                ),
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: prendas.length,
              itemBuilder: (_, i) {
                final p = prendas[i];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.ash2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // ✅ Imagen real con fallback a emoji
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: p.imagenUrl != null
                              ? Image.asset(
                            p.imagenUrl!,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _EmojiPlaceholder(p.categoria),
                          )
                              : _EmojiPlaceholder(p.categoria),
                        ),
                      ),
                      // nombre de la prenda debajo
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 4,
                        ),
                        child: Text(
                          p.tipo,
                          style: GoogleFonts.dmSans(
                            color: AppTheme.grey,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // pie
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                const Icon(
                  Icons.checkroom_outlined,
                  color: AppTheme.grey,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '${prendas.length} prendas',
                  style: GoogleFonts.dmSans(
                    color: AppTheme.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Widget reutilizable de fallback cuando la imagen no carga
class _EmojiPlaceholder extends StatelessWidget {
  final String categoria;
  const _EmojiPlaceholder(this.categoria);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: AppTheme.surface,
      child: Center(
        child: Text(
          Categorias.iconos[categoria] ?? '👕',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// pantalla vacía
class _SinConjuntos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👔', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            'Sin conjuntos todavía',
            style: GoogleFonts.dmSans(
              color: AppTheme.greyLight,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca "Nuevo" para crear tu primer look',
            style: GoogleFonts.dmSans(
              color: AppTheme.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}