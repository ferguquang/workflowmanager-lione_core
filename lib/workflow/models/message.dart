
class Message {
  Message({
    this.code,
    this.text,
  });

  int code;
  String text;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    code: json["code"],
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "text": text,
  };
}
