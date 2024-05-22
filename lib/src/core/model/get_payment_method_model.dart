// ignore: file_names
class PaymentMethodModel {
  List<PaymentMethods>? paymentMethods;
  Countries? countries;

  PaymentMethodModel({this.paymentMethods, this.countries});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    if (json['paymentMethods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['paymentMethods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
    countries = json['countries'] != null
        ? Countries.fromJson(json['countries'])
        : null;
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [paymentMethods] property is converted to a list of JSON representations
  /// by calling the `toJson()` method on each element of the list. If
  /// [paymentMethods] is `null`, the corresponding key-value pair is not added
  /// to the map.
  ///
  /// The [countries] property is converted to a JSON representation by calling
  /// the `toJson()` method on it. If [countries] is `null`, the corresponding
  /// key-value pair is not added to the map.
  ///
  /// Returns:
  ///   A [Map] containing the JSON representation of this object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentMethods != null) {
      data['paymentMethods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    if (countries != null) {
      data['countries'] = countries!.toJson();
    }
    return data;
  }
}

class PaymentMethods {
  String? code;
  String? label;
  int? limit;
  Fee? fee;

  PaymentMethods({this.code, this.label, this.limit, this.fee});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    label = json['label'];
    limit = json['limit'];
    fee = json['fee'] != null ? Fee.fromJson(json['fee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['label'] = label;
    data['limit'] = limit;
    if (fee != null) {
      data['fee'] = fee!.toJson();
    }
    return data;
  }
}

class Fee {
  num? fixed;
  num? percentage;

  Fee({this.fixed, this.percentage});

  Fee.fromJson(Map<String, dynamic> json) {
    fixed = double.parse(json['fixed'].toString());
    percentage = double.parse(json['percentage'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fixed'] = fixed as double;
    data['percentage'] = percentage as double;
    return data;
  }
}

class Countries {
  List<String>? at;
  List<String>? be;
  List<String>? bg;
  List<String>? ch;
  List<String>? cy;
  List<String>? cz;
  List<String>? de;
  List<String>? dk;
  List<String>? ee;
  List<String>? es;
  List<String>? fi;
  List<String>? fr;
  List<String>? gb;
  List<String>? gr;
  List<String>? hr;
  List<String>? hu;
  List<String>? ie;
  List<String>? it;
  List<String>? lt;
  List<String>? lu;
  List<String>? lv;
  List<String>? mt;
  List<String>? nl;
  List<String>? no;
  List<String>? pl;
  List<String>? pt;
  List<String>? ro;
  List<String>? se;
  List<String>? sk;
  List<String>? sl;

  Countries(
      {this.at,
      this.be,
      this.bg,
      this.ch,
      this.cy,
      this.cz,
      this.de,
      this.dk,
      this.ee,
      this.es,
      this.fi,
      this.fr,
      this.gb,
      this.gr,
      this.hr,
      this.hu,
      this.ie,
      this.it,
      this.lt,
      this.lu,
      this.lv,
      this.mt,
      this.nl,
      this.no,
      this.pl,
      this.pt,
      this.ro,
      this.se,
      this.sk,
      this.sl});

  Countries.fromJson(Map<String, dynamic> json) {
    at = json['at'].cast<String>();
    be = json['be'].cast<String>();
    bg = json['bg'].cast<String>();
    ch = json['ch'].cast<String>();
    cy = json['cy'].cast<String>();
    cz = json['cz'].cast<String>();
    de = json['de'].cast<String>();
    dk = json['dk'].cast<String>();
    ee = json['ee'].cast<String>();
    es = json['es'].cast<String>();
    fi = json['fi'].cast<String>();
    fr = json['fr'].cast<String>();
    gb = json['gb'].cast<String>();
    gr = json['gr'].cast<String>();
    hr = json['hr'].cast<String>();
    hu = json['hu'].cast<String>();
    ie = json['ie'].cast<String>();
    it = json['it'].cast<String>();
    lt = json['lt'].cast<String>();
    lu = json['lu'].cast<String>();
    lv = json['lv'].cast<String>();
    mt = json['mt'].cast<String>();
    nl = json['nl'].cast<String>();
    no = json['no'].cast<String>();
    pl = json['pl'].cast<String>();
    pt = json['pt'].cast<String>();
    ro = json['ro'].cast<String>();
    se = json['se'].cast<String>();
    sk = json['sk'].cast<String>();
    sl = json['sl'].cast<String>();
  }

  /// Converts this object to a [Map] representation in JSON format.
  ///
  /// Returns a [Map] containing the JSON representation of this object. The keys
  /// of the map are the names of the properties of this object, and the values
  /// are the corresponding values of the properties.
  ///
  /// The [at], [be], [bg], [ch], [cy], [cz], [de], [dk], [ee], [es], [fi],
  /// [fr], [gb], [gr], [hr], [hu], [ie], [it], [lt], [lu], [lv], [mt], [nl],
  /// [no], [pl], [pt], [ro], [se], [sk], and [sl] properties are converted to a
  /// JSON representation by assigning their respective values to the map.
  ///
  /// Returns:
  ///   A [Map] containing the JSON representation of this object.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['at'] = at;
    data['be'] = be;
    data['bg'] = bg;
    data['ch'] = ch;
    data['cy'] = cy;
    data['cz'] = cz;
    data['de'] = de;
    data['dk'] = dk;
    data['ee'] = ee;
    data['es'] = es;
    data['fi'] = fi;
    data['fr'] = fr;
    data['gb'] = gb;
    data['gr'] = gr;
    data['hr'] = hr;
    data['hu'] = hu;
    data['ie'] = ie;
    data['it'] = it;
    data['lt'] = lt;
    data['lu'] = lu;
    data['lv'] = lv;
    data['mt'] = mt;
    data['nl'] = nl;
    data['no'] = no;
    data['pl'] = pl;
    data['pt'] = pt;
    data['ro'] = ro;
    data['se'] = se;
    data['sk'] = sk;
    data['sl'] = sl;
    return data;
  }
}
