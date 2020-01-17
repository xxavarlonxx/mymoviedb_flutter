import 'package:http/http.dart' as http;

const String base_Url = 'https://mymoviedb.ahochschulte.de/api';

class APIService {

  static final APIService _instance = APIService._internal();

  factory APIService(){
    return _instance;
  }

  APIService._internal(){}

  Future<void> login(String email, String password) async {
    Map<String, String> parameters = {
      'email': email,
      'password': password
    };
    try{
      http.Response response = await http.post('$base_Url/auth/login', body: parameters);

      if(response.statusCode == 200){
        print(response.body);
      }else{
        if(response.statusCode == 401){
          print("Logindaten sind falsch");
        }

        else if(response.statusCode == 404){
          print("Nutzer unbekannt");
        }

        else{
          print("Unbekannter schwerer Fehler");
        }

        print('${response.statusCode}: ${response.body}');
      }

    }catch(e){
      print(e);
    }
    
  }

  Future<void> signin(String email, String name, String password, String passwordConfirmation) async {

  }

}