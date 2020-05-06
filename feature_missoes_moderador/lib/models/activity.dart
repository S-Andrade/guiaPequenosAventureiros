class Activity {

  String id;
  String linkImage;
  String description;
  

  Activity([String id,String description,String linkImage]) {
    this.id=id;
    this.description=description;
    this.linkImage=linkImage;
  }

  
  
  Activity.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    description=data['description'];
    linkImage=data['linkImage'];
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description':description,
      'linkImage':linkImage,
    };
  }
  
}