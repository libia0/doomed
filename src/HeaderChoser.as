package
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 仿微软的头部菜单,
	 * ...
	 * @author db0@qq.com
	 */
	public class HeaderChoser extends Sprite
	{
		public var curItem:HeaderChoserItem;
		public static const SELECTED:String = "_SELECTED";
		private var list:Vector.<HeaderChoserItem>;
		public var container:Sprite = new Sprite();
		private var containerMask:Bitmap = new Bitmap(new BitmapData(2, 2));
		private var curIndex:uint = 0;
		private var itemBg:Bitmap;
		private var mouseOver:Bitmap;

		/**
		 * 最大显示的数量
		 */
		private var maxNumShow:uint = 3;
		/**
		 * 
		 * @param	itembg 单个元素背景
		 * @param	mouseOver 鼠标经过时的背景
		 */
		public function HeaderChoser(itembg:Bitmap, mouseOver:Bitmap)
		{
			this.itemBg = itembg;
			this.mouseOver = mouseOver;
			addChild(containerMask);
			addChild(container);
			container.mask = containerMask;
			if (stage)
			{
				var arr:Array = new Array();
				var i:int = 0;
				while (i < 4)
				{
					arr.push("i" + i);
					++i;
				}
				initArr(arr);
			}

		}
		/**
		 * 清空列表
		 */
		public function clears():void
		{
			list = null;
			var i:int = container.numChildren;
			while (i > 0)
			{
				--i;
				var item:HeaderChoserItem = container.getChildAt(i) as HeaderChoserItem;
				container.removeChild(item);
				item = null;
			}
		}

		private function init():void
		{
			if (list.length < 1)
				return;
			var i:int = 0;
			while (i < list.length)
			{
				var item:HeaderChoserItem = list[i];
				if (i == 0)
					curItem = item;
				item.addEventListener(MouseEvent.CLICK, clicked);
				container.addChild(item);
				++i;
			}
			refresh();
		}

		private function clicked(e:MouseEvent):void
		{
			var target:HeaderChoserItem = e.target as HeaderChoserItem;
			if (target.canClick)
			{
				curIndex = int(String(target.name).substr(1));
				trace(curIndex);
				curItem = target;
				show(curIndex);
				dispatchEvent(new Event(SELECTED));
			}

		}

		/**
		 * 更新列表
		 */
		public function refresh():void
		{
			var i:int = 1;
			while (i < container.numChildren)
			{
				var item0:HeaderChoserItem = container.getChildAt(i - 1) as HeaderChoserItem;
				var item:HeaderChoserItem = container.getChildAt(i) as HeaderChoserItem;
				item.name = "i" + i;
				item.chosen(false);
				item.x = item0.x + item0.width;
				++i;
			}
			HeaderChoserItem(container.getChildAt(0)).chosen(false);
			HeaderChoserItem(container.getChildAt(curIndex)).chosen(true);

			containerMask.height = container.height;

			var lastItem:HeaderChoserItem;
			if (curIndex == 0)
			{
				lastItem = container.getChildAt(Math.min(curIndex + 2, container.numChildren - 1)) as HeaderChoserItem;
			}
			else if (curIndex <= container.numChildren - 2)
			{
				lastItem = container.getChildAt(curIndex + 1) as HeaderChoserItem;
			}
			else
			{
				lastItem = container.getChildAt(curIndex) as HeaderChoserItem;
			}
			containerMask.width = lastItem.x + lastItem.width + container.x;
		}

		/**
		 * 选中第i项;
		 * @param	i
		 */
		public function show(i:uint):void
		{
			if (i <= 0)
			{ //no. 1
				i = 0;
				container.x = 0;
			}
			else if (i >= container.numChildren - 1)
			{ //no. last
				i >= container.numChildren - 1;
				if (maxNumShow <= container.numChildren)
				{
					container.x = -container.getChildAt(container.numChildren - maxNumShow).x;
				}
			}
			else
			{
				if (maxNumShow <= container.numChildren)
				{
					container.x = -container.getChildAt(i - 1).x;
				}
			}
			curIndex = i;
			refresh();
		}

		private var numOfPage:int = 3;//一页翻numOfPage个
		public function prevPage():void
		{
			logs.adds(curFirstIndex);
			if(curFirstIndex - numOfPage >=0)
			{
				curFirstIndex = curFirstIndex - numOfPage;
			}else{
				curFirstIndex = 0;
			}
			logs.adds(curFirstIndex);
		}

		public function nextPage():void
		{
			if(curFirstIndex + numOfPage < container.numChildren)
				curFirstIndex = curFirstIndex + numOfPage;
		}

		/**
		  当前的显示在第一个序号
		 */
		public function get curFirstIndex():int
		{
			var i:int = container.numChildren;
			while(i>0){
				--i;
				var obj:DisplayObject = container.getChildAt(i);
				logs.adds(obj.x,container.x);
				if(Math.abs(container.x + obj.x) < 2)
					return i;
			}
			return -1;
		}

		public function set curFirstIndex(i:int):void
		{
			if(i>= 0 && i < container.numChildren)
			{
				var obj:DisplayObject = container.getChildAt(i);
				container.x = -obj.x;
			}else if(i<0){
				obj = container.getChildAt(0);
				container.x = -obj.x;
			}
		}

		/**
		 *
		 * @param	headerList 字符串数组
		 */
		public function initArr(headerList:Array):void
		{
			var i:int = 0;
			clears();
			list = new Vector.<HeaderChoserItem>;
			while (i < headerList.length)
			{
				var item:HeaderChoserItem = new HeaderChoserItem(headerList[i], itemBg, mouseOver);
				if (i == 0)
					curItem = item;
				list.push(item);
				++i;
			}
			init();
		}
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

class HeaderChoserItem extends Sprite
{
	/**
	 * 显示的文字
	 */
	public var text:String;
	/**
	 * 背景
	 */
	public var bg:Bitmap;
	/**
	 * 鼠标经过显示
	 */
	public var mouseOver:Bitmap;
	public var canClick:Boolean = true;
	private var txt:TextField = new TextField();

	public function HeaderChoserItem(text:String, bg:Bitmap, mouseOver:Bitmap)
	{
		this.text = text;
		mouseChildren = false;
		addEventListener(MouseEvent.MOUSE_OVER, showGray);
		addEventListener(MouseEvent.MOUSE_OUT, showGray);
		this.bg = addChild(new Bitmap(bg.bitmapData)) as Bitmap;
		this.mouseOver = addChild(new Bitmap(mouseOver.bitmapData)) as Bitmap;
		txt.width = bg.width;
		txt.height = bg.height;
		txt.autoSize = "center";
		txt.text = String(text);
		addChild(txt);

		this.bg.visible = true;
		this.mouseOver.visible = false;
		this.mouseOver.alpha = .5;
		chosen();
	}

	private function showGray(e:MouseEvent):void
	{
		switch (e.type)
		{
			case MouseEvent.MOUSE_OVER: 
				//mouseOver.visible = true;
				break;
			default: 
				//mouseOver.visible = false;
		}
	}

	public function chosen(bool:Boolean = false):void
	{
		buttonMode = !bool;
		canClick = !bool;
		bg.visible = false;
		mouseOver.visible = bg.visible = !bool;
		if(bool){
			txt.textColor = 0x442211;
		}else{
			txt.textColor = 0xeeee22;
		}
	}
}

