import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../closet/prenda_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  // ✅ Callback para ir a la pestaña de búsqueda/calendario
  final VoidCallback onIrACalendario;

  const DashboardScreen({
    super.key,
    required this.onIrACalendario,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            // ── Cabecera ───────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hola,',
                            style: GoogleFonts.dmSans(
                              color: AppTheme.grey, fontSize: 14,
                            ),
                          ),
                          Text(
                            state.nombre.isEmpty ? 'Usuario' : state.nombre,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 32, letterSpacing: 2,
                              color: AppTheme.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.blue, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.blue.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          'assets/ropa/logo_del_Lobo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Línea decorativa ───────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.blue, AppTheme.red, Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),

            // ── Stats ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    _StatCard(
                      valor: '${PrendasData.prendas.length}',
                      label: 'Prendas',
                      icon: Icons.checkroom_outlined,
                      color: AppTheme.blue,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      valor: '${state.favoritos.length}',
                      label: 'Favoritos',
                      icon: Icons.favorite_outline,
                      color: AppTheme.red,
                    ),
                    const SizedBox(width: 12),
                    _StatCard(
                      valor: state.talla.isEmpty ? '-' : state.talla,
                      label: 'Mi talla',
                      icon: Icons.straighten_outlined,
                      color: AppTheme.goldWhite,
                    ),
                  ],
                ),
              ),
            ),

            // ── Calendario semanal título ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppTheme.blue, size: 16),
                    const SizedBox(width: 8),
                    Text('ESTA SEMANA',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18, letterSpacing: 3,
                        color: AppTheme.goldWhite,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onIrACalendario,
                      child: Text('Ver todo',
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
            ),

            // ── Calendario semanal ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                // ✅ Al tocar el calendario va a la pestaña de búsqueda
                child: GestureDetector(
                  onTap: onIrACalendario,
                  child: const _CalendarioSemanal(),
                ),
              ),
            ),

            // ── Look del día título ────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Row(
                  children: [
                    Text('LOOK DEL DÍA',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18, letterSpacing: 3,
                        color: AppTheme.goldWhite,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppTheme.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Look del día tarjeta ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const _LookDelDia(),
              ),
            ),

            // ── Añadidas recientemente título ──────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                child: Text('AÑADIDAS RECIENTEMENTE',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 18, letterSpacing: 3,
                    color: AppTheme.goldWhite,
                  ),
                ),
              ),
            ),

            // ── Scroll horizontal prendas ──────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: PrendasData.prendas.length > 5
                      ? 5
                      : PrendasData.prendas.length,
                  itemBuilder: (_, i) {
                    final p = PrendasData.prendas[i];
                    return _MiniPrenda(prenda: p);
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ── Calendario semanal ────────────────────────────────────────────────────
class _CalendarioSemanal extends StatelessWidget {
  const _CalendarioSemanal();
  static const _dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final hoy       = DateTime.now();
    final diaSemana = hoy.weekday;
    final lunes     = hoy.subtract(Duration(days: diaSemana - 1));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final dia   = lunes.add(Duration(days: i));
          final esHoy = dia.day   == hoy.day   &&
              dia.month == hoy.month &&
              dia.year  == hoy.year;

          return Expanded(
            child: Column(
              children: [
                Text(
                  _dias[i],
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: esHoy ? AppTheme.blue : AppTheme.grey,
                    fontWeight: esHoy ? FontWeight.w700 : FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: esHoy ? AppTheme.blue : Colors.transparent,
                    border: esHoy
                        ? null
                        : Border.all(color: AppTheme.border, width: 0.5),
                  ),
                  child: Center(
                    child: Text(
                      '${dia.day}',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: esHoy ? AppTheme.white : AppTheme.greyLight,
                        fontWeight: esHoy ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 4, height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: esHoy ? AppTheme.blue : Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Tarjeta de estadística ────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(valor,
              style: GoogleFonts.bebasNeue(
                fontSize: 26, color: color, letterSpacing: 1,
              ),
            ),
            Text(label,
              style: GoogleFonts.dmSans(
                fontSize: 10, color: AppTheme.grey, letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Look del día ──────────────────────────────────────────────────────────
class _LookDelDia extends StatelessWidget {
  const _LookDelDia();

  @override
  Widget build(BuildContext context) {
    final prenda = PrendasData.prendas.isNotEmpty
        ? PrendasData.prendas[DateTime.now().day % PrendasData.prendas.length]
        : null;

    return GestureDetector(
      onTap: prenda != null
          ? () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrendaDetailScreen(prenda: prenda),
        ),
      )
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border, width: 0.5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.blue.withOpacity(0.08), AppTheme.surface],
          ),
        ),
        child: prenda == null
            ? Center(
          child: Text('Añade prendas para ver tu look del día',
            style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 13),
          ),
        )
            : Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: prenda.imagenUrl != null
                  ? Image.asset(
                prenda.imagenUrl!,
                width: 70, height: 70,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 70, height: 70,
                color: AppTheme.ash2,
                child: const Icon(
                  Icons.checkroom,
                  color: AppTheme.goldWhite,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sugerencia del día',
                    style: GoogleFonts.dmSans(
                      color: AppTheme.grey, fontSize: 11, letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(prenda.nombre,
                    style: GoogleFonts.dmSans(
                      color: AppTheme.white,
                      fontSize: 16, fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(prenda.tipo,
                    style: GoogleFonts.dmSans(
                      color: AppTheme.blue, fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.grey),
          ],
        ),
      ),
    );
  }
}

// ── Mini prenda ───────────────────────────────────────────────────────────
class _MiniPrenda extends StatelessWidget {
  final Prenda prenda;
  const _MiniPrenda({required this.prenda});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrendaDetailScreen(prenda: prenda),
        ),
      ),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: prenda.imagenUrl != null
                    ? Image.asset(
                  prenda.imagenUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
                    : Container(
                  color: AppTheme.ash2,
                  child: const Center(
                    child: Icon(
                      Icons.checkroom_outlined,
                      color: AppTheme.goldWhite,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                prenda.nombre,
                style: GoogleFonts.dmSans(
                  fontSize: 10, color: AppTheme.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}