import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

class PrendaDetailScreen extends StatefulWidget {
  final Prenda prenda;
  const PrendaDetailScreen({super.key, required this.prenda});

  @override
  State<PrendaDetailScreen> createState() => _PrendaDetailScreenState();
}

class _PrendaDetailScreenState extends State<PrendaDetailScreen> {
  final _descCtrl = TextEditingController();
  String _estado = 'Funciona';

  final List<String> _estados = ['Funciona', 'Desgastada', 'No funciona'];

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final p = widget.prenda;
    final esFav = state.esFavorito(p.id);

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: CustomScrollView(
        slivers: [

          // ── App Bar con imagen grande ──────────────────
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: AppTheme.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  esFav ? Icons.favorite : Icons.favorite_border,
                  color: esFav ? Colors.red : Colors.white,
                  size: 28,
                ),
                onPressed: () => state.toggleFavorito(p.id),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: p.imagenUrl != null
                  ? Image.asset(
                p.imagenUrl!,
                fit: BoxFit.contain,
              )
                  : Container(
                color: AppTheme.surface,
                child: const Icon(Icons.checkroom, size: 80, color: Colors.white24),
              ),
            ),
          ),

          // ── Contenido ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Nombre
                  Text(
                    p.nombre,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 32,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Marca
                  Text(
                    p.marca,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppTheme.grey,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Chips info
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoChip(label: p.tipo,      icon: Icons.checkroom),
                      _InfoChip(label: p.color,     icon: Icons.palette),
                      _InfoChip(label: 'Talla: ${p.talla}', icon: Icons.straighten),
                      _InfoChip(
                        label: p.categoria[0].toUpperCase() + p.categoria.substring(1),
                        icon: Icons.category,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  _Divider(),

                  // Favorito banner
                  if (esFav) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Esta prenda es uno de tus favoritos',
                            style: GoogleFonts.dmSans(color: Colors.red, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Descripción de uso
                  Text(
                    'Descripción de uso',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppTheme.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    style: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Ej: La uso para salir, para deporte...',
                      hintStyle: GoogleFonts.dmSans(color: Colors.white24, fontSize: 13),
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.blue, width: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Estado
                  Text(
                    'Estado de la prenda',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppTheme.grey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _estados.map((e) {
                      final selected = _estado == e;
                      Color color = e == 'Funciona'
                          ? Colors.green
                          : e == 'Desgastada'
                          ? Colors.orange
                          : Colors.red;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _estado = e),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? color.withOpacity(0.15) : AppTheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? color : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              e,
                              style: GoogleFonts.dmSans(
                                color: selected ? color : AppTheme.grey,
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.blue),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(color: Colors.white10, thickness: 1);
  }
}