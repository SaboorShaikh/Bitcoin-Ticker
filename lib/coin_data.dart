import 'package:http/http.dart' as http;
import 'dart:convert';

const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '84460ed8-f970-48cc-8525-78306b49579f';

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
  'ZAR',
];

const List<String> cryptoList = ['BTC', 'ETH', 'LTC'];

class CoinData {
  Future<double> getExchangeRate(String crypto, String currency) async {
    final url = '$coinApiUrl/$crypto/$currency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['rate'] != null) {
        return data['rate'].toDouble();
      } else {
        throw 'Rate not found in response';
      }
    } else {
      print('Failed to load $crypto to $currency: ${response.statusCode}');
      throw 'Problem with the get request';
    }
  }
}
