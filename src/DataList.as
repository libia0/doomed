/**
  显示某个对象数据列表:
  var datalist:DataList= new DataList(new Rectangle(0,0,1000,1000),1,10,5);
  datalist.init_arr([{url:"yuanshen/bg/bore.jpg",name:"地址"},{url:"yuanshen/bg/lianhua.jpg"},{url:"yuanshen/bg/liuli.jpg"}],1,new Bitmap(new BitmapData(100,100,true,0)),["url","name"],[200,100]);
  addChild(datalist);
 */
package
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	[SWF(width="1024",height="768",frameRate="12",backgroundColor=0x000000)] public class DataList extends Sprite
	{
		private var path_arr:Array;
		private var obj_arr:Array;
		private var mylist:MyList;
		private var cols:uint;//显示的列数
		private var rows:uint;//显示的行数
		private var gap:uint;
		private var to:int;//方向,横竖
		private var show_rect:Rectangle;//整个显示的遮罩区域
		public var select_index:int = 0;
		public function DataList(_rect:Rectangle=null,_cols:uint=1,_rows:uint=10,_gap:uint=5)
		{
			if(_rect==null)_rect = new Rectangle(0,0,700,100);
			show_rect = _rect;
			cols = _cols;
			rows = _rows;
			gap = _gap;
			mylist = new MyList();
			mylist.addEventListener(Event.SELECT,on_click_show);
			mylist.MaskRect = _rect;
			addChild(mylist);
			if(stage)init_arr();
		}

		private function make_line(obj:Object):BaseSprite
		{
			var container:BaseSprite = new BaseSprite;
			var i:int = 0;
			if(colsArr){
				var w:int = 30;
				for each(var s:String in colsArr)
				{
					if(widthsArr && widthsArr.length >i){
						w = widthsArr[i];
					}
					/*trace(s,obj[s]);*/
					if(s == "url"){
						/*trace(obj[s]);*/
						var photo:PhotoLoader = new PhotoLoader(obj[s],w,w);
						photo.x = container.width;
						container.addChild(photo);
					}else{
						var txt:TextField = make_txt(obj[s]);
						txt.x = container.width;
						if(widthsArr && widthsArr.length >i){
							txt.width = widthsArr[i];
						}
						container.addChild(txt);
					}
					++i;
				}
			}else{ 
				for(var p:String in obj)
				{
					if(widthsArr && widthsArr.length >i){
						w = widthsArr[i];
					}
					if(p == "url"){
						photo= new PhotoLoader(obj[p],w,w);
						photo.x = container.width;
						container.addChild(photo);
					}else{
						txt = make_txt(obj[p]);
						txt.width=w;
						txt.x = container.width;
						container.addChild(txt);
					}
					++i;
				}
			}
			return container;
		}


		private function make_txt(s:String):TextField
		{
			var txt:TextField = new TextField;
			txt.defaultTextFormat = new TextFormat("",16,0xffffff);
			txt.text = (s?s:"");
			/*txt.text = String(s);*/
			return txt;
		}

		/**
		 * 

		 _objArr	 对象数组
		 _to		 方向
		 _bgbmp		 背景
		 _colsArr	 列
		 _widthsArr	 列宽

		 没有得到认同,
		 没有让你感觉好有爱,
		 没有高端大气上档次,
		 没有激情,
		 没有满足你的欲望,
		 没有让你震撼,
		 没有心灵共鸣,
		 我该如何脱颖而出,
		 我拿什么满足你.
		 且看下回分解

		 */
		private var colsArr:Array;
		private var widthsArr:Array;
		public function init_arr(_objArr:Array=null,_to:int=2,_bgbmp:Bitmap=null,_colsArr:Array=null,_widthsArr:Array=null):void
		{
			colsArr = _colsArr;
			widthsArr = _widthsArr;
			bgbmp = _bgbmp;
			to = _to;
			obj_arr = _objArr;
			mylist.setVRoll(Boolean(_to==1));
			clear();
			if(_objArr)path_arr = new Array;
			else path_arr = null;
			for each(var obj:Object in _objArr)
			{
				oneLoaded(make_line(obj));
			}
			allLoad();
		}


		public function clear(e:Event=null):void
		{
			if(path_arr)path_arr.splice(0,path_arr.length);
			mylist.removes();
		}

		public function prevPage():void
		{
			mylist.prevPage();
		}
		public function nextPage():void
		{
			mylist.nextPage();
		}


		private function allLoad(e:Event=null):void
		{
			/*trace("all done");//*/
		}

		private function oneLoaded(obj:DisplayObject):void
		{
			var index:uint = mylist.numItems;
			/*trace(index);*/
			var border_w:int = show_rect.width/cols;
			var border_h:int = show_rect.height/rows;
			var xx:int = show_rect.x+(index%cols)*border_w;
			var yy:int = show_rect.y+int(index/cols)*border_h;
			if(to == 2){
				xx= show_rect.x+int(index/rows)*border_w;
				yy= show_rect.y+int(index%rows)*border_h;
			}
			/*trace(xx,yy,border_w,border_h);*/
			var pic:Sprite = new Sprite();
			pic.mouseChildren = false;
			pic.buttonMode= true;
			if(bgbmp){
				var bg:Bitmap =new Bitmap(bgbmp.bitmapData);
				bg.width = border_w;
				bg.height= border_h;
				pic.addChild(bg);
			}else{
				var picbg:Shape = new Shape();
				picbg.graphics.beginFill(0x0,.9);
				picbg.graphics.drawRect(gap,gap,border_w-gap*2,border_h-gap*2);
				picbg.graphics.endFill();
				pic.addChild(picbg);
			}
			pic.x=xx;
			pic.y=yy;
			if(obj){
				pic.addChild(obj);
			}
			pic.name = "p"+index;
			mylist.addItem(pic);
		}

		private var bgbmp:Bitmap;
		/**
		  切换图标背景
		 */
		public function swapPicBg(obj:Bitmap):void
		{
			if(obj==null)return;
			bgbmp = obj;
			var i:int = mylist.numItems;
			while(i>0)
			{
				--i;
				var item:Sprite = mylist.getItemAt(i) as Sprite;
				if(item){
					if(item.numChildren>1){
						var old:DisplayObject = item.getChildAt(0);
						item.removeChild(old);
						old = null;
						if(obj is Bitmap){
							var bg:Bitmap = new Bitmap(Bitmap(obj).bitmapData);
							var border_w:int = show_rect.width/cols;
							var border_h:int = show_rect.height/rows;
							item.width = border_w;
							item.height= border_h;
							item.addChild(bg);
						}
					}
				}
			}
		}
		/*private var imglistshow:ImgListShow;*/
		private function on_click_show(e:Event=null):void{
			var target:Sprite = mylist.ClickObject;
			select_index = uint(target.name.substr(1));
			trace(select_index);
			/*if(imglistshow)imglistshow.show(select_index);*/
			dispatchEvent(new Event(Event.SELECT));
		}

		/*
		   public function get curbmp():Bitmap
		   {
		   if(select_index < arrloader.bmpArr.length)
		   return arrloader.bmpArr[select_index];
		   return null;
		   }
		 */

		public function getItemByIndex(i:int):DisplayObject
		{
			var obj:DisplayObject = mylist.getItemAt(i) as DisplayObject;
			if(obj)return obj;
			obj = mylist.getItemByName("p"+i) as DisplayObject;
			if(obj)return obj;
			return null;
		}
	}
}



