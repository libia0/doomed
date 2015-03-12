package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 图标列表
	 * ...
	 * @author db0@qq.com
	 */
	[SWF(width=1024,height=680)]
	
	public class IconList extends Sprite
	{
		private var iconW:int;
		private var iconH:int;
		private var numCol:int = 1;
		private var numRow:int = 1;
		private var maskBmp:Bitmap;
		private var iconContainer:Sprite = new Sprite();
		/**
		 * 
		 * @param	iconW 图标的之间的宽距
		 * @param	iconH 图标的之间的高距
		 * @param	_maskBmp 所有的图标遮罩，确定显示图标集的区域大小（位置不能确定）
		 * @param	willdrag 能否水平拖动
		 */
		public function IconList(iconW:int , iconH:int , _maskBmp:Bitmap , willdrag:Boolean )
		{
			//trace(int(7/2),int(7/3),int(7/4),int(7/5));
			this.iconW = iconW;
			this.iconH = iconH;
			this.maskBmp = _maskBmp;
			//addEventListener(Event.ADDED_TO_STAGE, init);
			init(null);
			if (willdrag)
			{
				addEventListener(MouseEvent.MOUSE_UP, drags);
				addEventListener(MouseEvent.MOUSE_DOWN, drags);
			}
		}
		
		private function init(e:Event):void
		{
			//removeEventListener(Event.ADDED_TO_STAGE, init);
			if (maskBmp == null)
			{
				if (stage) {
					maskBmp = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, false, 0));
				}else {
					maskBmp = new Bitmap(new BitmapData(iconW*numCol, iconH*numRow, false, 0));
				}
			}
			numCol = int(maskBmp.width / iconW);
			if (numCol < 1)
				numCol = 1;
			numRow = int(maskBmp.height / iconH);
			if (numRow < 1)
				numRow = 1;
			
			var ww:int = numCol * iconW;
			var hh:int = numRow * iconH;
			maskBmp.x = maskBmp.width / 2 - ww / 2; 
			maskBmp.y = maskBmp.height / 2 - hh / 2;
			maskBmp.width = ww;
			maskBmp.height = hh;
			addChild(maskBmp);
			
			addChild(iconContainer);
			iconContainer.x = maskBmp.x;
			iconContainer.y = maskBmp.y;
			iconContainer.mask = maskBmp;
			
			var bmp:Bitmap = addChildAt(new Bitmap(maskBmp.bitmapData), 0) as Bitmap;
			bmp.x = maskBmp.x;
			bmp.y = maskBmp.y;
			bmp.alpha = 0;
		}
		
		private var mouX:Number = -100000;
		private var mouY:Number = -100000;
		
		private function drags(e:MouseEvent):void
		{
			if(totalPage > 0)
			switch (e.type)
			{
				case MouseEvent.MOUSE_UP: 
					iconContainer.stopDrag();
					if (stage.mouseX - mouX > maskBmp.width / 2) {
						curPage = curPage - 1;
					}else if (mouX - stage.mouseX > maskBmp.width / 2){
						curPage = curPage +1;
					}else {
						curPage = curPage;
					}
					break;
				case MouseEvent.MOUSE_DOWN: 
					mouX = stage.mouseX;
					mouY = stage.mouseY;
					var rect:Rectangle = new Rectangle(maskBmp.x - iconContainer.width, iconContainer.y, maskBmp.width + iconContainer.width * 2, 0);
					iconContainer.startDrag(false, rect);
					break;
				default: 
			}
		}
		
		public function addIcon(sprite:Sprite):Icon
		{
			var icon:Icon = new Icon(iconW, iconH);
			iconContainer.addChild(icon);
			icon.addChild(sprite);
			//ViewSet.fullCenter(sprite, iconW * .05, iconH * .05, iconW * .9, iconH * .9);//如果是实时加入的图片，可以使用此行，将图片居中。
			//trace(iconW * .05, iconH * .05, iconW * .9, iconH * .9);
			//trace(sprite.width,sprite.height);
			refresh();
			return icon;
		}
		
		public function refresh():void
		{
			//trace(iconW, iconH);
			var index:int = 0;
			while (index < iconContainer.numChildren)
			{
				var icon:Icon = iconContainer.getChildAt(index) as Icon;
				var pageIndex:int = int(index / (numCol * numRow));
				var indexInPage:int = int(index % (numCol * numRow));
				//trace(pageIndex,indexInPage);
				//trace(numRow,numRow);
				icon.x = pageIndex * maskBmp.width + (indexInPage % numCol) * iconW;
				icon.y = int(indexInPage / numCol) * iconH;
				//trace(icon.x,icon.y);
				//trace(iconW, iconH);
				++index;
			}
		}
		
		public function removeList():void
		{
			var index:int = iconContainer.numChildren;
			while (index > 0)
			{
				--index;
				var icon:Icon = iconContainer.getChildAt(index) as Icon;
				iconContainer.removeChild(icon);
				icon = null;
			}
			curPage = 0;
		}
		
		public function set curPage(i:int):void
		{
			if (i < 0) i = 0;
			if (i >= totalPage) i = totalPage;
			
			iconContainer.x = maskBmp.x - (iconW * numCol) * i;
			//trace(iconContainer.x);
		}
		
		public function get curPage():int
		{
			return (maskBmp.x - iconContainer.x) / (iconW * numCol);
		}
		
		public function get totalPage():int
		{
			return int((iconContainer.numChildren - 1) / (numCol * numRow));
		}
	}

}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

class Icon extends Sprite
{
	public function Icon(w:int, h:int)
	{
		addChildAt(new Bitmap(new BitmapData(w, h, true, 0)), 0);
	}
}
