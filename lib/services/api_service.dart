class APIService {

  static final APIService _instance = APIService._internal();

  factory APIService(){
    return _instance;
  }

  APIService._internal(){}

  Future<void> login(String email, String password){

  }
}