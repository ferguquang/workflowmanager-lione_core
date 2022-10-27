// import 'package:smart_select/smart_select.dart';
//
// typedef GetTitle = String Function(dynamic item);
//
// List<S2Choice<T>> convertSmartSelectList<T>(dynamic model,
//     {GetTitle getTitle}) {
//   List<T> typeList = model;
//   List<S2Choice<T>> s2TypeList = S2Choice.listFrom<T, dynamic>(
//       source: typeList,
//       value: (index, item) {
//         return item;
//       },
//       title: (index, item) {
//         return getTitle(model[index]);
//       });
//   return s2TypeList;
// }
