import 'package:bitcoin_ticker/api_caller.dart';
import 'package:bitcoin_ticker/constants.dart';

class CurrencyHandler {
  String crypto;
  String currency;

  CurrencyHandler({this.crypto, this.currency});

  Future<double> getExchangeRate() async {
    var data = await ApiCaller(
            url: URL + "/" + EXCHANGE_RATE + "/" + crypto + "/" + currency)
        .fetch();

    print(data['rate']);

    return data['rate'];
  }
}
