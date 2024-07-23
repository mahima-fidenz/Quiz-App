import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/common/theme.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/providers/firebase_provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/past_quizzes_screen.dart';
import 'package:quiz_app/screens/quiz_completion_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: (context, state) {
        final isLoggedIn =
            Provider.of<FirebaseProvider>(context, listen: false).loggedIn;
        if (!isLoggedIn) {
          return '/sign-in';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              loginViewKey: UniqueKey(),
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.go('/sign-in');
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'quiz',
          builder: (context, state) => const QuizScreen(),
        ),
        GoRoute(
          path: 'pastquizzes',
          builder: (context, state) => const PastQuizzesScreen(),
        ),
        GoRoute(
          path: 'quizresult',
          builder: (context, state) {
            Map<String, dynamic> extra = state.extra as Map<String, int>;
            return QuizResultScreen(
              userScore: extra['userScore'],
              fullScore: extra['fullScore'],
            );
          },
        ),
      ],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
    create: (context) => FirebaseProvider(),
    builder: ((context, child) => const MainApp()),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quiz App',
      theme: appTheme,
      routerConfig: _router,
    );
  }
}
