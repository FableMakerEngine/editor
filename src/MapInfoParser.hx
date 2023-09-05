package;

class MapInfoParser {
  public var maps: Array<MapInfo> = [];

  public function new() {}

  public function parse(mapInfoXml: String) {
    var data = Xml.parse(mapInfoXml);
    maps = recursiveParse(data.firstElement());
    return maps;
  }

  function recursiveParse(xmlData: Xml): Array<MapInfo> {
    var mapElements = xmlData.elements();

    return [
      for (element in mapElements) {
        var children = element.elements();
        var mapInfo = {
          name: element.get('name'),
          id: Std.parseInt(element.get('id')),
          path: element.get('path'),
          children: if (children.hasNext()) recursiveParse(element) else null
        }

        mapInfo;
      }
    ];
  }
}
