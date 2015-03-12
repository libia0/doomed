/**
  var seletlist:SeletList = new SeletList();
  addChild(seletlist);
  var select_list:Array = null;
  for each (var item:String in str_arr)
  {
  if(item && item.indexOf(nameInput.text)>=0){
  if(select_list == null)select_list = new Array();
  select_list.push({str:item,fun:set_input_name});
  }
  }
  if(select_list)seletlist.show(select_list,obj.x,obj.y+obj.height,obj.width,obj.height);
  else seletlist.hide();

 * @file SeletList.as
 *  下拉列表
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-03-10
 */
package 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	public class SeletList extends DragPage
	{
		public static var stageW:int = 480;
		public static var stageH:int = 800;
		private var alpha_bg:Shape;
		public static var mains:SeletList;
		private var btn_container:MyList= new MyList();
		public function SeletList()
		{
			mains = this;
			visible = false;

			if(alpha_bg == null){
				alpha_bg= new Shape();
				alpha_bg.graphics.beginFill(0x999999);
				alpha_bg.graphics.drawRect(0,0, stageW, stageH);
				alpha_bg.graphics.endFill();
				alpha_bg.alpha = .5;
			}
			/*addChild(alpha_bg);*/
		}

		private var xx:int =0;
		private var yy:int =0;
		private var ww:int =480;
		private var hh:int =800;
		public function show(content:Array=null,_xx:int=0,_yy:int=0,_ww:int=80,_hh:int=20,font_size:int=18):void
		{
			if(content == null){
				CONFIG::debugging {
					/*content = [{str:"none"}];*/
				}
			}
			/*logs.adds(content);*/
			var cur_height:int = 0;
			if(content  && content.length >0 ){
				xx = _xx;
				yy = _yy;
				ww = _ww;
				hh = _hh;
				cur_height = make_vert_btns(content,font_size);
				btn_container.MaskRect = new Rectangle(0,0,ww,hh*10);
				btn_container.x = xx;
				btn_container.y = yy;
				btn_container.page = 0;
				/*btn_container.y = stageH - cur_height;*/
				/*btn_container.y = yy;*/
			}else{
				return;
			}
			visible = true;
			/*logs.adds("show_selectlist");*/
			/*TweenLite.from(btn_container,1,{y:stageH});*/
			addEventListener(MouseEvent.ROLL_OUT,no_selectlist);
		}

		private function no_selectlist(e:Event):void
		{
			if(stage.focus != mains)
				show(null);
		}

		private function make_vert_btns(content_arr:Array,font_size:int=18):int
		{
			/*ViewSet.removes(btn_container);*/
			btn_container.removes();
			/*var startx:int = xx;*/
			/*var starty:int = yy;*/
			var startx:int = 0;
			var starty:int = 0;
			var btnw:int = ww;
			var btnh:int = hh;
			var btn_gap:int = 1;
			for each(var o:Object in content_arr)
			{
				var okBtn:TxtBtn;
				okBtn = new TxtBtn(o.str,o.fun,startx,starty,o.str,font_size);
				okBtn.setformat(btnw-1,
						btnh,
						TextFieldAutoSize.LEFT,
						0xffdddddd,0xffffffff,
						0xff222222,0xff000000,
						0xff000000);
				/*btn_container.addChild(okBtn);*/
				btn_container.addItem(okBtn);
				starty += btn_gap+btnh;
			}
			addChild(btn_container);
			return starty;
		}

		public function hide(e:Event=null):void
		{
			visible = false;
		}

		/*
		   public function removePswd(UserId:String=null):void//删除一条用户帐号及密码
		   {
		   if(UserId == null)UserId = FamilyData.UserId;
		   WriteData.removeFiles(WriteData.usrDir(UserId).nativePath);//remove the pswd files
		   Login.mains.show_selectlist();
		   }
		 */
	}
}

