package 
{
	import shu.zhongshus;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class AlertBox extends DragPage
	{
		private static var title_txt:TextField;
		private static var content_txt:TextField;
		private static var alpha_bg:Shape;
		private static var rectbg:Shape;

		private static var _main:AlertBox;
		private static function get main():AlertBox
		{
			if(_main==null)new AlertBox;
			return _main;
		}

		public static function get msg():String
		{
			return content_txt.text;
		}

		private static var xx:int;
		private static var yy:int;
		private static var ww:int;
		private static var _stage:Stage;
		public static function get _Stage():Stage {
			if(_stage==null)_stage = zhongshus.main.stage;
			return _stage;
		}
		public static function set _Stage(s:Stage):void{
			_stage = s;
		}

		public function AlertBox()
		{
			_main = this;
			xx = _Stage.stageWidth*.4;
			ww = _Stage.stageWidth - xx*2;
			yy = _Stage.stageHeight*.32;

			if(alpha_bg == null){
				alpha_bg= new Shape();
				alpha_bg.graphics.beginFill(0x999999);
				alpha_bg.graphics.drawRect(0,0, _Stage.stageWidth, _Stage.stageHeight);
				alpha_bg.graphics.endFill();
				alpha_bg.alpha = .5;
			}
			main.addChild(alpha_bg);

			rectbg = new Shape();
			main.addChild(rectbg);

			title_txt = new TextField();
			title_txt.defaultTextFormat = new TextFormat("Microsoft YaHei",25);
			title_txt.x = xx;
			title_txt.y = yy;
			title_txt.width = ww;
			title_txt.autoSize = TextFieldAutoSize.CENTER;
			title_txt.border = false;
			title_txt.selectable = false;
			main.addChild(title_txt);
			title_txt.text = " ";

			content_txt= new TextField();
			content_txt.defaultTextFormat = new TextFormat("Microsoft YaHei",22);
			content_txt.x = xx;
			content_txt.y = yy + title_txt.height*1.5;
			content_txt.width = ww; 
			content_txt.autoSize = TextFieldAutoSize.CENTER;
			content_txt.border = false;
			main.addChild(content_txt);
		}

		private static var timeout:uint;
		private static var has_btn:Boolean = false;
		public static function show(title:String=null,content:Array=null,timeout_ms:int=0,btn_arr:Array=null):void
		{
			trace(title);
			_Stage.addChild(main);
			if(title){
				main.visible = true;
			}else{
				back();
				return;
			}
			title_txt.text = Fanti.jian2fan(title);
			ViewSet.removes(btns_bottom);
			ViewSet.removes(btns_mid);
			var liney:int = yy +title_txt.height*2;
			var cury:int;
			if(content  && content.length >0 ){ 
				if(content.length == 1 && content[0].fun == null){
					content_txt.text = Fanti.jian2fan(content[0].str);
					cury = content_txt.y + content_txt.height + _Stage.stageHeight*.05;
				}else{
					content_txt.text = "";
					cury= make_vert_btns(content);
				}
				liney = Math.max(cury,liney);
				cury = liney;
			}else{
				content_txt.text = "";
			}
			if(title ==""){
				title_txt.visible = false;
			}else{
				title_txt.visible = true;
			}
			clearTimeout(timeout);
			if(int(timeout_ms)>1)timeout = setTimeout(back,timeout_ms);

			if(btn_arr && btn_arr.length > 0){
				main.addChild(btns_bottom);
				var btnw:int = ww/btn_arr.length*.8;
				var btn_gap:int = ww/btn_arr.length*.2;
				var btnh:int = _Stage.stageHeight*.05;
				var startx:int = (_Stage.stageWidth - ww)/2 + btn_gap/2;
				var starty:int = liney + _Stage.stageHeight*.01;

				for each(var o:Object in btn_arr)
				{
					var okBtn:TxtBtn;
					okBtn = new TxtBtn((o.str),o.fun,startx,starty);
					okBtn.setformat(btnw,btnh,TextFieldAutoSize.CENTER,0xffffff,0xffffff,0x0,0x0,0x0);
					btns_bottom.addChild(okBtn);
					startx += btnw + btn_gap;
				}
				cury = starty + btnh*1.2 ;
			}else{
				ViewSet.removes(btns_bottom);
			}
			rectbg.graphics.clear();
			rectbg.graphics.beginFill(0xffffff);
			/*rectbg.graphics.lineStyle(1,0x000000);*/
			rectbg.graphics.drawRoundRect(xx,_Stage.stageHeight*.3, ww,Math.max(cury - _Stage.stageHeight*.3,_Stage.stageHeight*.1),_Stage.stageWidth*.01,_Stage.stageWidth*.01);
			rectbg.graphics.endFill();
			if(content && title_txt.visible){//划线
				rectbg.graphics.beginFill(0x999999);
				rectbg.graphics.drawRect(xx,title_txt.y+title_txt.height, ww, _Stage.stageHeight/800);
				rectbg.graphics.endFill();
			}
			if(btn_arr && btn_arr.length > 0){//划线
				rectbg.graphics.beginFill(0x999999);
				rectbg.graphics.drawRect(xx,liney, ww, _Stage.stageHeight/800);
				rectbg.graphics.endFill();
			}
		}
		private static var btns_bottom:Sprite = new Sprite();
		private static var btns_mid:Sprite = new Sprite();

		private static function make_vert_btns(content_arr:Array):int
		{
			var startx:int = xx;
			var starty:int = title_txt.y + title_txt.height*1.5;
			if(content_arr && content_arr.length > 0)
			{
				logs.adds(content_arr);
				main.addChild(btns_mid);
				var btnw:int =ww;
				var btnh:int = _Stage.stageHeight*.04;
				var btn_gap:int = btnh*.2;
				for each(var o:Object in content_arr)
				{
					logs.adds(o.str);
					var okBtn:TxtBtn;
					okBtn = new TxtBtn((o.str),o.fun,startx,starty);
					okBtn.setformat(btnw-1,btnh,TextFieldAutoSize.CENTER,0xffffff,0xffffff,0x0,0x0,0xffffff);
					btns_mid.addChild(okBtn);
					starty += btn_gap+btnh;
				}
				starty += btn_gap;
			}else{
				ViewSet.removes(btns_mid);
			}
			return starty;
		}

		private static function back(e:Event=null):void
		{
			clearTimeout(timeout);
			main.visible = false;
		}
	}
}

