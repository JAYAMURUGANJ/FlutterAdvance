import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/deviceinfo/device_info.dart';
import '../bloc/calculator_bloc.dart';

class CalculatorPage extends StatelessWidget {
  CalculatorPage({Key? key}) : super(key: key);

  final TextEditingController firstOperandController = TextEditingController();
  final TextEditingController secondOperandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.device_hub),
            tooltip: 'DeviceInfo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeviceInfo()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<CalculatorBloc, CalculatorState>(
                buildWhen: (context, state) {
                  return state is CalculatorResultSuccessful ||
                      state is CalculatorResultFailure;
                },
                builder: (context, state) {
                  if (state is CalculatorResultFailure) {
                    return resultText(state.message, context);
                  } else if (state is CalculatorResultSuccessful) {
                    return resultText(state.result.toString(), context);
                  }

                  return resultText('Result', context);
                },
                listenWhen: (context, state) {
                  return state is CalculatorResultSuccessful ||
                      state is CalculatorResultFailure;
                },
                listener: (context, state) {
                  if (state is CalculatorResultFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Failure'),
                      duration: Duration(seconds: 5),
                    ));
                  } else if (state is CalculatorResultSuccessful) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Succuss'),
                      duration: Duration(seconds: 5),
                    ));
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      key: const ValueKey('firstOperand'),
                      controller: firstOperandController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      key: const ValueKey('secondOperand'),
                      controller: secondOperandController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ),
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  calButton(context, "+", () {
                    BlocProvider.of<CalculatorBloc>(context).add(
                      AddButtonTapped(
                        int.parse(firstOperandController.text),
                        int.parse(secondOperandController.text),
                      ),
                    );
                  }),
                  calButton(context, "-", () {
                    BlocProvider.of<CalculatorBloc>(context).add(
                      SubtractButtonTapped(
                        int.parse(firstOperandController.text),
                        int.parse(secondOperandController.text),
                      ),
                    );
                  }),
                  calButton(context, "*", () {
                    BlocProvider.of<CalculatorBloc>(context).add(
                      MultiplyButtonTapped(
                        int.parse(firstOperandController.text),
                        int.parse(secondOperandController.text),
                      ),
                    );
                  }),
                  calButton(context, "/", () {
                    BlocProvider.of<CalculatorBloc>(context).add(
                      DivideButtonTapped(
                        int.parse(firstOperandController.text),
                        int.parse(secondOperandController.text),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded calButton(BuildContext context, String btnName, onPressed) {
    return Expanded(
      child: MaterialButton(
        color: Theme.of(context).primaryColorLight,
        onPressed: onPressed,
        child: Text(btnName),
      ),
    );
  }

  Text resultText(String result, BuildContext context) {
    return Text(
      result,
      style: Theme.of(context).textTheme.headline3,
    );
  }
}
