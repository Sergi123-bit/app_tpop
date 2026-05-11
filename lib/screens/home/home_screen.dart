import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../closet/closet_screen.dart';
import '../outfits/outfits_screen.dart';
import '../profile/profile_screen.dart';
import 'dashboard_screen.dart';
import '../calendar/calendar_screen.dart';

// Contenedor principal con navegación inferior.
// Cada pestaña mantiene su estado gracias a IndexedStack.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),  // inicio
    ClosetScreen(),     // mi ropa
    OutfitsScreen(),    // conjuntos
    CalendarScreen(),   // búsqueda
    ProfileScreen(),    // perfil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      body: IndexedStack(
        index: _tab,
        children: _screens,
      ),
      bottomNavigationBar: _BarraNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}

// ── Barra de navegación inferior ──────────────────────────────────────────
class _BarraNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BarraNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.ash,
        border: Border(
          top: BorderSide(color: AppTheme.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _TabItem(
                icon: Icons.home_outlined,
                iconSel: Icons.home,
                label: 'Inicio',
                index: 0,
                current: currentIndex,
                onTap: onTap,
              ),
              _TabItem(
                icon: Icons.checkroom_outlined,
                iconSel: Icons.checkroom,
                label: 'Ropa',
                index: 1,
                current: currentIndex,
                onTap: onTap,
              ),
              _TabItem(
                icon: Icons.style_outlined,
                iconSel: Icons.style,
                label: 'Conjuntos',
                index: 2,
                current: currentIndex,
                onTap: onTap,
              ),
              _TabItem(
                icon: Icons.search_outlined,
                iconSel: Icons.search,
                label: 'Búsqueda',
                index: 3,
                current: currentIndex,
                onTap: onTap,
              ),
              _TabItem(
                icon: Icons.person_outline,
                iconSel: Icons.person,
                label: 'Perfil',
                index: 4,
                current: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final IconData iconSel;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _TabItem({
    required this.icon,
    required this.iconSel,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // punto indicador arriba si está seleccionado
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: sel ? 20 : 0,
              height: 2,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppTheme.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              sel ? iconSel : icon,
              size: 24,
              color: sel ? AppTheme.blue : AppTheme.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: sel ? AppTheme.blue : AppTheme.grey,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}