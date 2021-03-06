import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pixie/models/reportweb.dart';
import '../models/report.dart';
import '../models/rb.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  UserProvider() {
    this.fetchuser();
  }

  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  void addUser(User user) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/apis/user/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(user));
    if (response.statusCode == 201) {
      user.username = json.decode(response.body)['username'];
      _users.add(user);
      notifyListeners();
    }
  }

  void deleteUser(User user) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8000/apis/user/${user.username}/'));
    if (response.statusCode == 204) {
      _users.remove(user);
      notifyListeners();
    }
  }

  fetchuser() async {
    final Uri url = Uri.parse("http://10.0.2.2:8000/apis/user/?format=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _users = data.map<User>((json) => User.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class RbProvider with ChangeNotifier {
  RbProvider() {
    this.fetchrb();
  }

  List<Rb> _rbs = [];

  List<Rb> get rbs {
    return [..._rbs];
  }

  void addRb(Rb rb) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/apis/rbpi/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(rb));
    if (response.statusCode == 201) {
      rb.email = json.decode(response.body)['email'];
      _rbs.add(rb);
      notifyListeners();
    }
  }

  void deleteRb(Rb rb) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8000/apis/rbpi/${rb.email}/'));
    if (response.statusCode == 204) {
      _rbs.remove(rb);
      notifyListeners();
    }
  }

  fetchrb() async {
    final Uri url = Uri.parse("http://10.0.2.2:8000/apis/rbpi/?format=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _rbs = data.map<Rb>((json) => Rb.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class ReportProvider with ChangeNotifier {
  ReportProvider() {
    this.fetchreport();
    this.fetchreportWeb();
  }

  List<Report> _reports = [];

  List<Report> get reports {
    return [..._reports];
  }

  List<ReportWeb> _reportsWeb = [];

  List<ReportWeb> get reportsweb {
    return [..._reportsWeb];
  }

  void addReport(Report report) async {
    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/apis/report/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(report));
    if (response.statusCode == 201) {
      report.username = json.decode(response.body)['username'];
      _reports.add(report);
      notifyListeners();
    }
  }

  void deleteReport(Report report) async {
    final response = await http
        .delete(Uri.parse('http://10.0.2.2:8000/apis/report/${report.email}/'));
    if (response.statusCode == 204) {
      _reports.remove(report);
      notifyListeners();
    }
  }

  fetchreport() async {
    final Uri url = Uri.parse("http://10.0.2.2:8000/apis/report/?format=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _reports = data.map<Report>((json) => Report.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void addReportWeb(Report report) async {
    ReportWeb rpw = ReportWeb(
      email: report.email,
      key: report.key,
      username: report.username,
      telno: report.telno,
      content: report.content,
      citizengroup: report.citizengroup,
      pointX: report.pointX,
      pointY: report.pointY,
      rtn_addr: report.rtn_addr,
      upfile: new File(report.upfile),
      upfile2: new File(report.upfile2),
      upfile3: new File(report.upfile3),
      citizen_img_wdate: report.citizen_img_wdate,
      citizen_img_wdate2: report.citizen_img_wdate2,
      citizen_img_wdate3: report.citizen_img_wdate3,
      device: report.device,
    );

    final response = await http.post(
        Uri.parse('http://smartreport.seoul.go.kr/a800/a801.do'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(rpw));
    if (response.statusCode == 201) {
      rpw.key = json.decode(response.body)['key'];
      _reportsWeb.add(rpw);
      notifyListeners();
    }
  }

  fetchreportWeb() async {
    final Uri url =
        Uri.parse("http://smartreport.seoul.go.kr/a800/a801.do/?format=json");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _reportsWeb =
          data.map<ReportWeb>((json) => ReportWeb.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
