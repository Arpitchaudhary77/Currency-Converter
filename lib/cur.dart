// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  final TextEditingController textEditingController = TextEditingController();
  String fromCurrency = "USA (USD)";
  String toCurrency = "India (INR)";
  double result = 0;

  final List<String> currencies = [
    "Algeria (DZD)",
    "Brazil (BRL)",
    "USA (USD)",
    "India (INR)",
    "Eurozone (EUR)",
  ];

  /// Helper method: extracts the currency code from a string like "USA (USD)"
  String getCurrencyCode(String currency) {
    final start = currency.indexOf('(');
    final end = currency.indexOf(')');
    if (start != -1 && end != -1 && end > start) {
      return currency.substring(start + 1, end);
    }
    return '';
  }

  /// Fetch live conversion rate from the web.
  ///
  /// This example uses the ExchangeRate-API endpoint.
  /// For production apps, please refer to their documentation, as API keys or different endpoints may be required.
  Future<double> fetchConversionRate(String base, String target) async {
    final url = 'https://api.exchangerate-api.com/v4/latest/$base';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final rates = data['rates'] as Map<String, dynamic>;
      if (rates.containsKey(target)) {
        final rate = rates[target];
        return (rate as num).toDouble();
      } else {
        throw Exception('Rate for $target not found.');
      }
    } else {
      throw Exception('Failed to fetch conversion rate.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.white60,
        width: 2.0,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1d2630),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // Handle "Contact" action
              print("Contact button clicked");
            },
            child: const Text(
              "Contact",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'From',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: fromCurrency,
                items: currencies
                    .map(
                      (currency) => DropdownMenuItem<String>(
                    value: currency,
                    child: Text(
                      currency,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    fromCurrency = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                dropdownColor: const Color(0xFF1d2630), // Dropdown menu background color
              ),
              const SizedBox(height: 20),
              const Text(
                'To',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: toCurrency,
                items: currencies
                    .map(
                      (currency) => DropdownMenuItem<String>(
                    value: currency,
                    child: Text(
                      currency,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    toCurrency = value!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                dropdownColor: const Color(0xFF1d2630),
              ),
              const SizedBox(height: 70),
              TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixText: '${getCurrencyCode(fromCurrency)} ',
                  prefixStyle: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 90),
              ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(textEditingController.text) ?? 0;
                  try {
                    final base = getCurrencyCode(fromCurrency);
                    final target = getCurrencyCode(toCurrency);
                    final rate = await fetchConversionRate(base, target);
                    setState(() {
                      result = amount * rate;
                    });
                  } catch (e) {
                    print(e);
                    // Optionally, show an error message (for example using a SnackBar)
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Result',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$toCurrency: ${result.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
