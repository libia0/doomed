package
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.greensock.TweenLite;

	public class DragPage extends Sprite
	{
		public static const TO_NEXT:String = "to_next";
		public static const TO_PREV:String = "to_prev";
		public static const TO_BORDER:String = "to_border";
		public function DragPage()
		{
			/*mouseChildren = false;*/
			addEventListener(MouseEvent.MOUSE_DOWN,MouseEvents);
			addEventListener(Event.REMOVED_FROM_STAGE,clears);
		}

		private function clears(e:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,MouseEvents);
			removeEventListener(Event.REMOVED_FROM_STAGE,clears);
			ViewSet.removes(this);
		}

		private var has_gray:Boolean = false;

		/*
		public function add_gray():void
		{
			if(has_gray)return;
			has_gray = true;
			var target:DragPage = this;
			var gray_mask:Shape = new Shape();
			gray_mask.alpha = .1;
			gray_mask.graphics.beginFill(0x0) ;
			gray_mask.graphics.drawRect(0,0,jiapu.stageW,jiapu.stageH);
			gray_mask.graphics.endFill();
			target.addChild(gray_mask);
			TweenLite.to(gray_mask,.9,{alpha:.5});
		}
		*/

		private var mouse_point:Point = new Point();
		private var mouse_point2:Point = new Point();
		private var bounds:Rectangle;
		private var isFrombord:Boolean = false;

		private function MouseEvents(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					mouse_point = localToGlobal(new Point(mouseX,mouseY));
					isFrombord = Boolean(mouse_point.x<width/20);
					/*logs.adds(isFrombord);*/
					bounds = new Rectangle(-width,0,width*2,0);
					/*startDrag(false,bounds);*/
					stage.addEventListener(MouseEvent.MOUSE_UP,MouseEvents);
					/*stage.addEventListener(MouseEvent.MOUSE_OUT,MouseEvents);*/
					break;
				case MouseEvent.MOUSE_UP:
					/*case MouseEvent.MOUSE_OUT:*/
					stage.removeEventListener(MouseEvent.MOUSE_UP,MouseEvents);
					/*stage.removeEventListener(MouseEvent.MOUSE_OUT,MouseEvents);*/
					/*stopDrag();*/
					mouse_point2 = localToGlobal(new Point(mouseX,mouseY));
					var deltaX:Number = (mouse_point.x - mouse_point2.x);
					logs.adds(deltaX);
					if(deltaX > width/4){
						to_next();
					}else if(deltaX < -width/4){
						to_prev();
					}else{
						to_old();
					}
					break;
			}

		}

		public function from_left(e:Event=null):void
		{
			x = 0;
			TweenLite.from(this,1,{x:-width,onComplete:to_end,onCompleteParams:[-1]});
		}

		public function to_left(e:Event=null):void
		{
			/*logs.txt.visible = true;*/
			/*logs.adds("================",x,width);*/
			TweenLite.to(this,1,{x:-width,onComplete:to_end,onCompleteParams:[-1]});
			/*TweenLite.to(FamilyMsg.mains,1,{x:-jiapu.stageW});*/
		}

		public function to_right(e:Event=null):void
		{
			TweenLite.to(this,1,{x:width,onComplete:to_end,onCompleteParams:[1]});
		}
		public function from_right(e:Event=null):void
		{
			x = 0;
			TweenLite.from(this,1,{x:width,onComplete:to_end,onCompleteParams:[1]});
		}

		private function to_old(e:Event=null):void
		{
			/*TweenLite.to(this,1,{x:0});*/
		}

		private function to_next():void
		{
			if(isFrombord){
				dispatchEvent(new Event(TO_BORDER));
			}else{
				/*logs.adds(TO_NEXT);*/
				dispatchEvent(new Event(TO_NEXT));
				/*TweenLite.to(this,1,{x:-width,onComplete:to_end,onCompleteParams:[1]});*/
			}
		}
		private function to_prev():void
		{
			if(isFrombord){
				dispatchEvent(new Event(TO_BORDER));
			}else{
				/*logs.adds(TO_PREV);*/
				dispatchEvent(new Event(TO_PREV));
				/*TweenLite.to(this,1,{x:width,onComplete:to_end,onCompleteParams:[-1]});*/
			}
		}
		private function to_end(i:int):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}

