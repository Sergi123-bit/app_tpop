import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'prenda_detail_screen.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import 'add_prenda_screen.dart';
import '../../services/firestore_service.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> {
  String _busqueda = '';
  String? _categoria;
  final _searchCtrl       = TextEditingController();
  final _firestoreService = FirestoreService();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Prenda>>(
      stream: _firestoreService.prendasStream(),
      builder: (context, snapshot) {
        final todasPrendas = snapshot.data ?? [];

        final prendas = todasPrendas.where((p) {
          final coincideBusqueda = _busqueda.isEmpty ||
              p.nombre.toLowerCase().contains(_busqueda.toLowerCase()) ||
              p.tipo.toLowerCase().contains(_busqueda.toLowerCase()) ||
              p.marca.toLowerCase().contains(_busqueda.toLowerCase()) ||
              p.color.toLowerCase().contains(_busqueda.toLowerCase());
          final coincideCategoria =
              _categoria == null || p.categoria == _categoria;
          return coincideBusqueda && coincideCategoria;
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgColor(context),
          body: SafeArea(
            child: Column(
              children: [

                // ── Cabecera ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    children: [
                      Text(
                        'MI ROPA',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 28,
                          letterSpacing: 4,
                          color: AppTheme.textColor(context),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.blue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.blue.withOpacity(0.4),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${prendas.length} prendas',
                          style: GoogleFonts.dmSans(
                            color: AppTheme.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Barra de búsqueda ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchCtrl,
                    style: TextStyle(color: AppTheme.textColor(context)),
                    onChanged: (v) => setState(() => _busqueda = v),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, tipo, color...',
                      prefixIcon: Icon(Icons.search,
                          color: AppTheme.greyColor(context), size: 20),
                      suffixIcon: _busqueda.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.close,
                            color: AppTheme.greyColor(context), size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _busqueda = '');
                        },
                      )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Filtros por categoría ─────────────────────────────
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _ChipCategoria(
                        label: 'Todas',
                        selected: _categoria == null,
                        onTap: () => setState(() => _categoria = null),
                      ),
                      ...Categorias.todas.map((c) => _ChipCategoria(
                        label: '${Categorias.iconos[c]} ${Categorias.labels[c]}',
                        selected: _categoria == c,
                        onTap: () => setState(() =>
                        _categoria = _categoria == c ? null : c),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Estado de carga ───────────────────────────────────
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: AppTheme.blue),
                    ),
                  )
                else
                  Expanded(
                    child: prendas.isEmpty
                        ? _ArmarioVacio(
                      tieneFiltro:
                      _busqueda.isNotEmpty || _categoria != null,
                    )
                        : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: prendas.length,
                      itemBuilder: (_, i) =>
                          _TarjetaPrenda(prenda: prendas[i]),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPrendaScreen()),
            ),
            backgroundColor: AppTheme.blue,
            foregroundColor: AppTheme.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

// ── Chip de filtro ────────────────────────────────────────────────────────
class _ChipCategoria extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChipCategoria({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.blue.withOpacity(0.15)
              : AppTheme.surfaceColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.blue : AppTheme.borderColor(context),
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: selected ? AppTheme.blue : AppTheme.greyLightColor(context),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Tarjeta de prenda ─────────────────────────────────────────────────────
class _TarjetaPrenda extends StatelessWidget {
  final Prenda prenda;
  const _TarjetaPrenda({required this.prenda});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final esFav = state.esFavorito(prenda.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => PrendaDetailScreen(prenda: prenda)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppTheme.borderColor(context), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [

                  // ── Imagen ──────────────────────────────────────
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14)),
                    child: prenda.imagenUrl != null
                        ? Image.network(
                      prenda.imagenUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppTheme.ash2Color(context),
                          width: double.infinity,
                          height: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.blue,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.ash2Color(context),
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            Categorias.iconos[prenda.categoria] ?? '👕',
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    )
                        : Container(
                      color: AppTheme.ash2Color(context),
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: Text(
                          Categorias.iconos[prenda.categoria] ?? '👕',
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),

                  // ── Botón favorito ──────────────────────────────
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => state.toggleFavorito(prenda.id),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          esFav ? Icons.favorite : Icons.favorite_outline,
                          color: esFav ? AppTheme.red : AppTheme.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),

                  // ── Badge categoría ─────────────────────────────
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.blue.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        Categorias.labels[prenda.categoria] ?? '',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          color: AppTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prenda.nombre,
                    style: GoogleFonts.dmSans(
                      color: AppTheme.textColor(context),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(prenda.marca,
                          style: GoogleFonts.dmSans(
                              color: AppTheme.greyColor(context),
                              fontSize: 11)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.surface2Color(context),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          prenda.talla,
                          style: GoogleFonts.dmSans(
                            color: AppTheme.goldColor(context),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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

// ── Armario vacío ─────────────────────────────────────────────────────────
class _ArmarioVacio extends StatelessWidget {
  final bool tieneFiltro;
  const _ArmarioVacio({required this.tieneFiltro});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👕', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(
            tieneFiltro ? 'Sin resultados' : 'Tu armario está vacío',
            style: GoogleFonts.dmSans(
                color: AppTheme.greyLightColor(context), fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            tieneFiltro
                ? 'Prueba con otro filtro'
                : 'Toca + para añadir tu primera prenda',
            style: GoogleFonts.dmSans(
                color: AppTheme.greyColor(context), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
