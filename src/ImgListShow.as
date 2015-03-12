/**
   use:
   var rate:Number = .9;
   var w:int = stage.stageWidth;
   var h:int = stage.stageHeight;
   var rect:Rectangle = new Rectangle((1-rate)/2*w,(1-rate)/2*h,w*rate,h*rate);
   var close_btn:Sprite = new Sprite();
   var next_btn:Sprite = new Sprite();
   var prev_btn:Sprite = new Sprite();
   [Embed(source="prev.png")] var prevpng:Class;
   [Embed(source="next.png")] var nextpng:Class;
   [Embed(source="close.png")] var closepng:Class;
   prev_btn.addChild(new prevpng);
   next_btn.addChild(new nextpng);
   close_btn.addChild(new closepng);
   prev_btn.x=(.5-rate/2)*w-prev_btn.width/2;
   next_btn.x=(.5+rate/2)*w-next_btn.width/2;
   prev_btn.y = next_btn.y = h/2-prev_btn.height/2;
   close_btn.x=(.5+rate/2)*w-close_btn.width/2;
   close_btn.y=(.5+rate/2)*h-close_btn.height/2;
   imglistshow = new ImgListShow(rect,close_btn,next_btn,prev_btn);



   imglistshow.init_bmpArr(bmpArr);
   imglistshow.show(index);
 */
package
{
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	
	public class ImgListShow extends Sprite
	{
		private var bmpArr:Array;
		private var cur_bmp:Bitmap;
		private var index:int;
		private var rect:Rectangle;
		private var close_btn:Sprite;
		private var prev_btn:Sprite;
		private var next_btn:Sprite;
		
		public function ImgListShow(_rect:Rectangle, close_btn:Sprite = null, next_btn:Sprite = null, prev_btn:Sprite = null)
		{
			rect = _rect;
			/*
			   if(close_btn){
			   this.close_btn = close_btn;
			   close_btn.addEventListener(MouseEvent.CLICK,close);
			   addChild(close_btn);
			   }
			   if(prev_btn){
			   this.prev_btn = prev_btn;
			   prev_btn.addEventListener(MouseEvent.CLICK,prev);
			   addChild(prev_btn);
			   }
			   if(next_btn){
			   this.next_btn = next_btn;
			   next_btn.addEventListener(MouseEvent.CLICK,next);
			   addChild(next_btn);
			   }
			 */
			if (stage)
				addbg();
			else
				addEventListener(Event.ADDED_TO_STAGE, addbg);
			close();
		}
		private var mousex:int = 0;
		
		private function MouseEvents(e:Event):void
		{
			if (stage)
				switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					mousex = stage.mouseX;
					stage.addEventListener(MouseEvent.MOUSE_UP, MouseEvents);
					break;
				case MouseEvent.MOUSE_UP: 
					if (mousex - stage.mouseX > stage.stageWidth / 2)
						next();
					else if (mousex - stage.mouseX < -stage.stageWidth / 2)
						prev();
					
					stage.removeEventListener(MouseEvent.MOUSE_UP, MouseEvents);
					break;
			}
		}
		
		public function init_bmpArr(_bmpArr:Array):void
		{
			if (bmpArr)
				bmpArr.splice(0, bmpArr.length);
			for each (var o:Object in _bmpArr)
			{
				if (bmpArr == null)
					bmpArr = new Array;
				bmpArr.push(o);
			}
		}
		
		public function close(e:Event = null):void
		{
			visible = false;
			if (cur_bmp)
			{
				if (contains(cur_bmp))
					removeChild(cur_bmp);
				cur_bmp = null;
			}
		}
		
		public function show(_index:int = 0):void
		{
			visible = true;
			trace(_index, index);
			/*if(_index == index)return;*/
			
			var prev_bmp:Bitmap;
			var toleft:Boolean = Boolean(_index > index);
			if (cur_bmp && cur_bmp.parent)
			{
				prev_bmp = cur_bmp;
			}
			
			index = _index;
			if (bmpArr == null || index < 0 || index >= bmpArr.length)
				return;
			var bmp:Bitmap = bmpArr[index] as Bitmap;
			var url:String = bmpArr[index] as String;
			if (bmp)
			{
				cur_bmp = new Bitmap(bmp.bitmapData);
				show_bmp();
			}
			else if (url && url.match(/(\.jpg$)|(\.png$)|(\.jpeg$)|(\.gif$)/i))
			{
				SwfLoader.SwfLoad(url, show_bmp);
			}
			
			/*
			   if(prev_bmp){
			   if(toleft){
			   TweenLite.to(prev_bmp,1,{x:-width,onComplete:remove_prev,onCompleteParams:[prev_bmp]});
			   TweenLite.from(cur_bmp,1,{x:width});
			   }else{
			   TweenLite.to(prev_bmp,1,{x:width,onComplete:remove_prev,onCompleteParams:[prev_bmp]});
			   TweenLite.from(cur_bmp,1,{x:-width});
			   }
			   return;
			   }
			 */
			remove_prev(prev_bmp);
			prev_bmp = null;
		}
		
		private var touchtowpoint:TouchTowPoint;
		
		private function show_bmp(e:Event = null):void
		{
			if (e && Event.COMPLETE == e.type)
				cur_bmp = e.target.content as Bitmap;
			if (cur_bmp)
			{
				if (touchtowpoint)
				{
					if (touchtowpoint.parent)
						touchtowpoint.parent.removeChild(touchtowpoint);
					touchtowpoint = null;
				}
					touchtowpoint = new TouchTowPoint();
				ViewSet.removes(touchtowpoint);
				if (close_btn)
					addChild(close_btn);
				if (prev_btn)
					addChild(prev_btn);
				if (next_btn)
					addChild(next_btn);
				touchtowpoint.addEventListener("hidelist", hidelist);
				touchtowpoint.addEventListener("showlist", showlist);
				touchtowpoint.x = touchtowpoint.x = 0;
				touchtowpoint.scaleX = touchtowpoint.scaleY = 1;
				touchtowpoint.rotation = 0;
				ViewSet.center_rect(cur_bmp, rect);
				addChild(touchtowpoint);
				touchtowpoint.addChild(cur_bmp);
			}
			else
			{
				trace("no bmp");
			}
		}
		
		private function showlist(e:Event):void
		{
			dispatchEvent(new Event("showlist"));
		}
		
		private function hidelist(e:Event):void
		{
			dispatchEvent(new Event("hidelist"));
		}
		
		private function remove_prev(bmp:DisplayObject):void
		{
			if (bmp && bmp.parent)
			{
				bmp.parent.removeChild(bmp);
				bmp = null;
			}
		}
		
		public function prev(e:Event = null):void
		{
			if (bmpArr && bmpArr.length > 0)
			{
				index--;
				if (index < 0)
					index = bmpArr.length - 1;
				show(index);
			}
		}
		
		public function next(e:Event = null):void
		{
			if (bmpArr && bmpArr.length > 0)
			{
				index++;
				if (index >= bmpArr.length)
					index = 0;
				show(index);
			}
		}
		
		private function addbg(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addbg);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseEvents);
		/*addChildAt(new Bitmap(new BitmapData(stage.stageWidth,stage.stageHeight,true,0x99000000)),0);*/
		}
	}
}

