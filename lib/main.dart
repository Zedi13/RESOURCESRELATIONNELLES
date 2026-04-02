import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

import 'features/resources/data/datasources/resources_local_datasource.dart';
import 'features/resources/data/repositories/resources_repository_impl.dart';
import 'features/resources/presentation/providers/resources_provider.dart';

import 'features/progression/data/datasources/progression_local_datasource.dart';
import 'features/progression/data/repositories/progression_repository_impl.dart';
import 'features/progression/presentation/providers/progression_provider.dart';

import 'features/comments/data/datasources/comments_local_datasource.dart';
import 'features/comments/data/repositories/comments_repository_impl.dart';
import 'features/comments/presentation/providers/comments_provider.dart';

import 'features/statistics/data/datasources/statistics_local_datasource.dart';
import 'features/statistics/data/repositories/statistics_repository_impl.dart';
import 'features/statistics/presentation/providers/statistics_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final authDatasource = AuthLocalDatasource();
  final authRepo = AuthRepositoryImpl(authDatasource);
  final authProvider = AuthProvider(authRepo);

  final resourcesDatasource = ResourcesLocalDatasource();
  final resourcesRepo = ResourcesRepositoryImpl(resourcesDatasource);
  final resourcesProvider = ResourcesProvider(resourcesRepo);

  final progressionDatasource = ProgressionLocalDatasource();
  final progressionRepo = ProgressionRepositoryImpl(progressionDatasource);
  final progressionProvider = ProgressionProvider(progressionRepo);

  final commentsDatasource = CommentsLocalDatasource();
  final commentsRepo = CommentsRepositoryImpl(commentsDatasource);
  final commentsProvider = CommentsProvider(commentsRepo);

  final statisticsDatasource = StatisticsLocalDatasource();
  final statisticsRepo = StatisticsRepositoryImpl(statisticsDatasource);
  final statisticsProvider = StatisticsProvider(statisticsRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: resourcesProvider),
        ChangeNotifierProvider.value(value: progressionProvider),
        ChangeNotifierProvider.value(value: commentsProvider),
        ChangeNotifierProvider.value(value: statisticsProvider),
      ],
      child: App(authProvider: authProvider),
    ),
  );
}

class App extends StatefulWidget {
  final AuthProvider authProvider;

  const App({super.key, required this.authProvider});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = createRouter(widget.authProvider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '(RE)Sources Relationnelles',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
