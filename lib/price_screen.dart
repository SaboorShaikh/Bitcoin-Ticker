import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String btcValue = '?';
  String ethValue = '?';
  String ltcValue = '?';

  void getExchangeRates() async {
    try {
      CoinData coinData = CoinData();
      double btcRate = await coinData.getExchangeRate('BTC', selectedCurrency);
      double ethRate = await coinData.getExchangeRate('ETH', selectedCurrency);
      double ltcRate = await coinData.getExchangeRate('LTC', selectedCurrency);

      setState(() {
        btcValue = btcRate.toStringAsFixed(0);
        ethValue = ethRate.toStringAsFixed(0);
        ltcValue = ltcRate.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = currenciesList
        .map((currency) => DropdownMenuItem(
      child: Text(currency),
      value: currency,
    ))
        .toList();

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getExchangeRates();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = currenciesList
        .map((currency) => Text(
      currency,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ))
        .toList();

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      scrollController: FixedExtentScrollController(
        initialItem: currenciesList.indexOf(selectedCurrency),
      ),
      onSelectedItemChanged: (index) {
        setState(() {
          selectedCurrency = currenciesList[index];
          getExchangeRates();
        });
      },
      children: pickerItems,
    );
  }

  Widget buildCard(String crypto, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getExchangeRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🤑 Coin Ticker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildCard('BTC', btcValue),
          buildCard('ETH', ethValue),
          buildCard('LTC', ltcValue),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
