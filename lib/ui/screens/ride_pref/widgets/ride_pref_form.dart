import 'package:blabla/ui/widgets/display/bla_divider.dart';
import 'package:flutter/material.dart';

import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/date_time_util.dart';
import '../../../theme/theme.dart';
import '../../../widgets/actions/bla_button.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  DateTime departureDate = DateTime.now().add(const Duration(days: 1));
  Location? arrival;
  int requestedSeats = 1;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    // TODO
    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      departureDate = widget.initRidePref!.departureDate;
      arrival = widget.initRidePref!.arrival;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  bool get isValid => departure != null && arrival != null;

  void _switchLocation() {
    setState(() {
      final destination = departure;
      departure = arrival;
      arrival = destination;
    });
  }

  Future<void> _pickLocation(bool isDeparture) async {
    final selected = await Navigator.push(
      context,
      AnimationUtils.createBottomToTopRoute(const Scaffold()),
    );

    if (selected is Location) {
      setState(() {
        if (isDeparture) {
          departure = selected;
        } else {
          arrival = selected;
        }
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        departureDate = picked;
      });
    }
  }

  Future<void> _changeSeats() async {
    int tempSeats = requestedSeats;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Number of passengers"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 36),
                    color: BlaColors.primary,
                    onPressed: tempSeats > 1
                        ? () {
                            setDialogState(() => tempSeats--);
                          }
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "$tempSeats",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 36),
                    color: BlaColors.primary,
                    onPressed: tempSeats < 6
                        ? () {
                            setDialogState(() => tempSeats++);
                          }
                        : null,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => requestedSeats = tempSeats);
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _search() {
    if (!isValid) {
      return;
    }
    final pref = RidePref(
      departure: departure!,
      departureDate: departureDate,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );
    Navigator.pop(context, pref);
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLocationField(
                'Departure city',
                departure,
                () => _pickLocation(true),
              ),
            ),
            if (departure != null || arrival != null)
              IconButton(
                icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                onPressed: _switchLocation,
              ),
          ],
        ),
        const BlaDivider(),

        _buildLocationField(
          'Arrival city',
          arrival,
          () => _pickLocation(false),
        ),
        const BlaDivider(),

        _buildField(
          Icons.calendar_today,
          DateTimeUtils.formatDateTime(departureDate),
          'Date',
          _selectDate,
        ),
        const BlaDivider(),

        _buildField(
          Icons.people_outline,
          '$requestedSeats ${requestedSeats == 1 ? "passenger" : "passengers"}',
          'Passengers',
          _changeSeats,
        ),
        const SizedBox(height: BlaSpacings.l),
        BlaButton(text: "Search", onPressed: () {}, isPrimary: true),
        SizedBox(height: BlaSpacings.m),
      ],
    );
  }

  Widget _buildLocationField(
    String placeholder,
    Location? location,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(Icons.location_on, color: BlaColors.iconNormal),
      title: Text(
        location?.name ?? placeholder,
        style: BlaTextStyles.body.copyWith(
          color: location == null ? BlaColors.textLight : BlaColors.textNormal,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildField(
    IconData icon,
    String value,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: BlaColors.iconNormal),
      title: Text(value, style: BlaTextStyles.body),
      subtitle: Text(label, style: BlaTextStyles.label),
      onTap: onTap,
    );
  }
}
