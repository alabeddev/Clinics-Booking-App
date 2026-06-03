import 'package:clinics_booking/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:clinics_booking/screens/tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clinics_booking/providers/auth_provider.dart';
//import 'package:clinics_booking/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _isVisi = true;
  var _enteredName = '';
  var _enteredPhone = '';
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    final errorMessage = await ref
        .read(authProvider.notifier)
        .authenticate(
          isLogin: _isLogin,
          email: _enteredEmail.trim(),
          password: _enteredPassword.trim(),
          name: _enteredName.trim(),
          phone: _enteredPhone.trim(),
        );

    if (errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => TabScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticating = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_hospital_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.clinicManagementSystem,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24), //all(20),
                //elevation: 20,
                //color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isLogin
                              ? AppLocalizations.of(context)!.login
                              : AppLocalizations.of(context)!.createNewAccount,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        if (!_isLogin)
                          TextFormField(
                            //key: const ValueKey('name_field') ,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.fullName,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.pleaseEnterName;
                              }

                              if (value.trim().length < 3) {
                                return AppLocalizations.of(
                                  context,
                                )!.nameMinLength;
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredName = value!;
                            },
                          ),

                        if (!_isLogin) const SizedBox(height: 16),
                        if (!_isLogin)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(
                                context,
                              )!.phoneNumber,
                              prefixIcon: Icon(Icons.phone_android_outlined),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppLocalizations.of(
                                  context,
                                )!.pleaseEnterPhone;
                              }

                              if (value.trim().length != 9) {
                                return AppLocalizations.of(
                                  context,
                                )!.phoneLengthWarning;
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredPhone = value!;
                            },
                          ),
                        if (!_isLogin) const SizedBox(height: 13),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return AppLocalizations.of(
                                context,
                              )!.pleaseEnterValidEmail;
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        const SizedBox(height: 13),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isVisi = !_isVisi;
                                });
                              },
                              icon: Icon(
                                _isVisi
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: _isVisi,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.pleaseEnterPassword;
                            }

                            if (value.length < 6) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordMinLength;
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),

                        const SizedBox(height: 24),
                        /*if (isAuthenticating)
                                const CircularProgressIndicator(), */

                        //if (!isAuthenticating)
                        ElevatedButton(
                          onPressed: _submit,
                          child: isAuthenticating
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  _isLogin
                                      ? AppLocalizations.of(context)!.enter
                                      : AppLocalizations.of(
                                          context,
                                        )!.createAccount,
                                ),
                        ),
                        const SizedBox(height: 12),

                        if (!isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _form.currentState?.reset();
                              });
                            },
                            child: Text(
                              _isLogin
                                  ? AppLocalizations.of(
                                      context,
                                    )!.dontHaveAccount
                                  : AppLocalizations.of(
                                      context,
                                    )!.alreadyHaveAccount,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
