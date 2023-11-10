import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String gender = "Masculino";
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String result = "";
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Marina Lima Nogueira  RA: 1431432312009',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 40),
            GenderSelector(
              selectedGender: gender,
              onGenderChanged: (String? newGender) {
                setState(() {
                  gender = newGender!;
                  weightController.clear();
                  heightController.clear();
                  result = "";
                  showError = false;
                });
              },
            ),
            SizedBox(height: 8),
            ImcCalculator(
              gender: gender,
              weightController: weightController,
              heightController: heightController,
              showError: showError,
              result: result,
              onCalculate: calculateIMC,
            ),
          ],
        ),
      ),
    );
  }

  void calculateIMC() {
    if (weightController.text.isEmpty ||
        heightController.text.isEmpty ||
        double.tryParse(weightController.text) == null ||
        double.tryParse(heightController.text) == null) {
      setState(() {
        showError = true;
        result = "";
      });
      return;
    }

    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    double imc = weight / (height * height);

    setState(() {
      showError = false;
      if (gender == 'Masculino') {
        result = getResultForMale(imc);
      } else {
        result = getResultForFemale(imc);
      }
    });
  }

  String getResultForMale(double imc) {
    if (imc < 20.7) {
      return 'Abaixo do peso';
    } else if (imc >= 20.7 && imc <= 26.4) {
      return 'Peso ideal';
    } else if (imc >= 26.5 && imc <= 27.8) {
      return 'Pouco acima do peso';
    } else if (imc >= 27.9 && imc <= 31.1) {
      return 'Acima do peso';
    } else {
      return 'Obesidade';
    }
  }

  String getResultForFemale(double imc) {
    if (imc < 19.1) {
      return 'Abaixo do peso';
    } else if (imc >= 19.1 && imc <= 25.8) {
      return 'Peso ideal';
    } else if (imc >= 25.9 && imc <= 27.3) {
      return 'Pouco acima do peso';
    } else if (imc >= 27.4 && imc <= 32.3) {
      return 'Acima do peso';
    } else {
      return 'Obesidade';
    }
  }
}

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RadioWidget(
          label: 'Masculino',
          value: 'Masculino',
          groupValue: selectedGender,
          onChanged: onGenderChanged,
        ),
        SizedBox(width: 16),
        RadioWidget(
          label: 'Feminino',
          value: 'Feminino',
          groupValue: selectedGender,
          onChanged: onGenderChanged,
        ),
      ],
    );
  }
}

class RadioWidget extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const RadioWidget({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: (String? newValue) {
            onChanged(newValue);
          },
        ),
        Text(label),
      ],
    );
  }
}

class ImcCalculator extends StatefulWidget {
  final String gender;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final String result;
  final bool showError;
  final VoidCallback onCalculate;

  const ImcCalculator({
    required this.gender,
    required this.weightController,
    required this.heightController,
    required this.result,
    required this.showError,
    required this.onCalculate,
  });

  @override
  _ImcCalculatorState createState() => _ImcCalculatorState();
}

class _ImcCalculatorState extends State<ImcCalculator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.weightController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'[^\d.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Peso (kg)',
            hintText: 'Ex: 70.5',
            errorText: widget.showError ? 'Preencha um valor válido' : null,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: widget.heightController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp(r'[^\d.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Altura (m)',
            hintText: 'Ex: 1.75',
            errorText: widget.showError ? 'Preencha um valor válido' : null,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.onCalculate();
          },
          child: Text('Calcular'),
        ),
        SizedBox(height: 16),
        Text('Resultado: ${widget.result}'),
      ],
    );
  }
}
