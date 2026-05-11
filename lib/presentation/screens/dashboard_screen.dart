import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/fuel/fuel_cubit.dart';
import '../../logic/maintenance/maintenance_cubit.dart';
import 'add_record_screen.dart';
import 'fuel_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MaintenanceCubit>().fetchRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GearShift Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Trigger the sign out from the AuthCubit
              // The main.dart listener will automatically return back to Login
              context.read<AuthCubit>().signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_gas_station),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: context.read<FuelCubit>()),
                    ],
                    child: const FuelScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleProfile(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Maintenance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildMaintenanceList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<MaintenanceCubit>(),
                child: const AddRecordScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVehicleProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.blueGrey.shade800,
      width: double.infinity,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Vehicle',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            '2005 Daewoo Lanos 1.5L',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Mileage: 184,000 km',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceList() {
    return BlocBuilder<MaintenanceCubit, MaintenanceState>(
      builder: (context, state) {
        if (state is MaintenanceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MaintenanceError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is MaintenanceLoaded) {
          if (state.records.isEmpty) {
            return const Center(child: Text('No maintenance records yet.'));
          }
          return ListView.builder(
            itemCount: state.records.length,
            itemBuilder: (context, index) {
              final record = state.records[index];

              // Wrap the ListTile in a Dismissible for swipe-to-delete!
              return Dismissible(
                key: Key(record.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  context.read<MaintenanceCubit>().deleteRecord(record.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${record.title} deleted')),
                  );
                },
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.build)),
                  title: Text(record.title),
                  subtitle: Text(record.notes),
                  trailing: Text('\$${record.cost.toStringAsFixed(2)}'),
                  // ADD THIS onTap FUNCTION:
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<MaintenanceCubit>(),
                          child: AddRecordScreen(
                            existingRecord: record,
                          ), // Pass the record!
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
