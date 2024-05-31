import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';

class EmailNotVerifiedBanner extends StatefulWidget {
  const EmailNotVerifiedBanner({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<EmailNotVerifiedBanner> createState() => _EmailNotVerifiedBannerState();
}

class _EmailNotVerifiedBannerState extends State<EmailNotVerifiedBanner> {
  void _showBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        forceActionsBelow: true,
        content: const Text(
          'Your email is not verified. A verification email has been sent, Please verify your email.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  void _removeBanner() {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
  }

  @override
  void initState() {
    super.initState();

    final isEmailVerified = context.read<AppBloc>().state.user.isEmailVerified;

    if (!isEmailVerified) {
      scheduleMicrotask(() {
        _showBanner();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, curr) => prev.user != curr.user,
      listener: (context, state) {
        if (state.user.isEmailVerified) {
          _removeBanner();
        } else {
          _removeBanner();
          _showBanner();
        }
      },
      child: widget.child,
    );
  }
}
