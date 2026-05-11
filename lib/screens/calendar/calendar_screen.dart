import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../closet/prenda_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _searchCtrl = TextEditingController();
  String _busqueda  = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Prenda> get _resultados {
    if (_busqueda.isEmpty) return [];
    return PrendasData.prendas.where((p) {
      final q = _busqueda.toLowerCase();
      return p.nombre.toLowerCase().contains(q) ||
          p.tipo.toLowerCase().contains(q)       ||
          p.color.toLowerCase().contains(q)      ||
          p.marca.toLowerCase().contains(q)      ||
          p.categoria.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state      = context.watch<AppState>();
    final resultados = _resultados;

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: Column(
          children: [

            // ── Cabecera ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BÚSQUEDA',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 28, letterSpacing: 4, color: AppTheme.white,
                    ),
                  ),
                  Text('Encuentra cualquier prenda',
                    style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Barra de búsqueda ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(color: AppTheme.white),
                onChanged: (v) => setState(() => _busqueda = v),
                decoration: InputDecoration(
                  hintText: 'Buscar prendas...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.blue, size: 22),
                  suffixIcon: _busqueda.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.grey, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _busqueda = '');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: AppTheme.surface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.border, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.blue, width: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Resultados ─────────────────────────────────────
            Expanded(
              child: _busqueda.isEmpty
                  ? _PantallaSugerencias(
                onCategoria: (cat) {
                  _searchCtrl.text = cat;
                  setState(() => _busqueda = cat);
                },
                onTag: (tag) {
                  _searchCtrl.text = tag;
                  setState(() => _busqueda = tag);
                },
              )
                  : resultados.isEmpty
                  ? _SinResultados(busqueda: _busqueda)
                  : _ListaResultados(
                resultados: resultados,
                state: state,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pantalla inicial con sugerencias ──────────────────────────────────────
class _PantallaSugerencias extends StatelessWidget {
  final ValueChanged<String> onCategoria;
  final ValueChanged<String> onTag;

  const _PantallaSugerencias({
    required this.onCategoria,
    required this.onTag,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EXPLORAR POR CATEGORÍA',
            style: GoogleFonts.dmSans(
              fontSize: 11, letterSpacing: 2, color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 14),

          // ✅ Categorías clicables — buscan al tocar
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: Categorias.todas.map((cat) {
              return GestureDetector(
                onTap: () => onCategoria(cat),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Categorias.iconos[cat] ?? '👕',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Categorias.labels[cat] ?? '',
                        style: GoogleFonts.dmSans(
                          color: AppTheme.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          Text('BÚSQUEDAS RÁPIDAS',
            style: GoogleFonts.dmSans(
              fontSize: 11, letterSpacing: 2, color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Tags clicables — buscan al tocar
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Nike', 'Adidas', 'Rojo', 'Azul',
              'Negro', 'Blanco', 'M', 'L',
            ].map((tag) => GestureDetector(
              onTap: () => onTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.border, width: 0.5),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.dmSans(
                    color: AppTheme.greyLight, fontSize: 13,
                  ),
                ),
              ),
            )).toList(),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Lista de resultados ───────────────────────────────────────────────────
class _ListaResultados extends StatelessWidget {
  final List<Prenda> resultados;
  final AppState state;

  const _ListaResultados({required this.resultados, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '${resultados.length} resultado${resultados.length == 1 ? '' : 's'}',
            style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: resultados.length,
            itemBuilder: (_, i) {
              final p     = resultados[i];
              final esFav = state.esFavorito(p.id);

              // ✅ GestureDetector para abrir detalle al tocar
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrendaDetailScreen(prenda: p),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      // imagen o emoji
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: p.imagenUrl != null
                            ? Image.asset(
                          p.imagenUrl!,
                          width: 50, height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _EmojiBox(p.categoria),
                        )
                            : _EmojiBox(p.categoria),
                      ),
                      const SizedBox(width: 14),

                      // datos
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.nombre,
                              style: GoogleFonts.dmSans(
                                color: AppTheme.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.blue.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    p.tipo,
                                    style: GoogleFonts.dmSans(
                                      color: AppTheme.blue, fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${p.color} · ${p.marca}',
                                  style: GoogleFonts.dmSans(
                                    color: AppTheme.grey, fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // talla + favorito
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.ash2,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              p.talla,
                              style: GoogleFonts.dmSans(
                                color: AppTheme.goldWhite,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => state.toggleFavorito(p.id),
                            child: Icon(
                              esFav ? Icons.favorite : Icons.favorite_outline,
                              color: esFav ? AppTheme.red : AppTheme.grey,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Emoji placeholder ─────────────────────────────────────────────────────
class _EmojiBox extends StatelessWidget {
  final String categoria;
  const _EmojiBox(this.categoria);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, height: 50,
      decoration: BoxDecoration(
        color: AppTheme.ash2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          Categorias.iconos[categoria] ?? '👕',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// ── Sin resultados ────────────────────────────────────────────────────────
class _SinResultados extends StatelessWidget {
  final String busqueda;
  const _SinResultados({required this.busqueda});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text('Sin resultados para',
            style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text('"$busqueda"',
            style: GoogleFonts.bebasNeue(
              color: AppTheme.white, fontSize: 22, letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text('Prueba con otro término',
            style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}