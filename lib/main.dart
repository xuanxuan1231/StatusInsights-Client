import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'services/preferences_service.dart';

final preferencesService = PreferencesService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferencesService.init();

  if (_supportsDesktopTray()) {
    await _DesktopTrayController.instance.init(
      silentStartup: preferencesService.getSilentStartup() ?? false,
    );
  }

  runApp(const MyApp());
}

bool _supportsDesktopTray() {
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class _DesktopTrayController with WindowListener, TrayListener {
  _DesktopTrayController._();

  static final _DesktopTrayController instance = _DesktopTrayController._();
  bool _isQuitting = false;
  bool _isRestoringWindow = false;

  Future<void> init({required bool silentStartup}) async {
    await windowManager.ensureInitialized();
    windowManager.addListener(this);
    trayManager.addListener(this);
    await windowManager.setPreventClose(true);
    if (silentStartup) {
      await windowManager.waitUntilReadyToShow();
      await windowManager.hide();
    }

    await trayManager.setIcon(
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png',
    );
    if (defaultTargetPlatform == TargetPlatform.linux) {
      await trayManager.setTitle('StatusInsights');
    } else {
      try {
        await trayManager.setToolTip('StatusInsights');
      } on MissingPluginException {
        // Some platforms/plugins do not implement tooltip support.
      }
    }
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(key: 'show_window', label: 'Show'),
          MenuItem.separator(),
          MenuItem(key: 'exit_app', label: 'Exit'),
        ],
      ),
    );
  }

  @override
  void onWindowClose() async {
    if (_isQuitting) {
      return;
    }
    final closeToTray = preferencesService.getCloseToTray() ?? true;
    if (!closeToTray) {
      _quitApp();
      return;
    }
    await windowManager.hide();
  }

  @override
  void onTrayIconMouseDown() {
    if (defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }
    _restoreWindowFromTray();
  }

  @override
  void onTrayIconMouseUp() {
    if (defaultTargetPlatform != TargetPlatform.linux) {
      return;
    }
    _restoreWindowFromTray();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        _restoreWindowFromTray();
        return;
      case 'exit_app':
        _quitApp();
        return;
    }
  }

  Future<void> _restoreWindowFromTray() async {
    if (_isRestoringWindow) {
      return;
    }
    _isRestoringWindow = true;
    try {
      final isVisible = await windowManager.isVisible();
      if (!isVisible) {
        await windowManager.show();
      }
      await windowManager.focus();
    } finally {
      _isRestoringWindow = false;
    }
  }

  Future<void> _quitApp() async {
    _isQuitting = true;
    await trayManager.destroy();
    await windowManager.destroy();
  }
}
