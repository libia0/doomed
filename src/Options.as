package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author db0@qq.com
	 */
	public class Options extends Sprite 
	{
		public static const SELECTED:String = "_SELECTED";
		public var curItem:OptionItem;
		private var valueArr:Array = new Array();
		private var itemContainer:Sprite = new Sprite();
		private var selectedItem:Sprite = new Sprite();
		
		
		public function Options(valueArr:Array=null) 
		{
			addChild(selectedItem);
			this.valueArr = valueArr;
			addChild(itemContainer);
			itemContainer.visible = false;
			
			if (stage) {
				//this.valueArr = ["爷爷", "奶奶", "父亲", "母亲"];
				//[Embed(source = "../jibai_asset/leavemsg/fanli/item_bg.jpg")]
				//var ITEM_BG:Class;
				//[Embed(source = "../jibai_asset/leavemsg/fanli/item_mouse_over.jpg")]
				//var ITEM_MOUSE_OVER:Class;
				//[Embed(source = "../jibai_asset/leavemsg/fanli/item_selected.png")]
				//var ITEM_SELECTED:Class;
				//
				//initSelect(new ITEM_SELECTED);
				//initList(new ITEM_BG,new ITEM_MOUSE_OVER);
			}
		}
		
		public function initSelect(bg:Bitmap):void
		{
			selectedItem.mouseChildren = false;
			selectedItem.addEventListener(MouseEvent.CLICK, showList);
			selectedItem.addChild(new OptionItem(valueArr[0],bg)).name = "cur";
		}
		
		private function showList(e:MouseEvent):void 
		{
			itemContainer.y = selectedItem.y + selectedItem.height;
			itemContainer.visible = !itemContainer.visible;
		}
		
		public function initList(bg:Bitmap,mouseOverBg:Bitmap):void 
		{
			var i:int = 0;
			while (i< valueArr.length) 
			{
				addItem(new OptionItem(valueArr[i],bg,mouseOverBg)).addEventListener(MouseEvent.CLICK,selected);
				++i;
			}
			curItem = itemContainer.getChildAt(0) as OptionItem;
		}
		
		private function selected(e:MouseEvent):void 
		{
			curItem = OptionItem(e.target);
			itemContainer.visible = false;
			OptionItem(selectedItem.getChildByName("cur")).setValue(curItem.value);
			//trace(curItem.value);
			dispatchEvent(new Event(SELECTED));
		}
		
		private function addItem(msgItem:OptionItem):OptionItem
		{
			itemContainer.addChild(msgItem);
			refresh();
			return msgItem;
		}
		
		private function refresh():void
		{
			var i:int = 0;
			while (i < itemContainer.numChildren-1) 
			{
				++i;
				var item:OptionItem = itemContainer.getChildAt(i) as OptionItem;
				var _item:OptionItem = itemContainer.getChildAt(i-1) as OptionItem;
				item.y = _item.y + _item.height;
			}
		}
		
		public function clearList():void
		{
			var i:int = itemContainer.numChildren;
			while (i >0) 
			{
				--i;
				var item:OptionItem = itemContainer.getChildAt(i) as OptionItem;
				itemContainer.removeChild(item);
				item = null;
			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
class OptionItem extends Sprite
{
	public var value:String;
	private var txt:TextField = new TextField();
	private var mouseOver:Bitmap;
	public function OptionItem(value:String, bg:Bitmap, mouseOverBg:Bitmap = null, selectedBg:Bitmap = null) {
		mouseChildren = false;
		addChild(new Bitmap(bg.bitmapData));
		this.value = value;
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.width = bg.width;
		if(value)txt.text = value;
		addChild(txt);
		getChildAt(0).height = txt.height;
		if (mouseOverBg) {
			//txt.width = bg.width;
			//txt.autoSize = TextFieldAutoSize.CENTER;
			//txt.text = value;
			mouseOver = new Bitmap(mouseOverBg.bitmapData);
			addChildAt(mouseOver,1);
			mouseOver.visible = false;
			mouseOver.height = txt.height;
		}
		if (selectedBg) {
			var selected:Bitmap = new Bitmap(selectedBg.bitmapData);
			addChild(selected);
			selected.visible = false;
		}
		addEventListener(MouseEvent.MOUSE_OVER, MouseEvents);
		addEventListener(MouseEvent.MOUSE_OUT, MouseEvents);
	}
	
	private function MouseEvents(e:MouseEvent):void 
	{
		switch (e.type) 
		{
			case MouseEvent.MOUSE_OVER:
				if(mouseOver)mouseOver.visible = true;
			break;
			default:
				if(mouseOver)mouseOver.visible = false;
		}
	}
	public function init():void {
		
	}
	
	public function setValue(value:String):void 
	{
		this.value = value;
		txt.text = value;
	}
}
