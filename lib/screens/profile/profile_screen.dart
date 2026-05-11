import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

// Pantalla de perfil — muestra datos del usuario,
// estadísticas, favoritos y opciones de edición.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppTheme.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── Cabecera con avatar y datos ────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.blue.withOpacity(0.12),
                      AppTheme.black,
                    ],
                  ),
                ),
                child: Column(
                  children: [

                    // avatar con inicial o foto
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.surface,
                            border: Border.all(
                              color: AppTheme.blue,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.blue.withOpacity(0.3),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: state.fotoUrl != null
                                ? ClipOval(
                              child: Image.network(
                                state.fotoUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Text(
                              state.nombre.isNotEmpty
                                  ? state.nombre[0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 40,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                        // botón editar foto
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _editarPerfil(context, state),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppTheme.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.black,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: AppTheme.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // nombre de usuario
                    Text(
                      state.nombre.isEmpty ? 'Usuario' : state.nombre,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 28,
                        letterSpacing: 2,
                        color: AppTheme.white,
                      ),
                    ),

                    // username
                    Text(
                      state.username.isEmpty
                          ? ''
                          : '@${state.username}',
                      style: GoogleFonts.dmSans(
                        color: AppTheme.grey,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // email
                    Text(
                      state.email,
                      style: GoogleFonts.dmSans(
                        color: AppTheme.greyLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Estadísticas ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Row(
                  children: [
                    _StatPerfil(
                      valor: '${PrendasData.prendas.length}',
                      label: 'Prendas',
                      icon: Icons.checkroom_outlined,
                      color: AppTheme.blue,
                    ),
                    const SizedBox(width: 12),
                    _StatPerfil(
                      valor: '${state.favoritos.length}',
                      label: 'Favoritos',
                      icon: Icons.favorite_outline,
                      color: AppTheme.red,
                    ),
                    const SizedBox(width: 12),
                    _StatPerfil(
                      valor: state.talla.isEmpty ? '-' : state.talla,
                      label: 'Mi talla',
                      icon: Icons.straighten_outlined,
                      color: AppTheme.goldWhite,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Sección favoritos ──────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: AppTheme.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'MIS FAVORITOS',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 18,
                            letterSpacing: 3,
                            color: AppTheme.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // lista de favoritos
                    if (state.favoritos.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppTheme.border,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.favorite_outline,
                              color: AppTheme.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sin favoritos todavía',
                              style: GoogleFonts.dmSans(
                                color: AppTheme.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...state.favoritos.map((id) {
                        final prenda = PrendasData.prendas
                            .where((p) => p.id == id)
                            .firstOrNull;
                        if (prenda == null) return const SizedBox();
                        return _FavoritoTile(
                          prenda: prenda,
                          onQuitar: () => state.toggleFavorito(id),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Opciones de cuenta ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CUENTA',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        letterSpacing: 2,
                        color: AppTheme.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _OpcionTile(
                      icon: Icons.person_outline,
                      label: 'Editar perfil',
                      onTap: () => _editarPerfil(context, state),
                    ),
                    _OpcionTile(
                      icon: Icons.checkroom_outlined,
                      label: 'Gestionar ropa',
                      onTap: () {},
                    ),
                    _OpcionTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notificaciones',
                      onTap: () {},
                    ),
                    _OpcionTile(
                      icon: Icons.logout,
                      label: 'Cerrar sesión',
                      color: AppTheme.red,
                      onTap: () {
                        state.logout();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // modal para editar perfil
  void _editarPerfil(BuildContext context, AppState state) {
    final nombreCtrl   = TextEditingController(text: state.nombre);
    final usernameCtrl = TextEditingController(text: state.username);
    String tallaSelec  = state.talla.isEmpty ? 'M' : state.talla;

    final tallas = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.ash,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // handle
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
                'EDITAR PERFIL',
                style: GoogleFonts.bebasNeue(
                  fontSize: 22,
                  letterSpacing: 3,
                  color: AppTheme.white,
                ),
              ),

              const SizedBox(height: 20),

              // nombre
              TextField(
                controller: nombreCtrl,
                style: const TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),

              const SizedBox(height: 12),

              // username
              TextField(
                controller: usernameCtrl,
                style: const TextStyle(color: AppTheme.white),
                decoration: const InputDecoration(labelText: 'Username'),
              ),

              const SizedBox(height: 16),

              // talla
              Text(
                'TALLA',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: AppTheme.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: tallas.map((t) {
                  final sel = tallaSelec == t;
                  return GestureDetector(
                    onTap: () => setModal(() => tallaSelec = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.blue.withOpacity(0.2)
                            : AppTheme.surface2,
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
                          fontWeight: sel
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // guardar cambios
              ElevatedButton(
                onPressed: () {
                  state.actualizarPerfil(
                    nombre:   nombreCtrl.text.trim(),
                    username: usernameCtrl.text.trim(),
                    talla:    tallaSelec,
                  );
                  Navigator.pop(context);
                },
                child: const Text('GUARDAR CAMBIOS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────

class _StatPerfil extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color color;

  const _StatPerfil({
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
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              valor,
              style: GoogleFonts.bebasNeue(
                fontSize: 24,
                color: color,
                letterSpacing: 1,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritoTile extends StatelessWidget {
  final Prenda prenda;
  final VoidCallback onQuitar;

  const _FavoritoTile({
    required this.prenda,
    required this.onQuitar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Text(
            Categorias.iconos[prenda.categoria] ?? '👕',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prenda.nombre,
                  style: GoogleFonts.dmSans(
                    color: AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  prenda.marca,
                  style: GoogleFonts.dmSans(
                    color: AppTheme.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onQuitar,
            child: const Icon(
              Icons.favorite,
              color: AppTheme.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpcionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _OpcionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.dmSans(
                color: c,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppTheme.grey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}