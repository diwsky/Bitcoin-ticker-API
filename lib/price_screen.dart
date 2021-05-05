import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/currency_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency;
  String btcPrice;
  String ltcPrice;
  String ethPrice;

  @override
  void initState() {
    super.initState();
    currency = currenciesList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...getListOfCard(cryptoList, <String>[btcPrice, ethPrice, ltcPrice]),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              // child: Platform.isIOS ? iOSpicker() : androidPicker),
              child: Platform.isIOS ? iOSpicker() : androidPicker()),
        ],
      ),
    );
  }

  Widget iOSpicker() {
    return CupertinoPicker(
      // backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (value) => (currency = currenciesList[value]),
      children: currenciesList.map((e) => Text(e)).toList(),
    );
  }

  Widget androidPicker() {
    return DropdownButton<String>(
      value: currency,
      onChanged: (newValue) {
        setState(() {
          currency = newValue;
        });
        getExchangeRate(currency);
      },
      items: currenciesList
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
    );
  }

  List<Widget> getListOfCard(List<String> coinList, List<String> instanceList) {
    return coinList.asMap().entries.map((e) {
      return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 ${e.value} = ${instanceList[e.key] ?? '?'} $currency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void getExchangeRate(String currency) async {
    String btc = "";
    String eth = "";
    String ltc = "";

    for (String each in cryptoList) {
      CurrencyHandler(crypto: each, currency: currency)
          .getExchangeRate()
          .then((cur) {
        switch (each) {
          case 'ETH':
            {
              eth = cur.toInt().toString();
              break;
            }
          case 'BTC':
            {
              btc = cur.toInt().toString();
              break;
            }
          case 'LTC':
            {
              ltc = cur.toInt().toString();
              break;
            }
        }
        setState(() {
          btcPrice = btc;
          ethPrice = eth;
          ltcPrice = ltc;
        });
      });
    }
  }
}
