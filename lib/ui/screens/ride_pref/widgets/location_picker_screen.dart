import 'package:flutter/material.dart';

import '../../../../../services/locations_service.dart';
import '../../../theme/theme.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  String _search = '';
  @override
  Widget build(BuildContext context) {
    final filtered = LocationsService.availableLocations
        .where((loc) => loc.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();
        
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => _search = value),
          decoration: InputDecoration(
            hintText: 'Search city...',
            border: InputBorder.none,
            hintStyle: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
          ),
          autofocus: true,
        ),
        backgroundColor: BlaColors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final loc = filtered[index];
          return ListTile(
            leading: Icon(Icons.location_city, color: BlaColors.primary),
            title: Text(loc.name, style: BlaTextStyles.body),
            subtitle: Text(loc.country.name, style: BlaTextStyles.label),
            onTap: () => Navigator.pop(context, loc),
          );
        },
      ),
    );
  }
}
