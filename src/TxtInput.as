/**
 * @file TxtInput.as
 *  

 var txtinput:TxtInput = new TxtInput(20,100,"选择:");
 addChild(txtinput);
 txtinput.show_selectlist(["1","2"],true,true);
 txtinput.addEventListener(Event.CHANGE,gettxtvalue);
 private function gettxtvalue(e:Event):void
 {
 trace(txtinput.value);
 }

 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-07-02
 */
package {
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;
	public class TxtInput extends Sprite
	{
		private var inputTxt:TextField = new TextField();
		private var leftTxt:TextField;
		private var rightTxt:TextField;
		private var upTxt:TextField;
		private var downTxt:TextField;
		/**
		 * @file TxtInput.as
		 *  
txtSize:文本字体大小
_w:文本框的宽度
_leftTxt:文本框左边的文本
_rightTxt:文本框右边的文本
_upTxt:文本框上面的文本
		 * @author db0@qq.com
		 * @version 1.0.1
		 * @date 2014-04-11
		 */
		public function TxtInput(txtSize:int,_w:int,_leftTxt:String=null,_rightTxt:String=null,_upTxt:String=null,_downTxt:String=null,isvert:Boolean = false,fontColor:uint=0x0)
		{
			/*mouseChildren = false;*/
			inputTxt.type = "input";
			inputTxt.border = true;
			inputTxt.textColor= fontColor;
			inputTxt.borderColor= fontColor;
			if(isvert){
				inputTxt.width = txtSize;
				inputTxt.height= _w;
				inputTxt.wordWrap = true;
			}else{
				inputTxt.width = _w;
				inputTxt.height = txtSize*1.3;
				inputTxt.background = true;
			}
			inputTxt.defaultTextFormat = new TextFormat("",txtSize);
			addChild(inputTxt);
			if(_leftTxt){
				leftTxt = make_txt(_leftTxt,txtSize);
				leftTxt.textColor= fontColor;
				inputTxt.x = leftTxt.width;
				addChild(leftTxt);
			}
			if(_rightTxt)
			{
				rightTxt = make_txt(_rightTxt,txtSize);
				rightTxt.textColor= fontColor;
				rightTxt.x = inputTxt.x+inputTxt.width;
				addChild(rightTxt);
			}
			if(_upTxt)
			{
				upTxt= make_txt(_upTxt,txtSize);
				upTxt.textColor= fontColor;
				if(isvert){
					upTxt.width = txtSize;
					upTxt.wordWrap= true;
				}
				inputTxt.y = upTxt.height;
				if(rightTxt)rightTxt.y = inputTxt.y;
				if(leftTxt)leftTxt.y = inputTxt.y;
				addChild(upTxt);
			}
			if(_downTxt)
			{
				downTxt= make_txt(_downTxt,txtSize);
				downTxt.textColor= fontColor;

				if(isvert){
					downTxt.width = txtSize;
					downTxt.wordWrap= true;
				}
				downTxt.y = inputTxt.y +inputTxt.height;
				if(rightTxt)rightTxt.y = inputTxt.y;
				if(leftTxt)leftTxt.y = inputTxt.y;
				addChild(downTxt);
			}
			inputTxt.addEventListener(FocusEvent.FOCUS_IN,show_selectlists);
			inputTxt.addEventListener(Event.CHANGE,show_selectlists);
			inputTxt.addEventListener(FocusEvent.FOCUS_OUT,hide_selectlists);
		}
		private function hide_selectlists(e:Event):void
		{
			if(SeletList.mains && !SeletList.mains.hitTestPoint(stage.mouseX,stage.mouseY))
			{
				if(SeletList.mains)SeletList.mains.hide();
			}else{
				/*stage.focus = e.currentTarget as TextField;*/
			}
		}
		private function show_selectlists(e:Event):void
		{
			dispatchEvent(new Event(Event.SELECT));
			show_selectlist();
		}
		private var select_list:Array;
		private var list_all:Boolean=false;//列表显示区域
		private var show_all:Boolean=false;//是否显示整个列表
		/**
show_all:在区域中,显示整个筛选出的列表,true可出区域,false只显示遮罩部分
list_all:显示整个表,不筛选
		 */
		public function show_selectlist(_select_list:Array=null,_show_all:Boolean=false,_list_all:Boolean=false):void
		{
			/*inputTxt.multiline = false;*/
			var showarr:Array;
			if(_select_list){
				list_all = _list_all;
				show_all = _show_all;
				if(select_list){
					select_list.splice(0,select_list.length);
					select_list = null;
				}
				for each (var item:String in _select_list)
				{
					if(select_list == null)select_list = new Array();
					select_list.push({str:item,fun:set_input});
				}
			}else{
				for each (var obj:Object in select_list)
				{
					if(list_all){
						if(showarr == null)showarr= new Array();
						showarr.push({str:obj.str,fun:set_input});
					}else if(show_all){
						if(showarr == null)showarr= new Array();
						if(obj && obj.str.indexOf(value)>=0){
							showarr.unshift({str:obj.str,fun:set_input});
						}else{
							showarr.push({str:obj.str,fun:set_input});
						}
					}else if(obj && obj.str.indexOf(value)>=0){
						if(showarr == null)showarr= new Array();
						showarr.push({str:obj.str,fun:set_input});
					}
				}
			}
			parent.addChild(this);
			if(SeletList.mains==null)new SeletList();
			addChild(SeletList.mains);
			if(showarr && showarr.length>0)SeletList.mains.show(showarr,
					inputTxt.x,
					inputTxt.y+inputTxt.height,
					inputTxt.width,
					inputTxt.height*1.2,
					18
					);
			else SeletList.mains.hide();
		}
		private function set_input(e:Object=null):void
		{
			if(e){
				value = String(e);
			}
			SeletList.mains.hide();
		}

		private function make_txt(s:String,size:int,leading:int=-5):TextField
		{
			if(s==null)return null;
			var txt:TextField = new TextField();
			var txtformat:TextFormat = new TextFormat("",size);
			txtformat.leading = leading;
			txt.defaultTextFormat = txtformat;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			txt.text = Fanti.jian2fan(s);
			txt.selectable = false;

			return txt;
		}
		/**
		  获取输入文本值
		 */
		public function get value():String
		{
			return inputTxt.text;
		}
		/**
		  设置输入文本值
		 */
		public function set value(s:String):void
		{
			var changed:Boolean= (value!=String(s));
			inputTxt.text= Fanti.jian2fan(s);
			if(changed)dispatchEvent(new Event(Event.CHANGE));
		}
	}
}

