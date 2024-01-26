import 'package:frontend/src/common/view/page.dart';

final class ContactsPage implements Page {
  ContactsPage();

  @override
  String get name => 'contacts';

  @override
  void create() {
    // TODO: implement create
  }

  @override
  Object? build() {
    const content = '<h1>Contacts</h1>';
    return content;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
