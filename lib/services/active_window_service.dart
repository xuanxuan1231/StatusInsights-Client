import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum WindowTitleBackend { auto, niri, hyprland, sway, x11, custom }

class ActiveWindowService {
  const ActiveWindowService({
    this.backend = WindowTitleBackend.auto,
    this.customCommand = '',
  });

  final WindowTitleBackend backend;
  final String customCommand;
  static const MethodChannel _androidWindowChannel = MethodChannel(
    'statusinsights/window_title',
  );

  static Future<bool> hasAndroidUsageStatsPermission() async {
    if (kIsWeb || !Platform.isAndroid) {
      return true;
    }
    try {
      final result = await _androidWindowChannel.invokeMethod<bool>(
        'hasUsageStatsPermission',
      );
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> openAndroidUsageAccessSettings() async {
    if (kIsWeb || !Platform.isAndroid) {
      return;
    }
    try {
      await _androidWindowChannel.invokeMethod<bool>('openUsageAccessSettings');
    } catch (_) {
      return;
    }
  }

  static WindowTitleBackend backendFromValue(String value) {
    switch (value) {
      case 'niri':
        return WindowTitleBackend.niri;
      case 'hyprland':
        return WindowTitleBackend.hyprland;
      case 'sway':
        return WindowTitleBackend.sway;
      case 'x11':
        return WindowTitleBackend.x11;
      case 'custom':
        return WindowTitleBackend.custom;
      default:
        return WindowTitleBackend.auto;
    }
  }

  static String backendToValue(WindowTitleBackend value) {
    switch (value) {
      case WindowTitleBackend.niri:
        return 'niri';
      case WindowTitleBackend.hyprland:
        return 'hyprland';
      case WindowTitleBackend.sway:
        return 'sway';
      case WindowTitleBackend.x11:
        return 'x11';
      case WindowTitleBackend.custom:
        return 'custom';
      case WindowTitleBackend.auto:
        return 'auto';
    }
  }

  Future<String> getForegroundWindowTitle() async {
    if (kIsWeb) {
      return 'Unknown';
    }
    final title = await _getForegroundWindowTitleInternal();
    return title == null || title.trim().isEmpty ? 'Unknown' : title.trim();
  }

  Future<String?> _getForegroundWindowTitleInternal() async {
    if (Platform.isWindows) {
      return _getWindowsForegroundTitle();
    }
    if (Platform.isAndroid) {
      return _getAndroidForegroundTitle();
    }
    if (Platform.isMacOS) {
      return _getMacOSForegroundTitle();
    }
    if (Platform.isLinux) {
      return _getLinuxForegroundTitle();
    }
    return null;
  }

  Future<String?> _getAndroidForegroundTitle() async {
    try {
      final result = await _androidWindowChannel.invokeMethod<String>(
        'getForegroundWindowTitle',
      );
      if (result == null || result.trim().isEmpty) {
        return null;
      }
      return result.trim();
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getWindowsForegroundTitle() async {
    const script = r'''
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public static class Win32 {
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
}
"@
$h = [Win32]::GetForegroundWindow()
$builder = New-Object System.Text.StringBuilder 1024
[void][Win32]::GetWindowText($h, $builder, $builder.Capacity)
$builder.ToString()
''';
    try {
      final result = await Process.run('powershell', [
        '-NoProfile',
        '-Command',
        script,
      ]).timeout(const Duration(seconds: 3));
      final text = (result.stdout as String).trim();
      return text.isEmpty ? null : text;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getLinuxForegroundTitle() async {
    final backendToUse = backend == WindowTitleBackend.auto
        ? _detectLinuxBackend()
        : backend;

    if (backendToUse == WindowTitleBackend.custom) {
      final customTitle = await _getCustomCommandTitle();
      if (customTitle != null && customTitle.isNotEmpty) {
        return customTitle;
      }
      return await _getFallbackLinuxTitle();
    }
    if (backendToUse == WindowTitleBackend.niri) {
      final title = await _getNiriFocusedWindowTitle();
      return title ?? await _getFallbackLinuxTitle();
    }
    if (backendToUse == WindowTitleBackend.hyprland) {
      final title = await _getHyprlandFocusedWindowTitle();
      return title ?? await _getFallbackLinuxTitle();
    }
    if (backendToUse == WindowTitleBackend.sway) {
      final title = await _getSwayFocusedWindowTitle();
      return title ?? await _getFallbackLinuxTitle();
    }
    if (backendToUse == WindowTitleBackend.x11) {
      return _getX11ForegroundTitle();
    }
    return _getFallbackLinuxTitle();
  }

  WindowTitleBackend _detectLinuxBackend() {
    final desktop = (Platform.environment['XDG_CURRENT_DESKTOP'] ?? '')
        .toLowerCase();
    if (desktop.contains('niri') ||
        Platform.environment['NIRI_SOCKET'] != null) {
      return WindowTitleBackend.niri;
    }
    if (desktop.contains('hyprland') ||
        Platform.environment['HYPRLAND_INSTANCE_SIGNATURE'] != null) {
      return WindowTitleBackend.hyprland;
    }
    if (desktop.contains('sway') || Platform.environment['SWAYSOCK'] != null) {
      return WindowTitleBackend.sway;
    }
    if (Platform.environment['DISPLAY'] != null) {
      return WindowTitleBackend.x11;
    }
    return WindowTitleBackend.niri;
  }

  Future<String?> _getFallbackLinuxTitle() async {
    final niri = await _getNiriFocusedWindowTitle();
    if (niri != null && niri.isNotEmpty) {
      return niri;
    }
    final hyprland = await _getHyprlandFocusedWindowTitle();
    if (hyprland != null && hyprland.isNotEmpty) {
      return hyprland;
    }
    final sway = await _getSwayFocusedWindowTitle();
    if (sway != null && sway.isNotEmpty) {
      return sway;
    }
    return _getX11ForegroundTitle();
  }

  Future<String?> _getNiriFocusedWindowTitle() async {
    try {
      final result = await Process.run('niri', [
        'msg',
        '--json',
        'focused-window',
      ]).timeout(const Duration(seconds: 3));

      if (result.exitCode != 0) {
        return null;
      }

      final text = (result.stdout as String).trim();
      if (text.isEmpty) {
        return null;
      }

      final dynamic json = jsonDecode(text);
      final title = _extractTitle(json);
      if (title != null && title.trim().isNotEmpty) {
        return title.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getHyprlandFocusedWindowTitle() async {
    try {
      final result = await Process.run('hyprctl', [
        'activewindow',
        '-j',
      ]).timeout(const Duration(seconds: 3));
      if (result.exitCode != 0) {
        return null;
      }
      final text = (result.stdout as String).trim();
      if (text.isEmpty) {
        return null;
      }
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) {
        final title = json['title'];
        if (title is String && title.trim().isNotEmpty) {
          return title.trim();
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getSwayFocusedWindowTitle() async {
    try {
      final result = await Process.run('swaymsg', [
        '-t',
        'get_tree',
      ]).timeout(const Duration(seconds: 3));
      if (result.exitCode != 0) {
        return null;
      }
      final text = (result.stdout as String).trim();
      if (text.isEmpty) {
        return null;
      }
      final json = jsonDecode(text);
      final focusedNode = _findFocusedNode(json);
      final title = _extractNodeTitle(focusedNode);
      if (title != null && title.trim().isNotEmpty) {
        return title.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  dynamic _findFocusedNode(dynamic node) {
    if (node is Map<String, dynamic>) {
      if (node['focused'] == true) {
        return node;
      }
      final nodes = node['nodes'];
      if (nodes is List) {
        for (final child in nodes) {
          final found = _findFocusedNode(child);
          if (found != null) {
            return found;
          }
        }
      }
      final floatingNodes = node['floating_nodes'];
      if (floatingNodes is List) {
        for (final child in floatingNodes) {
          final found = _findFocusedNode(child);
          if (found != null) {
            return found;
          }
        }
      }
    }
    return null;
  }

  String? _extractNodeTitle(dynamic node) {
    if (node is! Map<String, dynamic>) {
      return null;
    }
    final name = node['name'];
    if (name is String && name.trim().isNotEmpty) {
      return name;
    }
    final props = node['window_properties'];
    if (props is Map<String, dynamic>) {
      final title = props['title'];
      if (title is String && title.trim().isNotEmpty) {
        return title;
      }
    }
    return null;
  }

  Future<String?> _getX11ForegroundTitle() async {
    try {
      final activeResult = await Process.run('xprop', [
        '-root',
        '_NET_ACTIVE_WINDOW',
      ]).timeout(const Duration(seconds: 3));
      final activeText = (activeResult.stdout as String).trim();
      final match = RegExp(r'0x[0-9a-fA-F]+').firstMatch(activeText);
      if (match == null) {
        return null;
      }
      final windowId = match.group(0)!;
      final titleResult = await Process.run('xprop', [
        '-id',
        windowId,
        'WM_NAME',
      ]).timeout(const Duration(seconds: 3));
      final titleText = (titleResult.stdout as String).trim();
      final titleMatch = RegExp(r'=\s*"(.+)"').firstMatch(titleText);
      if (titleMatch != null && titleMatch.groupCount >= 1) {
        final title = titleMatch.group(1)!.trim();
        if (title.isNotEmpty) {
          return title;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _getCustomCommandTitle() async {
    final command = customCommand.trim();
    if (command.isEmpty) {
      return null;
    }
    try {
      final result = await Process.run('bash', [
        '-lc',
        command,
      ]).timeout(const Duration(seconds: 3));
      if (result.exitCode != 0) {
        return null;
      }
      final output = (result.stdout as String).trim();
      return output.isEmpty ? null : output;
    } catch (_) {
      return null;
    }
  }

  String? _extractTitle(dynamic data) {
    if (data is Map<String, dynamic>) {
      final titleValue = data['title'];
      if (titleValue is String && titleValue.trim().isNotEmpty) {
        return titleValue;
      }
      for (final value in data.values) {
        final nested = _extractTitle(value);
        if (nested != null && nested.trim().isNotEmpty) {
          return nested;
        }
      }
    } else if (data is List) {
      for (final item in data) {
        final nested = _extractTitle(item);
        if (nested != null && nested.trim().isNotEmpty) {
          return nested;
        }
      }
    }
    return null;
  }

  Future<String?> _getMacOSForegroundTitle() async {
    const script =
        'tell application "System Events" to tell (first process whose frontmost is true) to get name of front window';
    try {
      final result = await Process.run('osascript', ['-e', script]).timeout(
        const Duration(seconds: 3),
      );
      final text = (result.stdout as String).trim();
      return text.isEmpty ? null : text;
    } catch (_) {
      return null;
    }
  }
}
