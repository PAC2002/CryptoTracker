import 'package:flutter/material.dart';
import 'coin_data.dart';
// for ios -cupertino
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  // default selected currency
  String? _selectedCurrency = 'INR';
// for android
  DropdownButton<String> getDropDownItem() {
    // list for the currencies
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: _selectedCurrency,
      items: dropdownItems,
      // selectedcurrency state is changed to the value selected
      onChanged: ((value) {
        setState(() {
          _selectedCurrency = value;
          getData();
        });
      }),
    );
  }

// for ios users
  CupertinoPicker pickerItems() {
    List<Text> pickercurrencyList = [];
    for (String currency in currenciesList) {
      pickercurrencyList.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            _selectedCurrency = pickercurrencyList[selectedIndex].toString();
            getData();
          });
        },
        children: pickercurrencyList);
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(_selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      // print(e);
      throw "something is wrong";
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Column makeCard() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
            value: isWaiting ? '?' : coinValues[crypto],
            selectedCurrency: _selectedCurrency,
            cryptoCurrency: crypto),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🪙CrypTracker'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 70, 47, 164),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // symbol of cryptocurrency
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            height: 100,
            child: const Image(image: AssetImage("images/logo.png")),
          ),
          makeCard(),
          //bottom container that contains the dropdown items for selecting a currency
          Container(
              margin: const EdgeInsets.only(top: 30),
              height: 90.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 25.0),
              color: Color.fromARGB(255, 10, 100, 85),
              child: Platform.isIOS ? pickerItems() : getDropDownItem()),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  CryptoCard(
      {required this.value,
      required this.selectedCurrency,
      required this.cryptoCurrency});
  final String? value;
  final String? selectedCurrency;
  final String cryptoCurrency;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: const Color.fromARGB(255, 23, 58, 75),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value  $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
