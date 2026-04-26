import 'dart:io';

class WindowTitleService {
  /// Get the title of the current foreground/active window.
  /// Returns null if not available on this platform.
  static Future<String?> getActiveWindowTitle() async {
    try {
      if (Platform.isWindows) {
        return await _getWindowsActiveWindowTitle();
      } else if (Platform.isLinux) {
        return await _getLinuxActiveWindowTitle();
      } else if (Platform.isMacOS) {
        return await _getMacOSActiveWindowTitle();
      }
    } catch (_) {
      // Silently fail - window title is not critical
    }
    return null;
  }

  static Future<String?> _getWindowsActiveWindowTitle() async {
    try {
      // Use PowerShell to get the active window title
      final result = await Process.run(
        'powershell',
        [
          '-NonInteractive',
          '-NoProfile',
          '-Command',
          r'''
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder text, int count);
}
"@
$hwnd = [Win32]::GetForegroundWindow()
$sb = New-Object System.Text.StringBuilder 256
[Win32]::GetWindowText($hwnd, $sb, 256) | Out-Null
Write-Output $sb.ToString()
''',
        ],
        runInShell: false,
      );
      if (result.exitCode == 0) {
        final title = result.stdout.toString().trim();
        return title.isEmpty ? null : title;
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _getLinuxActiveWindowTitle() async {
    // Try xdotool first (X11)
    try {
      final idResult = await Process.run(
        'xdotool',
        ['getactivewindow'],
        runInShell: false,
      );
      if (idResult.exitCode == 0) {
        final windowId = idResult.stdout.toString().trim();
        final titleResult = await Process.run(
          'xdotool',
          ['getwindowname', windowId],
          runInShell: false,
        );
        if (titleResult.exitCode == 0) {
          final title = titleResult.stdout.toString().trim();
          return title.isEmpty ? null : title;
        }
      }
    } catch (_) {}

    // Try wmctrl as fallback
    try {
      final result = await Process.run(
        'wmctrl',
        ['-lp'],
        runInShell: false,
      );
      if (result.exitCode == 0) {
        final lines = result.stdout.toString().split('\n');
        // The active window is typically the first one with focus
        // This is a simplified approach - xdotool is more reliable
        if (lines.isNotEmpty && lines.first.trim().isNotEmpty) {
          final parts = lines.first.trim().split(RegExp(r'\s+'));
          if (parts.length >= 5) {
            return parts.sublist(4).join(' ');
          }
        }
      }
    } catch (_) {}

    return null;
  }

  static Future<String?> _getMacOSActiveWindowTitle() async {
    try {
      final result = await Process.run(
        'osascript',
        [
          '-e',
          'tell application "System Events" to get name of first window of (first process whose frontmost is true)',
        ],
        runInShell: false,
      );
      if (result.exitCode == 0) {
        final title = result.stdout.toString().trim();
        return title.isEmpty ? null : title;
      }
    } catch (_) {}
    return null;
  }
}
