class Member {

  Dept dept;

  Staff staff;

  String position;

  String email;

  String status;

  String role;

  Member({
    this.dept,
    this.staff,
    this.position,
    this.email,
    this.status,
    this.role
  });

}

class Dept {
  int id;

  String name;

  Dept({this.id, this.name});
}

class Staff {
  int id;

  String name;

  Staff({this.id, this.name});
}