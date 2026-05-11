import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/fuel_record.dart';
import '../../logic/fuel/fuel_cubit.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({Key? key}) : super(key: key);

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FuelCubit>().fetchFuelRecords();
  }

  void _showAddFuelDialog(BuildContext context) {
    final litersController = TextEditingController();
    final costController = TextEditingController();
    final odometerController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Fuel Record'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: litersController,
                decoration: const InputDecoration(labelText: 'Liters Filled'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: costController,
                decoration: const InputDecoration(labelText: 'Total Cost (\$)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: odometerController,
                decoration: const InputDecoration(
                  labelText: 'Current Odometer (km)',
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final record = FuelRecord(
                  id: '',
                  date: DateTime.now(),
                  liters: double.parse(litersController.text),
                  cost: double.parse(costController.text),
                  odometer: double.parse(odometerController.text),
                );
                context.read<FuelCubit>().addFuelRecord(record);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Tracker')),
      body: BlocBuilder<FuelCubit, FuelState>(
        builder: (context, state) {
          if (state is FuelLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is FuelError) return Center(child: Text(state.message));
          if (state is FuelLoaded) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.blueAccent.shade700,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Text(
                        'Average Fuel Economy',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        state.averageEfficiency > 0
                            ? '${state.averageEfficiency.toStringAsFixed(1)} L/100km'
                            : 'Need more data',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.local_gas_station,
                          color: Colors.blueGrey,
                        ),
                        title: Text('${record.liters} Liters'),
                        subtitle: Text('Odometer: ${record.odometer} km'),
                        trailing: Text('\$${record.cost.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFuelDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
