class Mission {

  String id;
  String title;
  String type;
  dynamic content;
  String linkVideo;
  String linkImage;
  String linkAudio;
  List resultados;
 
  
  Mission();
  
  Mission.fromMap(Map<String,dynamic> data) {
    id=data['id'];
    title=data['title'];
    type=data['type'];
    content=data['content'];
    linkVideo=data['linkVideo'];
    linkImage=data['linkImage'];
    linkAudio=data['linkAudio'];
    resultados=data['resultados'];
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title':title,
      'type':type,
      'content':content,
      'linkVideo':linkVideo,
      'linkImage':linkImage,
      'linkAudio':linkAudio,
      'resultados':resultados,
    };
  }
  
}