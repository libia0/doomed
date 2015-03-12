package
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;

	public class Txts extends BaseSprite 
	{
		public function Txts():void{

		}

		public static function make_txts(_size:int=16,_width:int=100,_height:int=100,_text:String=""):TextField
		{
			var txt:TextField = new TextField();
			/*txt.type = TextFieldType.INPUT;*/
			txt.width = _width;
			txt.wordWrap = true;
			/*txt.border = true;*/
			txt.height= _height;
			txt.defaultTextFormat = new TextFormat(null,_size,0xffffff);
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			txt.text = _text;
			return txt;
		}
		public static function make_txt(_size:int=16,_width:int=100,_height:int=100,_text:String=""):TextField
		{
			var txt:TextField = new TextField();
			txt.type = TextFieldType.INPUT;
			txt.width = _width;
			txt.wordWrap = true;
			/*txt.border = true;*/
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			txt.height= _height;
			txt.defaultTextFormat = new TextFormat(null,_size);
			txt.text = _text;
			return txt;
		}

		public static function make_txtbtn(_size:int=16,_width:int=100,_height:int=100,_text:String="",fun:Function=null):TextField
		{
			var txt:TextField = new TextField();
			txt.width = _width;
			txt.height= _height;
			txt.text = _text;
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			if(fun == null){}else txt.addEventListener(MouseEvent.CLICK,fun);
			return txt;
		}
	}
}
