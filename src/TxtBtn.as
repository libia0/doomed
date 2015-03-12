/**
 *
 var btn:TxtBtn = new TxtBtn("确定",fun,0,0,null,16);
 btn.setformat(100,30,"center");
 addChild(btn);
 *
 *
 *
 * @file TxtBtn.as
 *  
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-06-30
 */
package
{
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Shape;
	public class TxtBtn extends Sprite
	{
		public var cur_obj:Object=null;
		private var font_size:uint = 0;
		public function TxtBtn(s:String,f:Function,_x:int=0,_y:int =0,_cur_obj:Object=null,_font_size:uint=0)
		{
			/*mouseChildren = false;*/
			cur_obj = _cur_obj;
			func = f;
			font_size = _font_size;
			txtstr = Fanti.jian2fan(s);
			x = _x;
			y = _y;
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function set_fun(f:Function,_cur_obj:Object =null):void
		{
			cur_obj = _cur_obj;
			func = f;
		}
		public function get text():String
		{
			return txtstr;
		}
		public function set text(s:String):void
		{
			txtstr = Fanti.jian2fan(s);
			if(btntxt1)btntxt1.text = txtstr;
			if(btntxt2)btntxt2.text = txtstr;
		}
		private function init(e:Event = null):void
		{
			if(_width == 0)setformat();
			var btn:BtnBase = makebtn(txtstr,func,cur_obj);
			/*trace(txtstr);*/
			addChild(btn);
		}

		private var func:Function;
		private var txtstr:String;
		private var _width:int;
		private var _height:int;
		private var isvert:Boolean;
		private var autoSize:String = TextFieldAutoSize.LEFT;
		private var bgcolor1:uint=0xffffffff;
		private var bgcolor2:uint=0xffffffff;
		private var txt1color:uint=0xffffffff;
		private var txt2color:uint=0xffffffff;
		private var border_color:uint=0xffffffff;
		public function setformat(_w:int=0,_h:int=0,_autoSize:String="left",_bgcolor1:uint=0xffffffff,_bgcolor2:uint=0xffffffff,_txt1color:uint=0xffffffff,_txt2color:uint=0xff666666,_border_color:uint=0xffcccccc,_isvert:Boolean=false):void
		{
			_width = _w;
			_height = _h;
			if(_width == 0)_width = 5;
			if(_height==0)_height = 5;
			this.isvert = _isvert;
			autoSize = _autoSize;

			bgcolor1 = _bgcolor1;
			bgcolor2 = _bgcolor2;
			txt1color = _txt1color;
			txt2color = _txt2color;
			border_color = _border_color;
		}

		private var bg1:Bitmap;
		private var bg2:Bitmap;
		public function setbg(_bg1:Bitmap=null,_bg2:Bitmap=null):void
		{
			bg1=_bg1;
			bg2=_bg2;
			if(bg1){
				if( btn_on && btn_on.numChildren>1)
					btn_on.removeChildAt(0);
				btn_on.addChildAt(makebtnbg(0xff000000,1),0);
			}
			if(bg1){ 
				if(btn_out && btn_out.numChildren>1)
					btn_out.removeChildAt(0);
				btn_out.addChildAt(makebtnbg(0xff000000,2),0);
			}
		}

		private function makebtnbg(_color:uint,_index:int):DisplayObject
		{
			if(_index==1 && bg1){
				var bg1bmp:Bitmap = new Bitmap(bg1.bitmapData);
				bg1bmp.width = _width;
				bg1bmp.height= _height;
				return bg1bmp;
			}
			if(_index==2 && bg2){
				var bg2bmp:Bitmap = new Bitmap(bg2.bitmapData);
				bg2bmp.width = _width;
				bg2bmp.height= _height;
				return bg2bmp;
			}
			/*trace("the _color:0x"+_color.toString(16),uint(((_color>>24) & 0xff)).toString(16));*/
			var shape:Shape = new Shape();
			shape.graphics.beginFill(_color & 0xffffff,((_color>>24) & 0xff) / 0xff);
			/*shape.graphics.beginFill(_color&0xffffff,1);*/
			shape.graphics.lineStyle(1,border_color&0xffffff,((border_color>>24) & 0xff) / 0xff);
			var round_radio :int = Math.min(_height/4,_width/4);
			shape.graphics.drawRoundRect(0,0, _width, _height,round_radio,round_radio);
			shape.graphics.endFill();
			return shape;
		}
		private function makebtntxt(str:String,_color:uint,_size:int):TextField
		{
			var txt:TextField = new TextField();
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			var txtformat:TextFormat = new TextFormat("Microsoft YaHei", _size,_color);
			txt.defaultTextFormat = txtformat;
			if(isvert){
				txt.wordWrap = true;
				/*txt.border = true;*/
				txt.textColor= txt.borderColor = _color&0xffffff;
			}
			txt.width = _width;
			txt.height = _height;
			txt.text = Fanti.jian2fan(str);
			txt.autoSize = autoSize;
			txt.y = _height /2 - txt.height/2;
			return txt;
		}
		private var btntxt1:TextField;
		private var btntxt2:TextField;
		private var btn_on:Sprite = new Sprite();
		private var btn_out:Sprite = new Sprite();
		private function makebtn(str:String,fun:Function,_paras:Object=null):BtnBase
		{
			/*str=Fanti.jian2fan(str);*/
			if(font_size>0){
				_font_size = font_size;
			}else{
				if(isvert){
					var _font_size:int = _width*.6;
				}else{
					_font_size= _height*.5;
				}
			}
			btntxt1= makebtntxt(str,txt1color,_font_size);
			btntxt2= makebtntxt(str,txt2color,_font_size);

			if(!isvert){
				var btnbg1:DisplayObject= makebtnbg(bgcolor1,1);
				if(btnbg1)btn_on.addChild(btnbg1);
				var btnbg2:DisplayObject= makebtnbg(bgcolor2,2);
				if(btntxt2)btn_out.addChild(btnbg2);
			}

			btn_on.addChild(btntxt1);
			btn_out.addChild(btntxt2);
			var btn:BtnBase = new BtnBase(fun,btn_out,btn_on,_paras);
			return btn;
		}
	}
}

