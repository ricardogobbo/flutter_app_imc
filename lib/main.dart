import 'package:flutter/material.dart';

const APP_TITLE = "Calculadora de IMC";

const HEIGHT_FIELD_TITLE = "Altura (cm)";
const WEIGHT_FIELD_TITLE = "Peso (kg)";

const INSTRUCTIONS_TEXT = "Preencha o peso e a altura";
const CALCULATE_BUTTON_TITLE = "Calcular";
const RESULT_PRE_TEXT = "Resultado:";

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _result = "";

  var _formKey = GlobalKey<FormState>();

  var weightTextController = TextEditingController();
  var heightTextController = TextEditingController();
  var heightFocusNode = FocusNode();
  var weightFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    heightFocusNode.addListener(() {
      if (!heightFocusNode.hasFocus) {
        _formKey.currentState.validate();
      }
    });
    weightFocusNode.addListener(() {
      if (!weightFocusNode.hasFocus) {
        _formKey.currentState.validate();
      }
    });
  }

  void resetForm() {
    _formKey.currentState.reset();
    weightTextController.text = "";
    heightTextController.text = "";
    setState(() {
      _result = "";
    });
    //_formKey.currentState.reset();
  }

  void calculate() {
    try {
      int weight = int.parse(weightTextController.text);
      double height = int.parse(heightTextController.text) / 100;
      setState(() {
        _result = (weight / height / height).toString().substring(0, 5);
      });
    } catch (e) {
      setState(() {
        _result = "Erro!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: Container(
          child: Scaffold(
              appBar: AppBar(
                title: Text(APP_TITLE),
                centerTitle: true,
                backgroundColor: Colors.redAccent,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      resetForm();
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(50),
                        child: Image.asset("images/calculator.png",
                            fit: BoxFit.fitHeight, height: 100)),
                    Text(INSTRUCTIONS_TEXT,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                          controller: weightTextController,
                          focusNode: weightFocusNode,
                          keyboardType: TextInputType.number,
                          autocorrect: false,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.red,
                          style: TextStyle(fontSize: 30, color: Colors.red),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: WEIGHT_FIELD_TITLE,
                              labelStyle:
                                  TextStyle(color: Colors.red, fontSize: 16)),
                          validator: (value) {
                            if (value.isEmpty) return "Insira um peso";
                            if (double.tryParse(value) == null)
                              return "Insira um número válido";
                            return null;
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextFormField(
                        controller: heightTextController,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.red,
                        focusNode: heightFocusNode,
                        style: TextStyle(fontSize: 30, color: Colors.red),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: HEIGHT_FIELD_TITLE,
                            labelStyle:
                                TextStyle(color: Colors.red, fontSize: 16)),
                        validator: (value) {
                          if (value.isEmpty) return "Insira uma altura";
                          if (double.tryParse(value) == null)
                            return "Insira um número válido";
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            calculate();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(CALCULATE_BUTTON_TITLE,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                      ),
                    ),
                    Text(
                      '$RESULT_PRE_TEXT $_result',
                      style: TextStyle(color: Colors.red, fontSize: 40),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ))),
        ));
  }
}
