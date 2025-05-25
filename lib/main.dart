// Importamos los paquetes necesarios
import 'package:firebase_core/firebase_core.dart';  // Para integrar Firebase
import 'package:flutter/material.dart';              // Para los widgets básicos de Flutter
import 'package:social_app_jose_gael/config/firebase_options.dart';  // Configuración específica de Firebase para esta app
import 'app.dart';                                   // Importamos la clase MyApp que contiene la aplicación principal

/*
 * Función principal - Punto de entrada de la aplicación
 * 
 * El modificador 'async' indica que esta función contiene operaciones asíncronas
 * (que toman tiempo en completarse, como inicializar Firebase)
 */
void main() async {
  // 1. Inicialización obligatoria de Flutter
  // ----------------------------------------
  // Asegura que Flutter esté listo antes de hacer cualquier cosa
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Configuración de Firebase
  // ----------------------------
  // Inicializa Firebase con las opciones específicas para cada plataforma
  // (Android, iOS, web, etc.) definidas en firebase_options.dart
  // El 'await' espera a que esta operación se complete antes de continuar
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Lanzamiento de la aplicación
  // ------------------------------
  // Ejecuta la aplicación usando MyApp como widget raíz
  runApp(MyApp());
}

/*
 * Nota: La clase MyApp está definida en el archivo app.dart que importamos
 * Contiene toda la configuración de:
 * - Gestión de estado (BLoCs/Cubits)
 * - Navegación
 * - Temas
 * - Proveedores de servicios
 */