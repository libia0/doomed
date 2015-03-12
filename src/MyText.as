package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	//import flash.html.HTMLLoader;
	import flash.net.URLRequest;

	[SWF(width=500,height=400,backgroundColor=0xffffff)] public class MyText extends Sprite
	{
		private var html:BaseSprite = new BaseSprite();
		private var bar:Shape = new Shape();

		public function MyText(xx:int,yy:int,ww:int,hh:int,str:String,size:uint,_color:uint=0x00000,canRoll:Boolean=false)
		{
			/*logs.adds(xx,yy,ww,hh,str.length,size);*/
			with (bar) {
				graphics.clear();
				graphics.beginFill(0x00000, 0.8);
				graphics.drawRoundRect(0, 0, 6, 100, 6, 6);
				graphics.endFill();
			}
			addChild(bar).visible=false;
			bar.x = ww;


			var txt:TextField = new TextField();
			var txtformat:TextFormat = new TextFormat();
			txtformat.leading = 7;//行距
			/*txtformat.font = "黑体";*/
			/*txtformat.font = "Microsoft YaHei";*/
			txtformat.size= size;
			txtformat.color= _color;
			txt.defaultTextFormat = txtformat;
			/*ViewSet. make_txt(0,0,);*/
			x = xx;
			y = yy;
			txt.width = ww;

			cacheAsBitmap = true;

			txt.autoSize = "left";
			txt.multiline = true;
			txt.wordWrap = true;
			/*txt.border = true;*/

			html.addChild(txt);

			html.mouseChildren = false;
			addChild(html);
			html.mask = addChild(new Bitmap(new BitmapData(ww, hh)));
			/*html.y = html.mask.y+html.mask.height;*/
			/*html.x =xx;*/
			/*html.y =yy;*/
			/*html.addEventListener(MouseEvent.MOUSE_OVER, DragEvents.start_drags);*/
			html.addEventListener(MouseEvent.MOUSE_OVER, start_drags);
			/*txt.text = str;*/
			txt.htmlText= str;
			/*txt.text = "test";*/
			/*logs.adds(txt.defaultTextFormat.font);*/
			/*txt.setTextFormat(txtformat);*/

			if(canRoll){
				removeEventListener(Event.ENTER_FRAME,autoup);
				addEventListener(Event.ENTER_FRAME,autoup);
			}
		}
		public function set text(s:String):void
		{
			/*txt.text = s;*/
		}

		private function autoup(e:Event):void
		{
			if(html.y + html.height - 100 < html.mask.y)
			{
				/*logs.adds("_____next dir_____");*/
				dispatchEvent(new Event(Event.COMPLETE));
				removeEventListener(Event.ENTER_FRAME,autoup);
			}
			if(html==null || html.mask == null){
				removeEventListener(Event.ENTER_FRAME,autoup);
				return;
			}
			if(html.y + html.height + 3 > html.mask.y){
				html.y-=8;
			}else{
				html.y = html.mask.y+html.mask.height;
			}
		}

		public static function start_drags(e:MouseEvent):void
		{
			var target:Sprite = e.target as BaseSprite;
			if(target == null)return;
			var targetMask:DisplayObject = target.mask as DisplayObject;
			if (targetMask == null) {
				if (target.stage) {
					targetMask = new Bitmap(new BitmapData(target.stage.stageWidth,target.stage.stageHeight));
				}else {
					return;
				}
			}
			var bar:DisplayObject = target.parent["bar"] as DisplayObject;
			if(target.height < targetMask.height)return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_OVER: 
					target.addEventListener(MouseEvent.MOUSE_DOWN,start_drags);
					target.addEventListener(MouseEvent.MOUSE_WHEEL,start_drags);
					break;
				case MouseEvent.MOUSE_DOWN: 
					if(bar)bar.visible = true;
					/*TweenLite.killtweenof(bar);*/
					TweenLite.to(bar,.3,{alpha:1});
					target.startDrag(false, new Rectangle(target.x,targetMask.height+ targetMask.y, 0,- targetMask.height - target.height));
					target.addEventListener(MouseEvent.MOUSE_UP, start_drags);
					target.addEventListener(MouseEvent.MOUSE_OUT, start_drags);
					target.addEventListener(MouseEvent.MOUSE_MOVE, start_drags);
					break;
				case MouseEvent.MOUSE_UP: 
				case MouseEvent.MOUSE_OUT: 
					if(bar)bar.visible = true;
					/*TweenLite.killtweenof(bar);*/
					TweenLite.to(bar,.3,{alpha:0});
					target.stopDrag();
					target.removeEventListener(MouseEvent.MOUSE_UP, start_drags);
					target.removeEventListener(MouseEvent.MOUSE_OUT, start_drags);
					target.removeEventListener(MouseEvent.MOUSE_MOVE, start_drags);
				case MouseEvent.MOUSE_WHEEL:
					if(e.delta > 0 ){
						target.y += targetMask.height;
					}else if (e.delta < 0) {
						target.y -= targetMask.height;
					}

					if( target.y > targetMask.y )
					{
						TweenLite.to(target,.2,{y :targetMask.y});
					}else if( target.y + target.height<targetMask.y+targetMask.height )
					{
						TweenLite.to(target,.2,{y :targetMask.y + targetMask.height - target.height});
					}
					break;
				case MouseEvent.MOUSE_MOVE: 
				default: 
			}
			/**
			 *	滚动条
			 */
			bar.x = targetMask.x+targetMask.width;
			bar.y = targetMask.y;
			if( bar==null )
			{
				return;
			}else {
				/*bar.height = targetMask.height * targetMask.height / target.height;*/
				/*bar.visible = true;*/
			}
			var rate:Number = (targetMask.y - target.y)/(target.height-targetMask.height);
			setBar(bar,rate,targetMask.height);
		}

		/**
		 * 设定滑块的位置 
		 * @param bar:Sprite
		 * @return  
		 */
		private static function setBar(bar:DisplayObject,rate:Number,moveheight:int):void
		{
			/*logs.adds(bar,rate);*/
			if(rate>1)rate = 1;
			else if(rate<0)rate=0;
			bar.y = (moveheight-bar.height)*rate;
		}
	}
}

