import 'dart:convert';
import 'dart:io';

import 'package:cbx_driver/LoginSignup/Login/components/body.dart';
import 'package:cbx_driver/Utils/helperutils.dart';
import 'package:cbx_driver/bloc/AddCardBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stripe_payment/stripe_payment.dart';
//
import '../app_theme.dart';

/*class AddCard *//*extends StatefulWidget*//* {
  *//*@override
  _AddCardState createState() => _AddCardState();*//*
}*/

/*class _AddCardState {
*//*  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final _creditCardNumText = TextEditingController();
  final _expiryText = TextEditingController();
  final _cvvText = TextEditingController();
  SharedPreferences prefs;

  //this client secret is typically created by a backend system
  //check https://stripe.com/docs/payments/payment-intents#passing-to-client
  final String _paymentIntentClientSecret = null;

  PaymentIntentResult _paymentIntent;
  Source _source;
  String _year ="";
  String _month ="";
  ScrollController _controller = ScrollController();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  CreditCard testCard;

  @override
  initState() {
    super.initState();
  initPreferences();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
  }
  Future<void> initPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {});
  }
  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(color: AppTheme.colorPrimaryDark),
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Add Card',
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.colorPrimaryDark,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Container(
          color: AppTheme.white,
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 0, bottom: 5, left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: size.width / 1.20,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: new TextField(
                        controller: _creditCardNumText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardNumberInputFormatter()],
                        decoration: new InputDecoration(
                          *//**//*border: new OutlineInputBorder(
                            borderSide:
                            new BorderSide(color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),*//**//*
                          hintText: 'Enter card number',
                        ),
                        onChanged: onCardNumbertextChange,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 0, bottom: 5, left: 25, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: new TextField(
                        controller: _expiryText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        decoration: new InputDecoration(
                          *//**//* border: new OutlineInputBorder(
                            borderSide:
                            new BorderSide(color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),*//**//*
                          hintText: 'Expiry Date',
                        ),
                        onChanged: onCardNumberExpiretextChange,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: new TextField(
                        controller: _cvvText,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CreditCardCvcInputFormatter()],
                        decoration: new InputDecoration(
                          *//**//* border: new OutlineInputBorder(
                            borderSide:
                            new BorderSide(color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)),
                          ),*//**//*
                          hintText: 'CVV',
                        ),
                        onChanged: onCardNumberCVVtextChange,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.85, // <-- match_parent
                child: ElevatedButton(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
                    child: Text("Add Card", style: TextStyle(fontSize: 14)),
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppTheme.colorPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: AppTheme.colorPrimary)))),
                  onPressed: () async => {
                    if (_creditCardNumText.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Card Number",
                            content: "Please Enter Card Number",
                            defaultActionText: "OK")
                      }
                    else if (_expiryText.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require Expiry Date",
                            content: "Please enter expiry date",
                            defaultActionText: "OK")
                      }
                    else if (_cvvText.text.toString().isEmpty)
                      {
                        showAlertDialog(
                            context: context,
                            title: "Require cvv",
                            content: "Please enter cvv",
                            defaultActionText: "OK")
                      }
                    else
                      {

                    _year = _expiryText.text.toString().split("/")[1].toString(),
                    _month = _expiryText.text.toString().split("/")[0].toString(),


                        print(_year+"==="+_month),

                testCard = CreditCard(
                number: _creditCardNumText.text.toString(),
                expMonth: int.parse(_month),
                expYear: int.parse(_year),
                cvc: _cvvText.text.toString()

                ),

                StripePayment.createTokenWithCard(testCard,).then((token) {
*//**//*
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Received ${token.tokenId}')));
*//**//*
                          setState(() {
                            _paymentToken = token;
                             print(_paymentToken.tokenId);
                             bloc.addCardReq(_paymentToken.tokenId, context, prefs.getString(SharedPrefsKeys.ACCESS_TOKEN), prefs.getString(SharedPrefsKeys.TOKEN_TYPE));

                          });
                        }).catchError(setError)
                      }
                    *//**//* Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => LocationTypeScreen(
                        serviceName: serviceName,
                        serviceId: serviceId,
                        subServiceId: subServiceId,
                      ),
                    ),
                  )*//**//*
                  },
                ),
              )
            ],
          )),
      bottomSheet: Container(
          alignment: Alignment.center,
          height: 60,
          color: AppTheme.white,
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                color: AppTheme.grey,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'All Your Information is save and secured',
                style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    color: AppTheme.grey,
                    fontSize: 13),
                textAlign: TextAlign.center,
              )
            ],
          )),

      *//**//*ListView(
          controller: _controller,
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            RaisedButton(
              child: Text("Create Source"),
              onPressed: () {
                StripePayment.createSourceWithParams(SourceParams(
                  type: 'ideal',
                  amount: 1099,
                  currency: 'eur',
                  returnURL: 'example://stripe-redirect',
                )).then((source) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${source.sourceId}')));
                  setState(() {
                    _source = source;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Token with Card Form"),
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(
                    CardFormPaymentRequest())
                    .then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Token with Card"),
              onPressed: () {
                StripePayment.createTokenWithCard(
                  testCard,
                ).then((token) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${token.tokenId}')));
                  setState(() {
                    _paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Payment Method with Card"),
              onPressed: () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: testCard,
                  ),
                ).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Payment Method with existing token"),
              onPressed: _paymentToken == null
                  ? null
                  : () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: CreditCard(
                      token: _paymentToken.tokenId,
                    ),
                  ),
                ).then((paymentMethod) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Received ${paymentMethod.id}')));
                  setState(() {
                    _paymentMethod = paymentMethod;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Confirm Payment Intent"),
              onPressed:
              _paymentMethod == null || _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.confirmPaymentIntent(
                  PaymentIntent(
                    clientSecret: _paymentIntentClientSecret,
                    paymentMethodId: _paymentMethod.id,
                  ),
                ).then((paymentIntent) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text(
                "Confirm Payment Intent with saving payment method",
                textAlign: TextAlign.center,
              ),
              onPressed:
              _paymentMethod == null || _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.confirmPaymentIntent(
                  PaymentIntent(
                    clientSecret: _paymentIntentClientSecret,
                    paymentMethodId: _paymentMethod.id,
                    isSavingPaymentMethod: true,
                  ),
                ).then((paymentIntent) {
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Authenticate Payment Intent"),
              onPressed: _paymentIntentClientSecret == null
                  ? null
                  : () {
                StripePayment.authenticatePaymentIntent(
                    clientSecret: _paymentIntentClientSecret)
                    .then((paymentIntent) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                          'Received ${paymentIntent.paymentIntentId}')));
                  setState(() {
                    _paymentIntent = paymentIntent;
                  });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Native payment"),
              onPressed: () {
                if (Platform.isIOS) {
                  _controller.jumpTo(450);
                }
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "1.20",
                    currencyCode: "EUR",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'EUR',
                    items: [
                      ApplePayItem(
                        label: 'Test',
                        amount: '13',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text('Received ${token.tokenId}')));
                    _paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Complete Native Payment"),
              onPressed: () {
                StripePayment.completeNativePayRequest().then((_) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Completed successfully')));
                }).catchError(setError);
              },
            ),
            Divider(),
            Text('Current source:'),
            Text(
              JsonEncoder.withIndent('  ').convert(_source?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current token:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentToken?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment method:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentMethod?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current payment intent:'),
            Text(
              JsonEncoder.withIndent('  ')
                  .convert(_paymentIntent?.toJson() ?? {}),
              style: TextStyle(fontFamily: "Monospace"),
            ),
            Divider(),
            Text('Current error: $_error'),
          ],
        )*//**//*
    );
  }

  onCardNumbertextChange(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    *//**//* setState(() {
      prefs.setString(SharedPrefKey.CREDITCARDNUMBER, text);


    });*//**//*
  }

  onCardNumberExpiretextChange(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    // setState(() {
    //   // prefs.setString(SharedPrefKey.EXPIRY, text);
    //
    //
    // });
  }

  onCardNumberCVVtextChange(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    }
  }*//*
}*/
