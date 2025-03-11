// add the path_provider package in you pubspec.yaml file and import here
// this is only for backend

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// Getting the Application Document Directory for storing data
Future<String> _getAppDirectory() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } catch (e) {
    print("Could not access storage: $e");
    rethrow;
  }
}

// Write a list of String to a file
Future<void> writeToFile(String filename, List<String> data) async {
  final path = await _getAppDirectory();
  final file = File('$path/$filename');
  try {
    await file.writeAsString(data.join('\n'));
    print('Data is successfully write in $filename');
    // print('$data');
  }
  // on a specific error
  on FileSystemException catch (e) {
    print("FileSystemException: Error writing data to $filename: $e");
  }
  // on any error
  catch (e) {
    print('Error to write the data on $filename: $e');
  }
}

// Read the contents from the file and returns them as a list of String
Future<List<String>> readFromFile(String filename) async {
  final path = await _getAppDirectory();
  final file = File('$path/$filename');
  try {
    final contents = await file.readAsString();
    if (contents.isEmpty) {
      print("File not found or is empty");
    }
    return contents.split('\n');
  }
  // on specific error
  on FileSystemException catch (e) {
    print('FileSystemException: Error reading data from $filename: $e');
    return [];
  }
  // on any error
  catch (e) {
    print('Error to read the data from $filename: $e');
    return [];
  }
}

// Reverse each line from an input file and then writes to an output file
Future<void> processedFileData(
    String sourceFile, String destinationFile) async {
  try {
    final data = await readFromFile(sourceFile);
    if (data.isEmpty) {
      print("No data to process in $sourceFile");
      return;
    }
    final reversedData =
        data.map((content) => content.split('').reversed.join()).toList();
    await writeToFile(destinationFile, reversedData);
    print('Data is successfully reversed and stored in $destinationFile');
  } catch (e) {
    print(
        'Error occurred while reversing the content from $sourceFile to $destinationFile: $e');
  }
}

// app starts from here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // List of Strings
  final data = [
    "Social",
    "Swirl",
    "Company",
    "➡️",
    "laicoS",
    "lriwS",
    "ynapmoC",
  ];

  // Calling the writeToFile function to write data
  await writeToFile('sourceFile.txt', data);

  // Calling the readFromFile function to read data
  final readData = await readFromFile('sourceFile.txt');
  print('Read Data: $readData');

  // Calling processedFileData function to reversing the content and store in new file
  await processedFileData('sourceFile.txt', 'destinationFile.txt');

  // check the data in new file
  const filename = 'destinationFile.txt'; // try: 'sourceFile.txt'
  final processedData = await readFromFile(filename);
  print('Data in $filename: $processedData');
}
