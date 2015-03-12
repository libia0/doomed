package
{
	import com.riaidea.text.plugins.ShortcutPlugin;
	import com.riaidea.text.RichTextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextFieldType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * 带滚动列表的容器控件，构造函数是test例子
	 * @author db0@qq.com
	 */
	[SWF(width=1024,height=680)]
	
	public class RollBoard extends Sprite
	{
		/**
		 * 试图加载更多项目
		 */
		public static const SHOWMORE:String = "SHOW_MORE";
		public var msgContainer:Sprite = new Sprite();
		private const msgOrigY:int = 30;
		private var curMsgIndex:int = 0;
		
		private var msgBoard:Sprite = new Sprite();
		private var msgMask:Bitmap = new Bitmap(new BitmapData(190, 270));
		
		private var rollBar:RollBar = new RollBar();
		
		private var mouseOver:Bitmap;
		private var hrLine:Bitmap;
		
		public function RollBoard()
		{
			if (stage)
			{
				//[Embed(source="../jibai_asset/leavemsg/record_list/Bg.png")]
				//var BG:Class;
				//var bgBmp:Bitmap = new BG();
				//[Embed(source="../jibai_asset/leavemsg/record_list/close.png")]
				//var CLOSE:Class;
				//[Embed(source="../jibai_asset/leavemsg/record_list/close_mouse.png")]
				//var CLOSE_MOUSE:Class;
				//var closeBtn:Sprite = new Sprite();
				//closeBtn.addChild(new CLOSE());
				//closeBtn.addChild(new CLOSE_MOUSE());
				//
				//[Embed(source="../jibai_asset/leavemsg/record_list/barline.png")]
				//var BAR:Class;
				//[Embed(source="../jibai_asset/leavemsg/record_list/rolls.png")]
				//var ROLLS:Class;
				//var bar:Sprite = new Sprite();
				//bar.addChild(new ROLLS());
				//var barLine:Bitmap = new BAR();
				//
				//[Embed(source="../jibai_asset/today_record/up_mouse.png")]
				//var UpbtnMouse:Class;
				//var upBtn:Sprite = new Sprite();
				//[Embed(source="../jibai_asset/today_record/down_mouse.png")]
				//var DownbtnMouse:Class;
				//var downBtn:Sprite = new Sprite();
				//upBtn.addChild(new UpbtnMouse);
				//downBtn.addChild(new DownbtnMouse);
				//
				//[Embed(source="../jibai_asset/leavemsg/record_list/mouse.png")]
				//var MouseOver:Class;
				//[Embed(source="../jibai_asset/leavemsg/record_list/hr.jpg")]
				//var HR:Class;
				//mouseOver = new MouseOver();
				//hrLine = new HR();
				//
				//init(bgBmp, closeBtn);
				//initRollBar(bar, barLine, upBtn, downBtn);
				//var i:int = 10;
				//while (i > 0)
				//{
				//--i;
				//addItem(new Sprite());
				//}
			}
		}
		
		public function initRollBar(bar:Sprite, barLine:Bitmap, upBtn:Sprite, downBtn:Sprite):void
		{
			rollBar.initUI(bar, barLine, upBtn, downBtn);
		}
		
		public function init(bgBmp:Bitmap, closeBtn:Sprite):void
		{
			msgBoard.addChild(bgBmp);
			msgBoard.addChild(msgMask);
			msgBoard.addChild(msgContainer);
			msgBoard.addChild(rollBar);
			msgBoard.addChild(closeBtn);
			addChild(msgBoard);
			
			rollBar.visible = false;
			msgContainer.mask = msgMask;
			msgMask.height = bgBmp.height * .9;
			msgMask.y = msgContainer.y = msgOrigY;
			msgMask.x = msgContainer.x = bgBmp.width*.05;
			//trace(msgMask.height);
			rollBar.y = msgMask.y;
			rollBar.x = bgBmp.width * .9;
			closeBtn.x = bgBmp.width - closeBtn.width;
			closeBtn.addEventListener(MouseEvent.CLICK, hide);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removes);
			msgBoard.addEventListener(MouseEvent.MOUSE_WHEEL, rolls);
			msgContainer.addEventListener(MouseEvent.MOUSE_DOWN, drags);
		}
		
		private function drags(e:MouseEvent):void
		{
			if(msgContainer.height < msgMask.height)return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					msgContainer.startDrag(false, new Rectangle(msgMask.x, msgMask.y, 0, msgMask.height / 3 - msgContainer.height));
					msgContainer.addEventListener(MouseEvent.MOUSE_UP, drags);
					msgContainer.addEventListener(MouseEvent.MOUSE_OUT, drags);
					break;
				case MouseEvent.MOUSE_UP: 
					msgContainer.stopDrag();
					msgContainer.removeEventListener(MouseEvent.MOUSE_UP, drags);
					msgContainer.removeEventListener(MouseEvent.MOUSE_OUT, drags);
					//toIndex(getCurMsgIndex());
					break;
				default: 
			}
			setRollbar();
		}
		
		private function rolls(e:MouseEvent):void
		{
			if(msgContainer.height < msgMask.height)return;
			if (e.delta > 0)
			{
				toIndex(getCurMsgIndex() - 1);
			}
			else if (e.delta < 0)
			{
				toIndex(getCurMsgIndex() + 1);
			}
		}
		
		private function setRollbar():void
		{
			if(msgContainer.height < msgMask.height)return;
			if (msgContainer.numChildren > 2)
			{
				var total:Number = msgContainer.height  - msgMask.height;
				var cur:Number = -msgContainer.y + msgOrigY;
				var n:Number = cur / total;
				if (n >= 1) {
					n = 1;
					dispatchEvent(new Event(SHOWMORE));
				}else if (n < 0){
					n = 0;
				}
				//trace("rate:",n);
				//trace(total);
				rollBar.change(n);
			}
			rollBar.height = msgMask.height;
			rollBar.visible = true;
		}
		
		/**
		 *
		 * @return
		 */
		private function getCurMsgIndex():uint
		{
			var i:int = msgContainer.numChildren;
			while (i > 0)
			{
				--i;
				var obj:DisplayObject = msgContainer.getChildAt(i);
				//trace("?",msgOrigY -obj.y - msgContainer.y);
				//if (Math.abs(msgOrigY - msgContainer.y - obj.y) < obj.height)
				//{
				//break;
				//}
				//else 
				if (msgOrigY - obj.y - msgContainer.y >= 0)
				{
					break;
				}
			}
			curMsgIndex = i;
			return curMsgIndex;
		}
		
		private function toIndex(i:int):void
		{
			if (msgContainer.numChildren > 0)
			{
				curMsgIndex = i;
				if (i < 0)
					curMsgIndex = 0;
				if (i >= msgContainer.numChildren)
					curMsgIndex = msgContainer.numChildren - 1;
				msgContainer.y = msgOrigY - msgContainer.getChildAt(curMsgIndex).y;
				setRollbar();
			}
		
		}
		
		private function removes(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removes);
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}
		
		private function hide(e:MouseEvent):void
		{
			//if (parent)
			//parent.removeChild(this);
			//parent.
			//visible = false;
			dispatchEvent(new Event("hide"));
		}
		
		public function addItem(sprite:Sprite):MsgItem
		{
			var msgItem:MsgItem;
			if (mouseOver && hrLine)
			{
				msgItem = new MsgItem(mouseOver, hrLine);
				msgItem.addChild(sprite);
				msgContainer.addChild(msgItem);
				msgItem.setSize();
				refresh();
			}
			
			return msgItem;
		}
		
		private function refresh():void
		{
			var i:int = 0;
			while (i < msgContainer.numChildren - 1)
			{
				++i;
				var item:MsgItem = msgContainer.getChildAt(i) as MsgItem;
				var _item:MsgItem = msgContainer.getChildAt(i - 1) as MsgItem;
				item.y = _item.y + _item.height;
			}
			if (msgContainer.height > msgMask.height) {
				rollBar.visible = true;
				setRollbar();
			}else {
				rollBar.visible = false;
			}
		}
		
		public function clearList():void
		{
			var i:int = msgContainer.numChildren;
			
			if(i>0)toIndex(0);
			while (i > 0)
			{
				--i;
				var item:MsgItem = msgContainer.getChildAt(i) as MsgItem;
				msgContainer.removeChild(item);
				item = null;
			}
		}
		
		public function initMsgItem(mouseOver:Bitmap, hrLine:Bitmap):void
		{
			this.mouseOver = mouseOver;
			this.hrLine = hrLine;
		}
	
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;

class MsgItem extends Sprite
{
	/**
	 *
	 * @param	mouseOver 鼠标经过显示
	 * @param	line 分割线
	 * @param	photo 照片地址
	 * @param	time
	 * @param	_name
	 * @param	msg
	 */
	public function MsgItem(mouseOver:Bitmap, line:Bitmap)
	{
		//mouseChildren = false;
		addChild(new Bitmap(mouseOver.bitmapData)).height = 2;
		getChildAt(0).alpha = 0;
		//getChildAt(0).height = height;
		
		addEventListener(MouseEvent.MOUSE_OVER, showGray);
		addEventListener(MouseEvent.MOUSE_OUT, showGray);
		
		addChild(new Bitmap(line.bitmapData)).y = height - 2;
	}
	
	public function setSize():void
	{
		getChildAt(0).height = height;
		getChildAt(1).y = height - 2;
	}
	
	private function showGray(e:MouseEvent):void
	{
		switch (e.type)
		{
			case MouseEvent.MOUSE_OVER: 
				getChildAt(0).alpha = 1;
				break;
			default: 
				getChildAt(0).alpha = 0;
		}
	}
}

class RollBar extends Sprite
{
	private var bar:Sprite;
	private var barLine:Bitmap;
	
	public function RollBar()
	{
	}
	
	public function initUI(bar:Sprite, barLine:Bitmap, upBtn:Sprite, downBtn:Sprite):void
	{
		this.bar = bar;
		this.barLine = barLine;
		addChild(barLine);
		addChild(bar);
		downBtn.x = upBtn.x =  width / 2 - bar.width / 2.;
		bar.x = 2;
		//bar.y = bar.height;
		
		addChild(upBtn);
		addChild(downBtn);
		//bar.x;
		//downBtn.y = height - downBtn.height;
		downBtn.mouseChildren = upBtn.mouseChildren = false;
		downBtn.buttonMode = upBtn.buttonMode = true;
	}
	
	public function change(n:Number):void
	{
		bar.y = n * (barLine.height - bar.height * 3.5) + bar.height * 1.2;
	}
}
