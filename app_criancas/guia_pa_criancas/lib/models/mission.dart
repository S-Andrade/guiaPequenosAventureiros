class Mission {

  String id;
  String title;
  int counter;
  String type;
  bool done;
  bool reload;
  dynamic content;
  String linkVideo;
  String linkImage;
  String linkAudio;
 
  
  Mission();
  
  Mission.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    title=data['title'];
    counter=data['counter'];
    type=data['type'];
    done=data['done'];
    reload=data['reload'];
    content=data['content'];
    linkVideo=data['linkVideo'];
    linkImage=data['linkImage'];
    linkAudio=data['linkAudio'];
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
      'linkAudio':linkAudio,
      'reload':reload,
    };
  }
  
}