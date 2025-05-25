// Importamos todos los paquetes necesarios
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importamos los repositorios de Firebase para cada funcionalidad
import 'package:social_app_jose_gael/features/auth/data/firebase_auth_repo.dart';
import 'package:social_app_jose_gael/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_app_jose_gael/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_app_jose_gael/features/auth/presentation/pages/auth_page.dart';

// Importamos las páginas principales
import 'package:social_app_jose_gael/features/home/presentation/pages/home_page.dart';

// Importamos los repositorios y cubits para posts
import 'package:social_app_jose_gael/features/post/data/firebase_post_repo.dart';
import 'package:social_app_jose_gael/features/post/presentation/cubits/post_cubit.dart';

// Importamos los repositorios y cubits para perfiles
import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/cubits/profile_cubit.dart';
import 'package:social_app_jose_gael/features/profile/domain/data/presentation/pages/firebase_profile_repo.dart';

// Importamos los repositorios y cubits para búsqueda
import 'package:social_app_jose_gael/features/search/domain/data/firebase_search_repo.dart';
import 'package:social_app_jose_gael/features/search/presentation/cubits/search_cubit.dart';

// Importamos el repositorio para almacenamiento de archivos
import 'package:social_app_jose_gael/features/storage/data/firebase_storage_repo.dart';

// Importamos la gestión de temas
import 'package:social_app_jose_gael/themes/theme_cubit.dart';

/*
 * MyApp - Widget raíz de la aplicación
 * 
 * Configura:
 * 1. Todos los proveedores de estado (BLoCs/Cubits)
 * 2. La navegación inicial según autenticación
 * 3. El tema de la aplicación
 * 4. Los repositorios para comunicación con Firebase
 */
class MyApp extends StatelessWidget {
  // Instancia del repositorio de autenticación
  final firebaseAuthRepo = FirebaseAuthRepo();
  
  // Instancia del repositorio de perfiles
  final firebaseProfileRepo = FirebaseProfileRepo();
  
  // Instancia del repositorio de almacenamiento
  final firebaseStorageRepo = FirebaseStorageRepo();
  
  // Instancia del repositorio de publicaciones
  final firebasePostRepo = FirebasePostRepo();
  
  // Instancia del repositorio de búsqueda
  final firebaseSearchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider permite proveer múltiples cubits/blocs
    return MultiBlocProvider(
      providers: [
        // Proveedor para el cubit de autenticación
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo)
            ..checkAuth(), // Verifica el estado de autenticación al iniciar
        ),
        
        // Proveedor para el cubit de perfiles
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        
        // Proveedor para el cubit de publicaciones
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
            postRepository: firebasePostRepo,
            storageRepository: firebaseStorageRepo,
          ),
        ),
        
        // Proveedor para el cubit de búsqueda
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        
        // Proveedor para el cubit de temas
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) {
          // MaterialApp configura la aplicación principal
          return MaterialApp(
            debugShowCheckedModeBanner: false, // Oculta la banda de debug
            theme: currentTheme, // Usa el tema actual (claro/oscuro)
            
            // BlocConsumer para manejar el estado de autenticación
            home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, authState) {
                // Si el usuario NO está autenticado
                if (authState is Unauthenticated) {
                  return const AuthPage(); // Muestra página de login/registro
                }
                
                // Si el usuario SÍ está autenticado
                if (authState is Authenticated) {
                  return const HomePage(); // Muestra el home principal
                }
                
                // Estado intermedio (verificando)
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()), // Spinner de carga
                );
              },
              
              // Listener para manejar errores de autenticación
              listener: (context, state) {
                if (state is AuthError) {
                  // Muestra un mensaje emergente (snackbar) con el error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}