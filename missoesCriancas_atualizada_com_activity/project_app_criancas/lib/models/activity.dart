class Activity {

  String id;
  String linkImage;
  String description;
  

  Activity([String id,String linkImage,String description]) {
    this.id=id;
    this.linkImage=linkImage;
    this.description=description;
  }
  
  Activity.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    linkImage=data['linkImage'];
    description=data['description'];
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'linkImage':linkImage,
      'description':description,
    };
  }
  
}