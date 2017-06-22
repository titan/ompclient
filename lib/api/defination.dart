import "package:http/http.dart";
import "dart:convert";

const server = "http://202.97.158.60:8085/nnomp/";

Response checkStatus(Response response) {
  final status = response.statusCode;
  if (status > 199 && status < 300) {
    return response;
  } else {
    throw new ClientException(response.body);
  }
}

Map parseJson(Response reponse) {
  return JSON.decode(reponse.body);
}

class CollectionResponse<T> {
  List<T> rows;
  int records;
  int total;
  int page;
}
