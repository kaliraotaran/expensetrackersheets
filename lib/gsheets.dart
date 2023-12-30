import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  static const _Credentials = r'''
{
 "type": "service_account",
  "project_id": "expensetracker-409619",
  "private_key_id": "99f360f64dea0e6995b2f5cfd804d2b6303fafc2",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkKD5BlPXaXbv9\n5TsSD4NkSDcjC6FmYWa/R2zHWs5JxEoPCpVAkS4nu7bEPmqKN7RY8ReqHX5XzacJ\n1gK7mJMLY9Qw9zpezMmDFr2j5dZ4cQglsUSYDGHnke9jeaRSF8cJQW+tBRlMDIkK\n03IIjQXbnZA5POluXBm/BXXXrAPut9Et86L5ZsdeFcbZ5hOpKgVEeJzLx1MBBWFX\nXEOckx9puBpmiQd21uhvo4R7DS5vthVaiDyeNlol2uL+XcOf5hDy49o360WK/pf0\n2ptkI/UM6dqhqs/OK7iIfNAg491/vwoerGlsBDD7AaIu5zhzv40PXM6wCcXq20Uv\nm+BCyM6pAgMBAAECggEAE701Ezy+vWXFC7grPLY51e6rFp845q8ypDCJ/4THRm6A\ne0OKA+wRMTzssrdQp1MgcAt5jX6jaRp1CgU+aeFkWRvFcafg0HJujsFGx3UFL5Fj\n6ehhd6kRgr91GjCP1kE+sTm5nIP+8TqWpgMb9LREbo6JP6C37wnLHMGi1G6+QE+P\n1MNB+/GFDgcrRTko54rSzlCUcScVw4ovMZPe0Pep3XchARJJ0DOwDRdYKQyAImMk\nwzC1mIZYEhE40YbLuYjUUSNV4/aKplOR2Tlayv1XDPQSluiwAUwv2UerI2ifsvYX\nIsW5JHWTQxWlu98tsfDVsbiDHMNX/wg+ZJTdbvEZwQKBgQDVD2mkB81i4yTM37Fv\nuQOWh6YHhvK6o2hSI6CjZyRE/06j9IvyR6d0XDg4kAJMspX8jVweq6uEUDN6yGJ+\nbru5P9G11m83Ar6zxFGKrOCPLrk9tD25mOHVX3IAJAJgqKJL/YlF8lw4UaNzqY1o\n2xNDp8eqoDdvLqVkc3KUR7mbUQKBgQDFPbz9XJbXq9+BhotOj28jtVrNN5eCZs77\nS94MIUbN55gUesAHzPuAVHlnObdv/s0wjbabyaU10KyXmUkD+8IFYggN9M6yETds\nW7Oi/FrmUkF0iFsC8eRI9DRUzR51fvAa1J9yNqobsRYJssB2TopqnnWvL+siBALl\nC4Ovv8n32QKBgD8TYwkGrk1aRajJiLQ0p9VGr2aHExEiE15N4d6+SESM+PEdEtlV\nUUPnkVVdfPDL5g9wohcKZ6qyO6tb65zWl4jOVf1pUF+O1npN4n4VlB2PjZOw6p0p\nn6IVsaBNCM8o3XN1ydAFYjviH2u8hHrIcLmU0E25RPALdTd53i/70/0hAoGACpjL\ni40q6YFpa6sP1vOr0+5NZ5MiB7aATk4AKwSqqitUJ12E7aZcqMNhFmOqcFDvMzmZ\n4vrNbnu8mhR5MMaY4PMoXZ+Wb0ivgpnWp94JADDRJXKh+SGH00eTfC7dAREF01sz\nCc7YCs7T0UeSQYjstNe4mOXpKxWuFiItPAcA0dkCgYEAkqxqE82TP1NX+LTo3AQ8\nV7yVly4FvtBdeVZbK5MIovh7OyY3GSnz1sYBCLaZHGvzHthaq3J1SYLFjUzUCZBa\n+lQFIA8/MV+97CSQUp9R/G2OOYQ51QI2DBSGkjn+nbnBXoD4pjMuqCXns0v2OGFx\nbX0cyWcVVklqCmKxs6tn6Ac=\n-----END PRIVATE KEY-----\n",
  "client_email": "expensetracker@expensetracker-409619.iam.gserviceaccount.com",
  "client_id": "101896514430035894315",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/expensetracker%40expensetracker-409619.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

  static const _spreadsheetId = '1VmpAsmAC0v8nYIb9r6kLxd7yLrhgAzD-Pb3HDIw5pDc';
  static final _gsheets = GSheets(_Credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet?.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      isIncome == true ? 'income' : 'expense',
    ]);
  }
}
