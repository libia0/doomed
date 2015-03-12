package
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.events.Event;
	public class SinaZq extends Sprite
	{
		public function SinaZq(s:String="jcbf")
		{
			switch(s){
				case "jcbf":
					var zqjc163url:String = "http://live.caipiao.163.com/jcbf/";
					SwfLoader.loadData(zqjc163url,zqloaded);
				case "dcbf":
					zqjc163url = "http://live.caipiao.163.com/dcbf/";
					SwfLoader.loadData(zqjc163url,zqloaded);
					break;
				case "sina":
					var zqxlurl:String = "http://data.sports.sina.com.cn/live/index.php";
					SwfLoader.loadData(zqxlurl,zqxlloaded,"binary");
					break;
			}
		}
		private var sinaXml:XML;
		private var xml163:XML;
		private function zqxlloaded(e:Event):void
		{
			var bytes:ByteArray = (e.target.data) as ByteArray;
			bytes.position = 0;
			decodeSina(bytes.readMultiByte(bytes.length,"GB2312"));
		}

		private function zqloaded(e:Event):void
		{
			decode163(e.target.data);
		}

		private function decodeSina(s:String):void
		{
			s = String(s).replace(/([　\r\n]|class\=red)/gmi,"").replace(/^.*(<div class="infoList" id="infoList">.*)<div class="bottomTool">.*$/im,"$1");
			s = s.replace(/class/g,"classs");
			s = s.replace(/id/g,"ids");
			sinaXml = XML(s+"</div>");

			var curplay:XMLList = sinaXml.children()[1].table.tr;
			for each(var xmls:XML in curplay)
			{
				showSinaCur(xmls);
			}
			var willplay:XMLList = sinaXml.children()[2].table.tr;
			for each(xmls in willplay)
			{
				showSinaCur(xmls);
			}

			var completeplay:XMLList = sinaXml.children()[3].table.tr;
			for each(xmls in completeplay)
			{
				showSinaComplete(xmls);
			}
		}

		private function showSinaCur(xml:XML):String
		{
			var s:String = "";
			/*var playTime:String = xml.td.(@ids=="td_3").toXMLString();*/
			var playTime:String = xml.td.(@classs=="td_3");
			var events:String = xml.td.(@classs=="td_2");
			var half:String = xml.td.(@classs=="td_4").span;
			var host:String = xml.td.(@classs=="td_5").a;
			var guest:String = xml.td.(@classs=="td_7").a;
			var score:String = xml.td.(@classs=="td_6").a.span;
			logs.adds(playTime,events,half,host,guest,score);
			return s;
		}
		private function showSinaComplete(xml:XML):String
		{
			var s:String = "";
			/*var playTime:String = xml.td.(@ids=="td_3").toXMLString();*/
			var playTime:String = xml.td.(@classs=="td_3");
			var events:String = xml.td.(@classs=="td_2");
			var half:String = xml.td.(@classs=="td_4").span;
			var host:String = xml.td.(@classs=="td_5").a;
			var guest:String = xml.td.(@classs=="td_7").a;
			var score:String = xml.td.(@classs=="td_6").a.span.font;
			logs.adds(playTime,events,half);
			logs.adds(host,guest,score);
			return s;
		}

		private function decode163(s:String):void
		{
			s = String(s).replace(/([　\r\n])/gmi,"").replace(/^.*(<dl id ="gameList">.*)<div class="grayBlock">.*$/im,"$1");
			s = s.replace(/class/g,"classs");
			xml163= XML(s);
			for each(var xmls:XML in xml163.children())
			{
				show163Item(xmls);
			}
		}

		private function showSinaItem(xmls:XML):String
		{
			var s:String = "";

			return s;
		}
		private function show163Item(xmls:XML):String
		{
			var s:String = "";
			var matcheDetail:XML = xmls.em.(@classs == "matcheDetail")[0];
			var playTime:String = matcheDetail.span.(@classs=="playTime")[0];
			var round:String = matcheDetail.span.(@classs=="round")[0];
			var events:String = matcheDetail.span.(@classs=="events")[0].child("*");
			var type:String = String(matcheDetail.span.(@classs=="type").child("*"));

			var analysisDetail:XML = xmls.em.(@classs == "analysisDetail")[0];
			var concede:String = " "+analysisDetail.span.(@classs=="concede")[0];
			var odds0:String = " "+analysisDetail.span.(@classs=="odds")[0].em[0];
			var odds1:String = " "+analysisDetail.span.(@classs=="odds")[0].em[1];
			var odds2:String = " "+analysisDetail.span.(@classs=="odds")[0].em[2];

			var analysisDetails:String = 
				(playTime +" "
				 + round
				 + events
				 + type
				 + concede
				 +": "
				 + odds0
				 + odds1
				 + odds2
				);
			var statuss:String = xmls.@score +" "+ xmls.@bidScore + " "+xmls.@statusDesc;

			var vsDetail:XML = xmls.em.(@classs == "vsDetail")[0];
			var host:String = " "+vsDetail.span.(@classs=="host")[0].a[0].children()[2];
			var guest:String = " "+vsDetail.span.(@classs=="guest")[0].a[0].children()[1];
			var vs:String = (host + " vs " + guest);
			/*if( concede==" 1" || concede == " -1")*/
			/*if( concede==" 1" || concede==" 2" || concede == " -2" || concede == " 3" || concede == " -3")*/
			if(concede==" 2" || concede == " -2" || concede == " 3" || concede == " -3")
				logs.adds(vs, statuss, analysisDetails);
			return analysisDetails + "\n" + statuss + "\n" + vs ;
		}
	}
}

