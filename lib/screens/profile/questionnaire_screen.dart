import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {

  // ✅ Nombres distintos a las constantes para evitar conflicto
  String? _estiloSel;
  String? _coloresSel;
  String? _ocasionSel;
  String? _temperaturaSel;
  bool    _guardando = false;

  // Opciones de cada pregunta
  static const _opEstilos = [
    ('👕', 'Casual'),
    ('🏃', 'Deportivo'),
    ('👔', 'Formal'),
    ('🧢', 'Urbano'),
  ];

  static const _opColores = [
    ('🖤', 'Oscuros'),
    ('🤍', 'Claros'),
    ('🌈', 'Coloridos'),
    ('🎨', 'Mixtos'),
  ];

  static const _opOcasiones = [
    ('💼', 'Trabajo'),
    ('🛋️', 'Ocio'),
    ('⚽', 'Deporte'),
    ('🎉', 'Salir'),
  ];

  static const _opTemperaturas = [
    ('🥶', 'Frío'),
    ('🌤️', 'Templado'),
    ('☀️', 'Calor'),
    ('🌦️', 'Variable'),
  ];

  Future<void> _guardar() async {
    if (_estiloSel == null || _coloresSel == null ||
        _ocasionSel == null || _temperaturaSel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.surface,
          content: Text(
            'Responde todas las preguntas',
            style: GoogleFonts.dmSans(color: AppTheme.white),
          ),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    await context.read<AppState>().actualizarCuestionario(
      estilo:      _estiloSel!,
      colores:     _coloresSel!,
      ocasion:     _ocasionSel!,
      temperatura: _temperaturaSel!,
    );

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
                'Preferencias guardadas',
                style: GoogleFonts.dmSans(color: AppTheme.white),
              ),
            ],
          ),
        ),
      );
    }
    setState(() => _guardando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        title: const Text('MIS PREFERENCIAS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Cuéntanos tu estilo para mejorar las sugerencias del look del día.',
              style: GoogleFonts.dmSans(color: AppTheme.grey, fontSize: 13),
            ),

            const SizedBox(height: 32),

            _Pregunta(
              numero: '01',
              titulo: '¿Cuál es tu estilo favorito?',
              opciones: _opEstilos,
              seleccionado: _estiloSel,
              onSeleccionar: (v) => setState(() => _estiloSel = v),
            ),

            const SizedBox(height: 28),

            _Pregunta(
              numero: '02',
              titulo: '¿Qué colores prefieres?',
              opciones: _opColores,
              seleccionado: _coloresSel,
              onSeleccionar: (v) => setState(() => _coloresSel = v),
            ),

            const SizedBox(height: 28),

            _Pregunta(
              numero: '03',
              titulo: '¿Para qué ocasión sueles vestir?',
              opciones: _opOcasiones,
              seleccionado: _ocasionSel,
              onSeleccionar: (v) => setState(() => _ocasionSel = v),
            ),

            const SizedBox(height: 28),

            _Pregunta(
              numero: '04',
              titulo: '¿Qué temperatura suele hacer donde vives?',
              opciones: _opTemperaturas,
              seleccionado: _temperaturaSel,
              onSeleccionar: (v) => setState(() => _temperaturaSel = v),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _guardando ? null : _guardar,
              child: _guardando
                  ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppTheme.white,
                ),
              )
                  : const Text('GUARDAR PREFERENCIAS'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Widget de pregunta ────────────────────────────────────────────────────
class _Pregunta extends StatelessWidget {
  final String numero;
  final String titulo;
  final List<(String, String)> opciones;
  final String? seleccionado;
  final ValueChanged<String> onSeleccionar;

  const _Pregunta({
    required this.numero,
    required this.titulo,
    required this.opciones,
    required this.seleccionado,
    required this.onSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                numero,
                style: GoogleFonts.bebasNeue(
                  color: AppTheme.blue, fontSize: 14, letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                titulo,
                style: GoogleFonts.dmSans(
                  color: AppTheme.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.8,
          physics: const NeverScrollableScrollPhysics(),
          children: opciones.map((op) {
            final emoji = op.$1;
            final label = op.$2;
            final sel   = seleccionado == label;

            return GestureDetector(
              onTap: () => onSeleccionar(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: sel
                      ? AppTheme.blue.withOpacity(0.15)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? AppTheme.blue : AppTheme.border,
                    width: sel ? 1.5 : 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        color: sel ? AppTheme.blue : AppTheme.greyLight,
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}