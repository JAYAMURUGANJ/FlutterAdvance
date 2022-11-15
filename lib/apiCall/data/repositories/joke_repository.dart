// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../exception_handler.dart';
import '../model/joke_model.dart';
import 'package:http/http.dart' as http;

class JokeRepository {
  final String _baseUrl = "https://v2.jokeapi.dev/joke/Any";
  final _controller = StreamController<JokeModel>();

  Stream<JokeModel> get stream => _controller.stream;
//Future METHOD with async and await
  Future<JokeModel> getJoke() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      return _processResponse(response);
    } on SocketException catch (_) {
      // make it explicit that a SocketException will be thrown if the network connection fails
      rethrow;
    }
  }

//Future METHOD without async and await
  Future<JokeModel> getJokeData() {
    return http.get(Uri.parse(_baseUrl)).then((value) {
      return jokeModelFromJson(value.body);
    }).catchError(
      (err) {
        return JokeModel.empty();
      },
      test: (error) => error is HttpException,
    ).whenComplete(() => print("ALL OK"));
  }

  JokeRepository() {
    Timer.periodic(const Duration(seconds: 2), (t) async {
      _controller.sink.add(await getJokeData());
    });
  }

  //----------------------ERROR STATUS CODES----------------------

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jokeModelFromJson(response.body);
        return responseJson;
      case 400: //Bad request
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 404: //Resource Not Found
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }
}
