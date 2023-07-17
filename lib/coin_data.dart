import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

var urlRoot = dotenv.get("API_URL", fallback: "");
var apiKey = dotenv.get("API_KEY", fallback: "");
// further implemantation for others cryptocurrency will be done
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoinData(String? selectedCurrency) async {
    Map<String, String> cryptoexchangeRate = {};
    for (String crypto in cryptoList) {
      Uri url = Uri.parse('$urlRoot/$crypto/$selectedCurrency?apikey=$apiKey');
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        double price = decodeData['rate'];
        cryptoexchangeRate[crypto] = price.toStringAsFixed(0);
      } else {
        // print(response.statusCode);
        throw 'something went wrong';
      }
    }
    return cryptoexchangeRate;
  }
}
