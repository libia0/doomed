package 
{
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.display.Bitmap;

	import flash.geom.Rectangle; 

	/**
	 * ...
	 * @author db0@qq.com
	 */
	public class ViewSet 
	{

		public function ViewSet() 
		{
			/*stage.nativeWindow.addEventListener(StageDisplayState.FULL_SCREEN,resize);*/
		}
		/*
		   private static function resize(e:Event=null):void{
		   if(stage.displayState == StageDisplayState.NORMAL)
		   {
		   stage.nativeWindow.height= Capabilities.screenResolutionY*1.;
		   stage.nativeWindow.width = stage.nativeWindow.height/1920*1080;
		   stage.nativeWindow.x= Capabilities.screenResolutionX/2-stage.nativeWindow.width/2;
		   stage.nativeWindow.y= 0;
		   }else{
		   stage.displayState=StageDisplayState.FULL_SCREEN; //全屏
		   }
		   }
		 */
		public static function BoardTitle(str:String):TextField
		{
			var titleTxt:TextField = new TextField();
			titleTxt.defaultTextFormat = new TextFormat(null, 14, 0x664422, true);
			titleTxt.autoSize = "left";
			titleTxt.text = Fanti.jian2fan(str);
			titleTxt.selectable = false;
			return titleTxt;
		}
		/* -----------------------------------------------*/
		/**
		 * 将_container中的图片处理成平滑 的
		 *
		 * @return  
		 */
		public static function smoothings(_container:DisplayObjectContainer):void
		{

			logs.adds(_container is DisplayObjectContainer);
			var i:int = 0;
			while(i < _container.numChildren)
			{
				var obj:DisplayObject = _container.getChildAt(i);
				logs.adds(_container.getChildAt(i));
				var _bmp:Bitmap = obj as Bitmap;
				var shape:Shape= obj as Shape;
				var _container2:DisplayObjectContainer = obj as DisplayObjectContainer;
				if(_bmp)
				{
					/*bmp.pixelSnapping= "auto";*/
					_bmp.smoothing = true;
				}else if(_container2){
					smoothings(_container2);
				}else if (shape){
					/*shape.cacheAsBitmap = true;*/
					removeObj(shape);
					var bmpd:BitmapData = new BitmapData(shape.width/shape.scaleX,shape.height/shape.scaleY,true,0x00000000);
					bmpd.draw(shape);
					var newbmp:Bitmap =new Bitmap(bmpd,"auto",true);
					newbmp.x = shape.x;
					newbmp.y = shape.y;
					newbmp.scaleX = shape.scaleX;
					newbmp.scaleY = shape.scaleY;
					_container.addChildAt(newbmp,i);
				}
				++i;
			}
		}
		/* -----------------------------------------------*/
		/**
		 * 将_container中的文本处理成简体转繁体
		 *
		 * @return  
		 */
		public static function fanti_container(_container:DisplayObjectContainer):void
		{

			logs.adds(_container is DisplayObjectContainer);
			var i:int = 0;
			while(i < _container.numChildren)
			{
				var obj:DisplayObject = _container.getChildAt(i);
				logs.adds(_container.getChildAt(i));
				var txt:TextField= obj as TextField;
				var statictxt:StaticText= obj as StaticText;
				/*var mytext:TextSnapshot = this.textSnapshot; trace(mytext.getText(0, this.textSnapshot.charCount));*/
				var _container2:DisplayObjectContainer = obj as DisplayObjectContainer;
				if(_container2){
					fanti_container(_container2);
				}else if (txt){
					txt.text = Fanti.jian2fan(txt.text);
					/*}else if(statictxt instanceof is StaticText){*/
			}else if(statictxt is StaticText){
				/*statictxt.text =Fanti.jian2fan(statictxt.text);*/
				trace(String(StaticText(statictxt).text));
				/*
				   var geshi:TextFormat=new TextFormat();// 定义文本格式类的实例
				   geshi.bold=true;// 赋值加粗  geshi.font=“微软雅黑”；赋值字体
				   statictxt.setTextFormat(geshi);//； 设置给你的文本
				 */
			}
			++i;
			}
		}

		public static function maketxt(xx:int, yy:int,str:String, ww:int, hh:int, size:int,autoSize:String="left"):TextField
		{
			var txt:TextField = new TextField();
			/*txt.border = true;*/
			/*txt.type = TextFieldType.INPUT;*/
			txt.x = xx;
			txt.y = yy;
			txt.width = ww;
			txt.height = hh;
			/*txt.multiline = true;*/
			/*txt.wordWrap = true;*/
			/*txt.selectable = false;*/
			var txtformat:TextFormat = new TextFormat(null, size);
			txt.defaultTextFormat = txtformat;
			txt.autoSize = autoSize;
			txt.text = Fanti.jian2fan(str);
			return txt;
		}
		public static function setTxt(txt:TextField, xx:int, yy:int, ww:int, hh:int, size:int, parent:DisplayObjectContainer):void
		{
			txt.border = true;
			txt.type = TextFieldType.INPUT;
			txt.x = xx;
			txt.y = yy;
			txt.width = ww;
			txt.height = hh;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.defaultTextFormat = new TextFormat(null, size);
			if (parent)
				parent.addChild(txt);
		}
		/**
		 * 在指定的矩形区域内最大化显示
		 * @param	yy
		 * @param	ww
		 * @param	hh
		 */
		public static function center_rect(obj:DisplayObject, rect:Rectangle):void
		{
			var xx:int = rect.x;
			var yy:int = rect.y;
			var ww:int = rect.width;
			var hh:int = rect.height;
			var scalex:Number = ww / obj.width;
			var scaley:Number = hh / obj.height;

			obj.x = xx;
			obj.y = yy;
			obj.scaleX = obj.scaleY = Math.min(scalex, scaley);
			if (scalex < scaley)
				obj.y = yy + (hh - obj.height) / 2;
			if (scalex >= scaley)
				obj.x = xx + (ww - obj.width) / 2;
		}
		/**
		 * 在指定的矩形区域内最大化显示
		 * @param	obj
		 * @param	xx
		 * @param	yy
		 * @param	ww
		 * @param	hh
		 */
		public static function fullCenter(obj:DisplayObject,xx:int,yy:int,ww:int,hh:int):void
		{
			var scalex:Number = ww / obj.width;
			var scaley:Number = hh / obj.height;

			obj.x = xx;
			obj.y = yy;
			obj.scaleX = obj.scaleY = Math.min(scalex, scaley);
			if (scalex > scaley) obj.x = xx + (ww - obj.width) / 2;
			if (scalex <= scaley) obj.y = yy + (hh - obj.height) / 2;
		}

		/**
		 * 不缩放，居中显示
		 * @param	obj
		 * @param	xx
		 * @param	yy
		 * @param	ww
		 * @param	hh
		 */
		public static function center(obj:DisplayObject,xx:int,yy:int,ww:int,hh:int):void
		{
			obj.x = xx +ww/2- obj.width/2 ;
			obj.y = yy +hh/2- obj.height/2 ;
		}


		/**
		 * 在遮罩范围内拖动
		 * @param	e
		 */
		public static function drags(e:MouseEvent):void
		{
			var target:Sprite = e.target as Sprite;
			if(target == null)return;
			var targetMask:DisplayObject = target.mask as DisplayObject;
			if(targetMask == null)return;

			if(target.height < targetMask.height)return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					target.startDrag(false, new Rectangle(target.x,targetMask.height+ targetMask.y, 0,- targetMask.height - target.height));
					target.addEventListener(MouseEvent.MOUSE_UP, drags);
					target.addEventListener(MouseEvent.MOUSE_OUT, drags);
					target.addEventListener(MouseEvent.MOUSE_MOVE, drags);
					break;
				case MouseEvent.MOUSE_UP: 
				case MouseEvent.MOUSE_OUT: 
					target.stopDrag();
					target.removeEventListener(MouseEvent.MOUSE_UP, drags);
					target.removeEventListener(MouseEvent.MOUSE_OUT, drags);
					target.removeEventListener(MouseEvent.MOUSE_MOVE, drags);
					if( target.y > targetMask.y ) {
						target.y =targetMask.y;
					}else if( target.y + target.height<targetMask.y+targetMask.height ) {
						target.y = targetMask.y + targetMask.height - target.height;
					}
					break;
				case MouseEvent.MOUSE_MOVE: 
				default: 
			}

			var bar:Sprite = target.parent["bar"];//拖动条的显示
			logs.adds(bar);
			if( bar==null ) {
				return;
			}else {
				var cursor:DisplayObject = bar.getChildAt(bar.numChildren-1);//拖动条
				cursor.height = bar.height * targetMask.height / target.height;
			}
			var rate:Number = (targetMask.y - target.y)/(target.height-targetMask.height);//当前移动的位置【0-1】0为最顶端，1为最低端
			setBar(bar,rate);
		}

		public static function setBar(bar:Sprite,rate:Number):void
		{
			logs.adds(bar,rate);
			if(rate>1)rate = 1;
			else if (rate < 0) rate = 0;
			var cursor:DisplayObject = bar.getChildAt(bar.numChildren-1);
			cursor.y = (bar.height-cursor.height)*rate;
		}
		public static function make_txt(xx:int, yy:int, _str:String,ww:int=100,hh:int=100, color:uint=0x0,size:uint=16,_wordWrap:Boolean=false,font:String="Microsoft YaHei"):TextField
		{
			var _txt:TextField = new TextField();
			_txt.defaultTextFormat = new TextFormat(font, size, color,false);
			/*_txt.border = true;*/
			_txt.wordWrap = _wordWrap;
			/*_txt.selectable = false;*/
			_txt.x = xx;
			_txt.y = yy;
			_txt.width = ww;
			_txt.height = hh;
			_txt.text = Fanti.jian2fan(String(_str));
			return _txt;
		}

		public static function removes(container:DisplayObjectContainer):void
		{
			if(container==null)return;
			if(int(SystemCall.flashplayer_version[0])>=11){
				container["removeChildren"]();
			}else{
				var i:int = container.numChildren;
				while (i > 0) 
				{
					--i;
					var obj:DisplayObject = container.getChildAt(i);
					if(obj==null)continue;
					removeObj(obj);
					if (obj is Bitmap) Bitmap(obj).bitmapData.dispose();
					if (obj is MovieClip) MovieClip(obj).stop();
					obj = null;
				}
			}
		}

		public static function clearObj(obj:DisplayObject):void
		{
			removes(obj as DisplayObjectContainer);
			removeObj(obj);
			obj = null;
		}
		public static function removeObj(obj:DisplayObject):void
		{
			if(obj is DisplayObject && obj.parent)
				obj.parent.removeChild(obj);
		}

		/**
		 * 滑块滑动的设定显示位置 
		 * @param bar:Sprite
		 * @return  
		 */
		public static function setPosByBar(bar:DisplayObject,dragTarget:DisplayObject):void
		{
			if(dragTarget.mask.height > dragTarget.height){
				dragTarget.y = dragTarget.mask.y;
				return;
			}
			var rate:Number = -(dragTarget.mask.y - bar.y)/dragTarget.mask.height;
			if(rate>1)rate = 1;
			else if(rate<0)rate=0;
			dragTarget.y = dragTarget.mask.y - (dragTarget.height-dragTarget.mask.height)*rate;
		}

		/**
		 * 设定滑块的位置 
		 * @param bar:Sprite
		 * @return  
		 */
		public static function setBarPos(bar:DisplayObject,dragTarget:DisplayObject):void
		{
			if(dragTarget.mask.height > dragTarget.height){
				bar.y = dragTarget.mask.y;
				return;
			}
			var rate:Number = -(dragTarget.y - dragTarget.mask.y)/(dragTarget.height-dragTarget.mask.height);
			if(rate>1)rate = 1;
			else if(rate<0)rate=0;
			bar.y = dragTarget.mask.y + rate*(dragTarget.mask.height-bar.height);
		}

		/* -----------------------------------------------*/
		/**
		 *  make a invisible TextField button
		 *
		 * @param _x:int
		 * @param _y:int
		 * @param _s:String
		 * @param _w:int
		 * @param _h:int
		 * @param fun:Function
		 *
		 * @return  TextField
		 */
		public static function makebtn(_x:int,_y:int,_s:String,_w:int,_h:int,fun:Function):Sprite
		{
			var container:Sprite = new Sprite;
			var txt:TextField = new TextField();
			container.addChild(txt);
			with(txt){
				width=_w;
				height=_h;
				text = _s;
				border = true;
				selectable = false;
				name = _s;
				alpha = 0;
			}
			CONFIG::debugging{
				txt.alpha= 1;
			}
			with(container){
				y=_y;
				x=_x;
				name = _s;
				mouseChildren = false;
				buttonMode= true;
				addEventListener(MouseEvent.CLICK,fun);
			}
			return container;
		}

		public static function makeBtnByDirs(dirs:Array):Sprite
		{
			if(dirs){
				var btns:Sprite;
				var i:int = 0;
				for each(var dir_name:String in dirs){
					var btn_str:String = dir_name.replace(/^.*[\/\\]([^\/\\]+)[\/\\]*$/, "$1");
					btn_str = btn_str.replace(/^[\d]*/,"");
					//trace("btn_str,"+btn_str);
					if(btn_str){
						var btn:TxtBtn = new TxtBtn(btn_str,null,0,0,btn_str,16);
						/*
						[Embed(source="dc/assets/btnbg.png")] var btnbgpng:Class;
						btn.addChildAt(new btnbgpng,0);
						*/
						btn.setformat(106,33,"center");

						if(btns==null)btns = new Sprite;
						btns.addChild(btn);
					}
					++i;
				}
				return btns;
			}
			return null;
		}
	}
}
