// Ignora errores de tipo "lint" (pequeñas advertencias de estilo de código).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opciones predefinidas para configurar Firebase en tu app.
/// 
/// Ejemplo de cómo usarlo:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  // Método que elige la configuración correcta dependiendo de dónde se ejecuta la app.
  static FirebaseOptions get currentPlatform {
    // Si la app se abre en un navegador web:
    if (kIsWeb) {
      return web; // Usa la configuración para web.
    }
    // Si es una app móvil o de escritorio, verifica el sistema operativo:
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // Configuración para Android.
      case TargetPlatform.iOS:
        return ios; // Configuración para iPhone/iPad.
      case TargetPlatform.macOS:
        // Si es macOS, muestra un error porque no está configurado.
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        // Error si es Windows (tampoco configurado).
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        // Error si es Linux (no configurado).
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        // Error para cualquier otro sistema no soportado.
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Configuración específica para la versión WEB de la app:
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCKQMa8gBp_paPtubp_yRTRKP3yCkqf6xw', // Clave para acceder a Firebase.
    appId: '1:599718907743:web:313afc8e66b2557f6eb0ea', // ID único de la app web.
    messagingSenderId: '599718907743', // ID para enviar notificaciones.
    projectId: 'socialappjosegael', // Nombre del proyecto en Firebase.
    authDomain: 'socialappjosegael.firebaseapp.com', // Dominio para autenticar usuarios.
    storageBucket: 'socialappjosegael.firebasestorage.app', // Almacenamiento de archivos (fotos, etc.).
    measurementId: 'G-0MVRB3CL62', // ID para medir estadísticas de uso.
  );

  // Configuración para la app en ANDROID:
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_1cSd_p4WnplE0Blo2skAWDSzUZ1TvwA', // Clave diferente para Android.
    appId: '1:599718907743:android:f47c25897af1883d6eb0ea', // ID único de la app en Android.
    messagingSenderId: '599718907743', // Mismo ID de notificaciones que en web.
    projectId: 'socialappjosegael', // Mismo proyecto.
    storageBucket: 'socialappjosegael.firebasestorage.app', // Mismo almacenamiento.
  );

  // Configuración para la app en iPhone/iPad (iOS):
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCEzKjwi_KvLtD5ZWukYCdKk0IgkMuxxA', // Clave diferente para iOS.
    appId: '1:599718907743:ios:01447f7daf7f6e526eb0ea', // ID único para iOS.
    messagingSenderId: '599718907743', // Mismo ID de notificaciones.
    projectId: 'socialappjosegael', // Mismo proyecto.
    storageBucket: 'socialappjosegael.firebasestorage.app', // Mismo almacenamiento.
    iosBundleId: 'com.example.socialAppJoseGael', // ID único de la app en la App Store de Apple.
  );
}