import 'package:flutter/widgets.dart';
import 'theme.dart';

/// The top-level application widget for apps using Soflume UI.
///
/// Automatically equips your Flutter app with:
/// - A root [Navigator] and [Overlay] stack so that [showSofDialog], [showSofSheet],
///   and [showSofToast] work anywhere in the widget tree.
/// - Scoped [SoflumeTheme] inherited across all routes, modals, and overlays.
/// - Default [Directionality] and typography defaults.
/// - Native platform keyboard shortcuts and back-gesture dispatching.
class SoflumeApp extends StatelessWidget {
  const SoflumeApp({
    super.key,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.theme,
    this.textDirection = TextDirection.ltr,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US'), Locale('zh', 'CN')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : routeInformationProvider = null,
       routeInformationParser = null,
       routerDelegate = null,
       backButtonDispatcher = null;

  /// Creates a [SoflumeApp] that uses the [Router] instead of a [Navigator].
  const SoflumeApp.router({
    super.key,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.theme,
    this.textDirection = TextDirection.ltr,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US'), Locale('zh', 'CN')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  }) : navigatorKey = null,
       home = null,
       routes = const <String, WidgetBuilder>{},
       initialRoute = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = const <NavigatorObserver>[];

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? home;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final SoflumeThemeData? theme;
  final TextDirection textDirection;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;

  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? SoflumeThemeData.light();

    Widget appBuilder(BuildContext ctx, Widget? child) {
      final content = SoflumeTheme(
        data: effectiveTheme,
        child: Directionality(
          textDirection: textDirection,
          child: DefaultTextStyle(
            style: effectiveTheme.typography.body.copyWith(
              color: effectiveTheme.colors.contentPrimary,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      );
      return builder != null ? builder!(ctx, content) : content;
    }

    if (routerDelegate != null) {
      return WidgetsApp.router(
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate!,
        backButtonDispatcher: backButtonDispatcher,
        builder: appBuilder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        textStyle: effectiveTheme.typography.body.copyWith(
          color: effectiveTheme.colors.contentPrimary,
        ),
        color: effectiveTheme.colors.accent,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
      );
    }

    return WidgetsApp(
      navigatorKey: navigatorKey,
      navigatorObservers: navigatorObservers,
      initialRoute: initialRoute,
      routes: routes,
      home: home,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder pageContent) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => pageContent(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
      builder: appBuilder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      textStyle: effectiveTheme.typography.body.copyWith(
        color: effectiveTheme.colors.contentPrimary,
      ),
      color: effectiveTheme.colors.accent,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
    );
  }
}
