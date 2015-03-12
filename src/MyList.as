/**
 * @file MyList.as
 *  

 mylist = new MyList();
 mylist.addEventListener(Event.SELECT,on_click_show);
 mylist.setVRoll(true);//竖直方向
 mylist.MaskRect = _rect;
 private function on_click_show(e:Event=null):void{
 var target:Sprite = mylist.ClickObject;
 select_index = uint(target.name.substr(1));
 trace(select_index);
 dispatchEvent(new Event(Event.SELECT));
 }

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-07-02
 */
package
{
	import flash.display.DisplayObject;
	import flash.utils.*;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	public class MyList extends Sprite
	{
		public var canDrag:Boolean = true;
		private var pagesize:int=0;
		private function get curPage():int
		{
			if(pagesize > 0 && numItems>0){
				var i:int = 0;
				while(i*pagesize < numItems){
					var obj:DisplayObject = getItemAt(i*pagesize);
					if(obj.x +container.x >= theMask.x && obj.y+container.y >= theMask.y && obj.x + container.x <= theMask.x+theMask.width && obj.y + container.y <= theMask.y + theMask.height)
						return i;
					++i;
				}
				return 0;
			}
			return 0;
		}
		private var theMask:Bitmap;
		private var bg:Sprite;
		public function set MaskRect(rect:Rectangle):void
		{
			theMask.width = Math.abs(rect.right - rect.left);
			theMask.height= Math.abs(rect.bottom - rect.top);
			theMask.x= rect.left;
			theMask.y= rect.top;
			container.mask = theMask;
		}

		private var rollRect:Rectangle;
		private var isVRoll:Boolean = true;
		public function setVRoll(b:Boolean):void
		{
			isVRoll =b;
		}

		public function MyList(_pagesize:int=0)
		{
			pagesize = _pagesize;
			if(bg== null){
				bg = new Sprite();
				bg.addChild(new Bitmap(new BitmapData(20,20)));
				bg.mouseChildren = false;
			}
			container = new Sprite();
			theMask = new Bitmap(new BitmapData(2,2));
			addChild(container);
			addChild(theMask);
			addEventListener(MouseEvent.MOUSE_DOWN,drags);
		}

		private var moveStartTime:int;
		private var moveStartPos:int;
		private function drags(e:MouseEvent):void
		{
			if(!canDrag)return;
			initBg();
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					TweenLite.killTweensOf(container);
					moveStartTime = getTimer();
					if(isVRoll) moveStartPos = container.y;
					else moveStartPos = container.x;
					stage.addEventListener(MouseEvent.MOUSE_UP,drags);
					/*container.addEventListener(MouseEvent.MOUSE_OUT,drags);*/
					if(isVRoll)container.startDrag(false,new Rectangle(theMask.x,theMask.y+theMask.height,0,-theMask.height-container.height));
					else container.startDrag(false,new Rectangle(theMask.x+theMask.width,theMask.y,-theMask.width-container.width,0));
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OUT:
					if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP,drags);
					/*container.removeEventListener(MouseEvent.MOUSE_OUT,drags);*/
					container.stopDrag();
					clearTimeout(timeoutId);
					if(can_back){
						/*
						   timeoutId = setTimeout(backtoShow,100);
						 */
						var moveY:int = container.x - moveStartPos;
						if(isVRoll) moveY = container.y - moveStartPos;
						var moveTime:int = getTimer() - moveStartTime;
						var speed:Number = moveY*300.0/moveTime;
						if(isVRoll)
							TweenLite.to(container,speed/1000,{y:container.y + speed,onComplete:backtoShow});
						else
							TweenLite.to(container,speed/1000,{x:container.x + speed,onComplete:backtoShow});
					}
					break;
			}

		}

		public function show_index(_index:int):DisplayObject
		{
			return null;
			var i:int = 0;
			while(i<container.numChildren)
			{
				var target:DisplayObject = getItemAt(i);
				var _i:int = int(target["name"]["substr"](1));
				if(_i == _index){
					trace("show_index:",_i);
					if(isVRoll)
						if(container.y < container.mask.y - target.y){
							trace("down");
							container.y = container.mask.y - target.y;
						}else if( container.y > ( container.mask.y + container.mask.height -target.height - target.y)){
							trace("up");
							container.y = ( container.mask.y + container.mask.height -target.height - target.y);
						}


					return target;
				}
				++i;
			}
			return null;
		}

		private var can_back:Boolean = true;

		public function set canback(b:Boolean):void
		{
			can_back = b;
		}

		private var timeoutId:uint;
		private function backtoShow():void
		{
			clearTimeout(timeoutId);
			if(isVRoll){
				if(container.y >theMask.y){
					TweenLite.to(container,.3,{y:theMask.y});
				}else if(container.height> theMask.height){
					if(container.y + container.height< theMask.y +theMask.height)
						TweenLite.to(container,.3,{y:theMask.y+theMask.height - container.height});
				}else{
					TweenLite.to(container,.3,{y:theMask.y});
				}
			}else{
				if(container.x >theMask.x){
					TweenLite.to(container,.3,{x:theMask.x});
				}else if(container.width > theMask.width){
					if(container.x + container.width  < theMask.x +theMask.width)
						TweenLite.to(container,.3,{x:theMask.x+theMask.width - container.width});
				}else{
					TweenLite.to(container,.3,{x:theMask.x});
				}
			}
		}

		public function set page(i:int):void
		{
			if(isVRoll){
				container.y = i*container.height/theMask.height;
			}else{
				container.x = i*container.width/theMask.width;
			}
			backtoShow();
		}

		public function nextPage():void
		{
			if(pagesize>0){ 
				if( pagesize *(curPage+1)< numItems){
					trace(curPage+1);
					var obj:DisplayObject = getItemAt(pagesize*(curPage+1));
					TweenLite.to(container,1,{x:-obj.x + theMask.x ,y:-obj.y+theMask.y});
				}
				return;

			}
			if(isVRoll){
				if(container.height> theMask.height){
					if(container.y < theMask.y )
						container.y += theMask.height;
				}
			}else{
				if(container.width> theMask.width){
					if(container.x < theMask.x )
						container.x += theMask.width;
				}
			}
			backtoShow();
		}


		public function prevPage():void
		{
			if(pagesize>0){
				if(pagesize *(curPage-1)>= 0){
					trace(curPage-1);
					var obj:DisplayObject = getItemAt(pagesize*(curPage-1));
					TweenLite.to(container,1,{x:-obj.x + theMask.x ,y:-obj.y+theMask.y});
				}
				return;
			}
			if(isVRoll){
				if(container.height> theMask.height){
					if(container.y + container.height- theMask.height> theMask.y )
						container.y -= theMask.height;
				}
			}else{
				if(container.width> theMask.width){
					if(container.x + container.width - theMask.width > theMask.x )
						container.x -= theMask.width;
				}
			}
			backtoShow();
		}


		private var mouY:int;
		private var mouX:int;
		public var container:Sprite;
		private function clicked(e:Event):void
		{
			var target:Sprite = e.currentTarget as Sprite;
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					mouY = container.y;
					mouX = container.x;
					break;
				case MouseEvent.MOUSE_UP:
					if(Math.abs(mouY -container.y)+ Math.abs(mouX - container.x)> 10)return;
					ClickObject = target;
					container.addChild(target);
					dispatchEvent(new Event(Event.SELECT));
					break;
			}

		}

		public function removes():void
		{
			ViewSet.removes(container);
		}
		public var ClickObject:Sprite;


		public function addItem(item:DisplayObject):DisplayObject
		{
			container.addChild(item);
			/*item.mouseChildren = false;*/
			/*item.buttonMode= true;*/
			item.addEventListener(MouseEvent.MOUSE_DOWN,clicked);
			item.addEventListener(MouseEvent.MOUSE_UP,clicked);

			backtoShow();
			initBg();
			return item;
		}

		public function removeItem(item:DisplayObject):DisplayObject
		{
			if(container.contains(item)){
				container.removeChild(item);
				return item;
			}
			return null;
		}

		public function getItemAt(i:int):DisplayObject
		{
			if(container.numChildren>i){
				if(container.contains(bg)){
					if(container.numChildren>i+1)
						return container.getChildAt(i+1);
				}else
					return container.getChildAt(i);
			}
			return null;
		}

		public function getItemByName(_name:String):DisplayObject
		{
			var i:int = numItems;
			while(i>0)
			{
				--i;
				var obj:DisplayObject = getItemAt(i) as DisplayObject;
				if(obj && obj["name"]==_name)return obj;
			}
			return null;
		}

		public function get numItems():int
		{
			if(container.contains(bg))return container.numChildren -1;
			return container.numChildren;
		}

		private function initBg():void
		{
			if(container.contains(bg))container.removeChild(bg);
			/*bg.x = container.x;*/
			/*bg.y = container.y;*/
			bg.width = container.width;
			bg.height= container.height;
			container.addChildAt(bg,0).alpha=0;
		}
	}
}

