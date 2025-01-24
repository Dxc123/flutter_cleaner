import 'dart:async';
import 'dart:io';

void main(List<String> args) async {
  print('Scanning current directory for Flutter projects...');

  final currentDir = Directory.current;

  // 获取所有 Flutter 项目
  final flutterProjects = await _findFlutterProjects(currentDir);

  if (flutterProjects.isEmpty) {
    print('No Flutter projects found in the current directory.');
    return;
  }

  print('\nFound ${flutterProjects.length} Flutter project(s). Starting cleaning...');

  // 并发清理所有项目
  await Future.wait(flutterProjects.map((project) => _cleanProjectAsync(project)));

  print('\nAll Flutter projects cleaned!');
}

/// 异步扫描目录中的所有 Flutter 项目
Future<List<Directory>> _findFlutterProjects(Directory dir) async {
  final projects = <Directory>[];

  await for (var entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is Directory && _isFlutterProject(entity)) {
      projects.add(entity);
    }
  }

  return projects;
}

/// 检查是否为 Flutter 项目
bool _isFlutterProject(Directory dir) {
  final pubspecFile = File('${dir.path}/pubspec.yaml');
  return pubspecFile.existsSync();
}

/// 异步清理 Flutter 项目
Future<void> _cleanProjectAsync(Directory dir) async {
  print('\nCleaning project: ${dir.path}');

  // 并发执行清理任务
  await Future.wait([
    _runFlutterCleanAsync(dir),
    _deleteCacheAsync(dir),
    _deleteBuildAsync(dir),
  ]);

  print('Project ${dir.path} cleaned successfully.');
}

/// 异步执行 flutter clean
Future<void> _runFlutterCleanAsync(Directory dir) async {
  print('Running flutter clean in ${dir.path}...');
  final flutterCommand = 'flutter';
  final processResult = await Process.run(
    flutterCommand,
    ['clean'],
    workingDirectory: dir.path,
  );

  if (processResult.exitCode == 0) {
    print('flutter clean completed for ${dir.path}.');
  } else {
    print('Failed to run flutter clean for ${dir.path}. Error: ${processResult.stderr}');
  }
}

/// 异步删除缓存文件夹
Future<void> _deleteCacheAsync(Directory dir) async {
  final cacheDir = Directory('${dir.path}/.dart_tool');
  if (await cacheDir.exists()) {
    print('Deleting cache folder: ${cacheDir.path}');
    await cacheDir.delete(recursive: true);
    print('Cache folder deleted.');
  }
}

/// 异步删除构建文件夹
Future<void> _deleteBuildAsync(Directory dir) async {
  final buildDir = Directory('${dir.path}/build');
  if (await buildDir.exists()) {
    print('Deleting build folder: ${buildDir.path}');
    await buildDir.delete(recursive: true);
    print('Build folder deleted.');
  }
}
