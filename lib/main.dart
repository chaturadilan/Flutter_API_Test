import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

var genderProvider = StateProvider((ref) => "");

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final dio = Dio();
  final nameTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var gender = ref.watch(genderProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameTextEditController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var name = nameTextEditController.value.text;
                    final response = await dio.get(
                        'https://api.genderize.io/?name=$name&country_id=US');

                    ref.read(genderProvider.notifier).state =
                        response.data['gender'] ?? '-';
                  },
                  child: const Text("Submit")),
              const SizedBox(
                height: 20,
              ),
              Text(gender)
            ],
          ),
        ),
      ),
    );
  }
}
