import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'dart:io';
import 'package:favorite_places/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  File? _selectedImage;

  void _saveItem() {
    if(_formKey.currentState!.validate() || _selectedImage == null) {
      _formKey.currentState!.save();
      ref.read(userPlacesProvider.notifier).addPlace(_enteredTitle, _selectedImage!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(            
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  validator: (value) { //_formKey.currentState!.validate() sẽ chạy, trả về bool
                    if (value == null || value.isEmpty || value.length <= 1) {
                      return 'Errol, please try again!'; // trả về String khi sai
                    }
                    return null; // trả về null nếu không sai
                  },
                  onSaved: (newValue) {  // _formKey.currentState!.save(); sẽ chạy
                    _enteredTitle = newValue!;
                  },
                ),
                const SizedBox(height: 6),
                ImageInput(onPickImage: (image) {
                  _selectedImage = image;
                } ),
                const SizedBox(height: 6),
                const LocationInput(),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _saveItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Place'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
