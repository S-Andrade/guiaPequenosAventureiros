class Mission {

  String id;
  String title;
  int counter;
  String type;
  bool done;
  String content;
  String linkVideo;
  String linkImage;
 
  
  Mission();
  
  Mission.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    title=data['title'];
    counter=data['counter'];
    type=data['type'];
    done=data['done'];
    content=data['content'];
    linkVideo=data['linkVideo'];
    linkImage=data['linkImage'];
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title':title,
      'counter':counter,
      'type':type,
      'done':done,
      'content':content,
      'linkVideo':linkVideo,
      'linkImage':linkImage,
    };
  }
  
}