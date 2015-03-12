package
{
	import flash.geom.Point;
	import flash.filters.GlowFilter;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	public class BtnBase extends Sprite
	{
		/*public static const CLICKED:String = "_clicked";*/
		private var mouse_effect:Sprite = new Sprite();
		private var bg:Sprite = new Sprite();
		private var clicked_func:Function = null;
		private var clicked_func_paras:Object= null;

		public function BtnBase(_clicked:Function = null,_bg:DisplayObject= null,_effect:DisplayObject= null,_paras:Object = null)
		{
			addChild(bg);
			addChild(mouse_effect);

			bg.mouseChildren = false;
			mouse_effect.mouseChildren = false;
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN,MouseEvents);
			addEventListener(MouseEvent.MOUSE_OVER,MouseEvents);
			addEventListener(MouseEvent.MOUSE_OUT,MouseEvents);
			init(_clicked,_bg,_effect,_paras);
			clicking = false;
		}

		public function init(_clicked:Function,_bg:DisplayObject,_effect:DisplayObject,_paras:Object=null):void
		{
			if(_bg){
				ViewSet.removes(bg);
				bg.addChild(_bg);
			}
			if(_effect){
				ViewSet.removes(mouse_effect);
				mouse_effect.addChild(_effect);
			}
			if(_clicked != null)clicked_func = _clicked;
			if(_paras!= null)clicked_func_paras = _paras;
		}

		private var _mouseX:int;
		private var _mouseY:int;
		private var _X:int;
		private var _Y:int;
		private var _moved:Boolean;
		private static var cur_clicked_obj:BtnBase;
		private function MouseEvents(e:MouseEvent):void
		{
			var curp:Point = localToGlobal(new Point(0,0));
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					cur_clicked_obj = this;
					clicking = true;
					_mouseX =stage.mouseX;
					_mouseY =stage.mouseY;

					_X = curp.x;
					_Y = curp.y;
					_moved = false;
					addEventListener(MouseEvent.MOUSE_UP,MouseEvents);
					addEventListener(MouseEvent.MOUSE_MOVE,MouseEvents);
					addEventListener(MouseEvent.MOUSE_OUT,MouseEvents);
					break;
				case MouseEvent.MOUSE_MOVE:
					if(
							Math.abs(_mouseX - stage.mouseX) + Math.abs(_mouseY - stage.mouseY) > 10
							|| 
							Math.abs(_X - curp.x) + Math.abs(_Y - curp.y) > 10
					  ){
						_moved = true;
						removeEventListener(MouseEvent.MOUSE_MOVE,MouseEvents);
					}
					break;
				case MouseEvent.MOUSE_UP:
					clicking = false;
					removeEventListener(MouseEvent.MOUSE_UP,MouseEvents);
					removeEventListener(MouseEvent.MOUSE_MOVE,MouseEvents);
					/*removeEventListener(MouseEvent.MOUSE_OUT,MouseEvents);*/
					/*logs.adds(_moved,clicked_func == null);*/
					if(!_moved && cur_clicked_obj == this){
						/*this.dispatchEvent(new Event(CLICKED));*/
						if(clicked_func != null){
							if(clicked_func_paras)clicked_func(clicked_func_paras);
							else clicked_func();
						}
						break;
					}
				case MouseEvent.MOUSE_OUT:
					clicking = false;
					break;
				case MouseEvent.CLICK:
					break;
				case MouseEvent.MOUSE_OVER://pc上鼠标经过的效果跟按下一样
					clicking = true;
				default:
			}
		}

		public function get clicking():Boolean
		{
			return mouse_effect.visible;

		}

		public function set clicking(b:Boolean):void
		{
			mouse_effect.visible = b;
			if(b){
				bg.filters = [new GlowFilter(0x0,.5)];
			}else{
				bg.filters = [];
			}
		}

		/*
		public static function get Listbtn():Sprite
		{
			var mc:Sprite = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xdd2211);
			shape.graphics.drawRect(0,0, Header.btn_width, Header.hh);
			shape.graphics.lineStyle(2,0xffffff);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh*.3);
			shape.graphics.lineTo(Header.btn_width/4*3,Header.hh*.3);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh/2);
			shape.graphics.lineTo(Header.btn_width/4*3,Header.hh/2);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh*.7);
			shape.graphics.lineTo(Header.btn_width/4*3,Header.hh*.7);
			shape.graphics.endFill();
			mc.addChild(shape);
			return mc;
		}
		public static function get Searchbtn():Sprite
		{
			var mc:Sprite = new Sprite();
			var shape:Shape = new Shape();

			shape.graphics.beginFill(0xdd2211);
			shape.graphics.drawRect(0,0, Header.btn_width, Header.hh);
			shape.graphics.endFill();
			shape.graphics.beginFill(0xdd2211);
			shape.graphics.lineStyle(2,0xffffff);
			shape.graphics.drawCircle(Header.btn_width/2,Header.hh/2,Header.hh / 6);
			shape.graphics.moveTo(Header.btn_width*.63,Header.hh*.63);
			shape.graphics.lineTo(Header.btn_width*.7,Header.hh*.7);
			shape.graphics.endFill();
			mc.addChild(shape);
			return mc;
		}
		public static function get Toleftbtn():Sprite
		{
			var mc:Sprite = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xdd2211);
			shape.graphics.drawRect(0,0, Header.btn_width, Header.hh);
			shape.graphics.lineStyle(2,0xffffff);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh/2);
			shape.graphics.lineTo(Header.btn_width*.75,Header.hh/2);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh/2);
			shape.graphics.lineTo(Header.btn_width*.5,Header.hh*.25);
			shape.graphics.moveTo(Header.btn_width/4,Header.hh/2);
			shape.graphics.lineTo(Header.btn_width*.5,Header.hh*.75);
			shape.graphics.endFill();
			mc.addChild(shape);
			mc.mouseChildren = false;
			return mc;
		}
		*/
	}
}

