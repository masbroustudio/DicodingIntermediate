import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/network/response_call.dart';
import '../../providers/register_provider.dart';
import '../../utils/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  static const path = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputName = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  TextEditingController inputRepeatPassword = TextEditingController();

  bool isObsecure = true;
  bool isRepeatObsecure = true;

  void _handleRegister() async {
    if (!formKey.currentState!.validate()) return;

    final registerProvider = context.read<RegisterProvider>();

    final isRegisterComplete = await registerProvider.register(
      name: inputName.text.trim(),
      email: inputEmail.text.trim(),
      password: inputRepeatPassword.text.trim(),
    );

    if (!isRegisterComplete) {
      Fluttertoast.showToast(
          msg: registerProvider.responseCall.message.toString());
      return;
    }

    if (mounted) {
      Fluttertoast.showToast(msg: "Register Success");
      context.pop();
    }
  }

  void _toggleObsecure() {
    setState(() {
      isObsecure = !isObsecure;
    });
  }

  void _toggleRepeatObsecure() {
    setState(() {
      isRepeatObsecure = !isRepeatObsecure;
    });
  }

  @override
  void dispose() {
    inputName.dispose();
    inputEmail.dispose();
    inputPassword.dispose();
    inputRepeatPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleRegister),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(AppLocalizations.of(context)!.textRegisterDescription),
            const SizedBox(height: 16),
            TextFormField(
              controller: inputName,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textName,
                hintText: AppLocalizations.of(context)!.textName,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textRequired;
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: inputEmail,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textEmail,
                hintText: AppLocalizations.of(context)!.textEmail,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textRequired;
                }

                if (!checkValidEmail(value)) {
                  return AppLocalizations.of(context)!.textInvalidEmail;
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: inputPassword,
              obscureText: isObsecure,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textPassword,
                hintText: AppLocalizations.of(context)!.textPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                      isObsecure ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggleObsecure,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textRequired;
                }

                if (value.length < 8) {
                  return AppLocalizations.of(context)!.textInvalidPassword;
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: inputRepeatPassword,
              obscureText: isRepeatObsecure,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textRepeatPassword,
                hintText: AppLocalizations.of(context)!.textRepeatPassword,
                suffixIcon: IconButton(
                  icon: Icon(isRepeatObsecure
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleRepeatObsecure,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.textRequired;
                }

                if (value.length < 8) {
                  return AppLocalizations.of(context)!.textInvalidPassword;
                }

                if (value != inputPassword.text) {
                  return AppLocalizations.of(context)!
                      .textInvalidRepeatPassword;
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            Consumer<RegisterProvider>(
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value.responseCall.status == Status.loading
                      ? () {}
                      : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: value.responseCall.status == Status.loading
                        ? Colors.grey
                        : Colors.blue,
                  ),
                  child: Text(AppLocalizations.of(context)!.titleRegister),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
