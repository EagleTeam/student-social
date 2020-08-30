import 'package:flutter/material.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/diem_ngoai_khoa_obj.dart';

// Màn hình điểm ngoại khoá
class ExtracurricularScreen extends StatefulWidget {
  const ExtracurricularScreen({this.msv});

  final String msv;

  @override
  _ExtracurricularScreenState createState() => _ExtracurricularScreenState();
}

class _ExtracurricularScreenState extends State<ExtracurricularScreen> {
  List<DiemNgoaiKhoaObj> _list;
  Future<List<DiemNgoaiKhoaObj>> _future;
  String _name, _lop, _tong, _choduyet;
  bool _update = false;

  @override
  void initState() {
    super.initState();
    _future = getDiem();
  }

  Future<List<DiemNgoaiKhoaObj>> getDiem() async {
    _list = <DiemNgoaiKhoaObj>[];
    if (widget.msv.startsWith('DTC') || widget.msv.startsWith('DTE')) {
    } else {
      return <DiemNgoaiKhoaObj>[]; //empty => truong khong ho tro
    }
//    var post = await http.get(
//        'https://studentsocial.shipx.vn/ngoaikhoa/dnk.php?msv=${widget.msv}');
    logs('done');
    if (_update) {
      Navigator.of(context).pop();
      _dialogUpdateSuccess();
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pop();
      _update = false;
    }

//    var info = json.decode(post.body);
//    _name = info['hoten'];
//    _lop = info['lop'];
//    _tong = info['diem'].toString();
//    _choduyet = info['choduyet'].toString();
//    List<dynamic> list = info['hoatdong'];
//    list.forEach((elem) {
//      _list.add(DiemNgoaiKhoaObj.fromJson(elem));
//    });
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoạt động ngoại khoá'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              reload();
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data == null) {
                return const Center(
                  child: Text('Trường của bạn chưa hỗ trợ tính năng này ^_^'),
                );
              } else {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: 170,
                      flexibleSpace: FlexibleSpaceBar(
                        background: headLayout(),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          layoutItem(
                              (snapshot.data as List<DiemNgoaiKhoaObj>)[index]),
                          const Divider(color: Colors.grey)
                        ],
                      );
                    },
                            childCount:
                                (snapshot.data as List<DiemNgoaiKhoaObj>)
                                    .length))
                  ],
                );
              }
            }
          }),
    );
  }

  Future<void> _dialogLoading(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _dialogUpdateSuccess() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          contentPadding: const EdgeInsets.all(6),
          content: const ListTile(
              title: Text('Cập nhật thành công !'),
              leading: CircleAvatar(
                child: Icon(Icons.check),
              )),
        ); //magic ^_^
      },
    );
  }

  void reload() {
    setState(() {
      _list.clear();
      _future = getDiem();
      _update = true;
      _dialogLoading('Đang cập nhật dữ liệu!');
    });
  }

  Widget headLayout() {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //day la head(avatar)
          Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.amber,
                child: Text('E.T'),
              ),
              Container(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tổng điểm: $_tong',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    'Đang chờ: $_choduyet',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              )
            ],
          ),
          Container(
            height: 16,
          ),
          Text('Họ tên: $_name',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text('MSV: ${widget.msv}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          Text(_lop,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget bodyLayout(List<DiemNgoaiKhoaObj> list) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                layoutItem(list[index]),
                const Divider(color: Colors.black)
              ],
            );
          }),
    );
  }

  Widget layoutItem(DiemNgoaiKhoaObj obj) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Flexible(
              flex: 8,
              child: ListTile(
                  title: Text(
                obj.title,
                style: const TextStyle(color: Colors.black87),
              ))),
          const Divider(color: Colors.black),
          Flexible(
              flex: 1,
              child: Center(
                  child: Text(
                obj.score == 'false' ? 'Chờ' : '${obj.score}đ',
                style: const TextStyle(color: Colors.black87),
              ))),
          const Divider(color: Colors.black),
          Flexible(
              flex: 1,
              child: Center(
                  child: obj.status == 'ok'
                      ? const Icon(
                          Icons.done_outline,
                          color: Colors.green,
                        )
                      : const Icon(Icons.timelapse, color: Colors.red)))
        ],
      ),
    );
  }
}
