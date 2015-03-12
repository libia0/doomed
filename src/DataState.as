package
{
	import flash.filters.GlowFilter;
	import flash.utils.ByteArray;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;
	import com.gif.player.GIFPlayer;
	public class DataState extends Sprite
	{
		private var txt:TextField = new TextField();
		public static  var main:DataState;
		[Embed(source="wait.gif", mimeType="application/octet-stream")]private static var WaitGif:Class;

		public function DataState()
		{
			main = this;

			var gifPlayer:GIFPlayer = new GIFPlayer();
			addChild(gifPlayer);
			gifPlayer.loadBytes((new WaitGif()) as ByteArray);

			txt.defaultTextFormat = new TextFormat("",20,0xff0000);
			/*txt.wordWrap = true;*/
			txt.width = 150;
			txt.autoSize = "center";
			/*txt.filters = [new GlowFilter()];*/
			/*txt.background =true;*/
			/*addChild(txt);*
			 */
			hide();
		}

		public function show(s:String=null):void
		{
			if(stage == null)return;
			/*txt.text = String(s);*/

			/*txt.wordWrap = true;*/
			logs.adds(s);

			//ps:暂时没有美丽的图形表示,so先隐藏不显示2013-11-25 16:43
			visible = true;


			txt.x = txt.y = 0;
			/*addChild(txt).visible =false;*/
			/*stage.addChild(main);*/
			if(stage){
				stage.addChild(main);
				main.x = stage.stageWidth/2- 50;
				main.y = stage.stageHeight/2 - 50;
			}
		}

		public function say(s:String):void
		{
			txt.text = Fanti.jian2fan(s);
			txt.visible = true;
			/*txt.x = CMain.stageW/2-txt.width/2;*/
			/*txt.y = CMain.stageH*.3-txt.height/2;*/
			/*stage.addChild(txt);*/
		}

		public function hide():void
		{
			visible = false;
			txt.visible = false;
			/*y = CMain.stageH*.4 - 55/2;*/
			/*x = CMain.stageW/2-165/2;*/
		}
	}
}

