import 'package:cloud_firestore/cloud_firestore.dart';

extension Path on String {
  CollectionReference get collection =>
      FirebaseFirestore.instance.collection(this);
}
