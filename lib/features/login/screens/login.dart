import 'package:flextras/flextras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/api/api_client.dart';
import '../../../services/auth_state.dart';
import '../../../utils/extensions.dart';
import '../../../widgets/button.dart';
import '../handler/google_sign_in.dart';
import '../models/login.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = useState(false);

    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    void onSettingsPressed() => context.push('/settings');

    Future<void> onLoginPressed() async {
      try {
        if (kDebugMode) {
          await ref.read(currentAuthStateProvider.notifier).login(Login(
                username: 'avat',
                password: 'avatpass',
              ));
        } else {
          await ref.read(currentAuthStateProvider.notifier).login(Login(
                username: usernameController.text,
                password: passwordController.text,
              ));
        }
      } on ApiClientException catch (e) {
        if (!context.mounted) return;
        context.showTextSnackBar(e.responseMessage ?? 'Login failed');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SeparatedColumn(
        padding: const EdgeInsets.all(24),
        separatorBuilder: () => const Gap(16),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () =>
                    isPasswordVisible.value = !isPasswordVisible.value,
              ),
            ),
            obscureText: !isPasswordVisible.value,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
          const Gap(8),
          AppButton(
            onPressed: onLoginPressed,
            label: 'Login',
          ),
          SizedBox(height: 0.02.sh),
          GoogleSignInButton(),
        ],
      ),
    );
  }
}
