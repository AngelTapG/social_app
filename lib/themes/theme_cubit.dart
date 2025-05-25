// Importamos los paquetes necesarios
import 'package:flutter/material.dart';          // Para los widgets y ThemeData
import 'package:flutter_bloc/flutter_bloc.dart'; // Para la gestión de estado con BLoC
import 'package:social_app_jose_gael/themes/dark_mode.dart';  // Importamos nuestro tema oscuro personalizado
import 'package:social_app_jose_gael/themes/light_mode.dart'; // Importamos nuestro tema claro personalizado

// Creamos una clase llamada ThemeCubit que extiende de Cubit<ThemeData>
// Esto significa que manejará estados de tipo ThemeData (nuestros temas)
class ThemeCubit extends Cubit<ThemeData> {
  // Variable privada para rastrear si el modo oscuro está activo
  // Inicia en false (tema claro por defecto)
  bool _isDarkMode = false;

  // Constructor del ThemeCubit que inicializa con el tema claro
  ThemeCubit() : super(lightMode);

  // Getter público para consultar si el modo oscuro está activo
  // (Pero no permite modificarlo directamente desde fuera)
  bool get isDarkMode => _isDarkMode;

  // Método para alternar entre temas claro y oscuro
  void toggleTheme() {
    // Invertimos el valor actual de _isDarkMode
    // (Si era true pasa a false y viceversa)
    _isDarkMode = !_isDarkMode;

    // Usamos una condición para decidir qué tema emitir
    if (isDarkMode) {
      // Si isDarkMode es true, emitimos el tema oscuro
      emit(darkMode);
    } else {
      // Si isDarkMode es false, emitimos el tema claro
      emit(lightMode);
    }
  }
}