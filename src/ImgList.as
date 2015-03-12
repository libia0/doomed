/**
   var imglist:ImgList = new ImgList(_rect:Rectangle,_cols:uint=2,_rows:uint=2,_gap:uint=5)

   imglist.init("imagedir",1,bgbmp);
   或
   imglist.init_path_arr([{url:"image.jpg"},{url:"image.jpg"}],"url",1,bgbmp);


   如:
   var imglist:ImgList = new ImgList(new Rectangle(0,0,1000,1000),2,2,5);
   imglist.init_path_arr([{url:"yuanshen/bg/bore.jpg"},{url:"yuanshen/bg/lianhua.jpg"},{url:"yuanshen/bg/liuli.jpg"}],"url",1,new Bitmap(new BitmapData(100,100,true,0)));
   addChild(imglist);

 */
package
{
	import dc.data;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	[SWF(width="1024",height="768",frameRate="12",backgroundColor=0x000000)]
	
	public class ImgList extends Sprite
	{
		public var hasbig:Boolean = true; //show big image
		private var _haslist:Boolean = true; //show small list,can click
		
		public function set haslist(b:Boolean):void
		{
			if (mylist)
				mylist.visible = b;
			_haslist = b;
		}
		public var show_close:Boolean = true; //show close_btn
		public var show_change:Boolean = true; //show prev_btn and next_btn
		private var path_arr:Array;
		private var obj_arr:Array;
		private var arrloader:ArrLoader;
		private var mylist:MyList;
		private var cols:uint; //显示的列数
		private var rows:uint; //显示的行数
		private var gap:uint;
		private var to:int; //方向,横竖
		private var show_rect:Rectangle; //整个显示的遮罩区域
		private var pic_rect:Rectangle; //图片在均分的块中显示的位置
		public var select_index:int = -1;
		
		public function ImgList(_rect:Rectangle = null, _cols:uint = 5, _rows:uint = 1, _gap:uint = 5)
		{
			if (_rect == null)
			{
				haslist = false;
				/*_rect = new Rectangle(0,0,700,100);*/
			}
			show_rect = _rect;
			cols = _cols;
			rows = _rows;
			gap = _gap;
			
			if (_rect)
			{
				mylist = new MyList();
				mylist.addEventListener(Event.SELECT, on_click_show);
				mylist.MaskRect = _rect;
				addChild(mylist);
			}
			if (stage)
				init();
		}
		
		private function show_list(e:Event):void
		{
			if (e.type == "showlist")
			{
				haslist = true;
				if(mylist)addChild(mylist);
			}
			else
			{
				haslist = false;
			}
		}
		
		/**
		 *
		 */
		public function init_path_arr(_objArr:Array = null, _property:String = "url", _to:int = 2, _bgbmp:Bitmap = null, _pic_rectangle:Rectangle = null):void
		{
			pic_rect = _pic_rectangle;
			bgbmp = _bgbmp;
			to = _to;
			obj_arr = _objArr;
			if (mylist)
				mylist.setVRoll(Boolean(_to == 1));
			clear();
			all_loaded = false;
			if (_objArr)
				path_arr = new Array;
			else
				path_arr = null;
			for each (var obj:Object in _objArr)
			{
				path_arr.push(obj[_property]);
			}
			if (path_arr && _haslist)
			{
				arrloader = new ArrLoader(path_arr, allLoad, oneLoaded);
			}
			if (hasbig)
			{
				addbig();
			}
		}
		
		/**
		   to : 方向,1:横排,2竖排
		   _bgbmp:图标背景
		 */
		public function init(_path_arr:Array = null, _to:int = 2, _bgbmp:Bitmap = null, _pic_rectangle:Rectangle = null):void
		{
			pic_rect = _pic_rectangle;
			bgbmp = _bgbmp;
			to = _to;
			if (mylist)
				mylist.setVRoll(Boolean(_to == 1));
			clear();
			all_loaded = false;
			/*path_arr = SwfLoader.filesInDir(dir,SwfLoader.imgReg);*/
			if (path_arr)
				path_arr.splice(0, path_arr.length);
			path_arr = _path_arr;
			if (path_arr && _haslist)
			{
				trace("start arrloader");
				arrloader = new ArrLoader(path_arr, allLoad, oneLoaded);
			}
			if (hasbig)
				addbig();
		}
		
		private function addbig():void
		{
			if (hasbig)
			{
				var xrate:Number = 1.0;
				var rate:Number = .7;
				var w:int = (data.stageW);
				var h:int = (data.stageH);
				var rect:Rectangle = new Rectangle((1 - xrate) / 2 * w, data.scaley(0), w * xrate, (data.stageH));
				var close_btn:Sprite = new Sprite();
				var next_btn:Sprite = new Sprite();
				var prev_btn:Sprite = new Sprite();
				[Embed(source="dc/asset/prev.png")]
				var prevpng:Class;
				[Embed(source="dc/asset/next.png")]
				var nextpng:Class;
				prev_btn.addChild(new prevpng);
				next_btn.addChild(new nextpng);
				next_btn.width = prev_btn.width = data.scalex(prev_btn.width);
				next_btn.height = prev_btn.height = data.scaley(prev_btn.height);
				[Embed(source="dc/asset/back.png")]
				var closepng:Class;
				close_btn.addChild(new closepng);
				prev_btn.x = (.42 - rate / 2) * w - prev_btn.width / 2;
				next_btn.x = (.58 + rate / 2) * w - next_btn.width / 2;
				prev_btn.y = next_btn.y = h / 2 - prev_btn.height / 2;
				close_btn.x = data.scalex(12);
				close_btn.y = data.scalex(201);
				close_btn.width = data.scalex(150);
				close_btn.height = data.scalex(65);
				if (!show_change)
					prev_btn.alpha = next_btn.alpha = 0;
				if (!show_close)
					close_btn.visible = false;
				if (path_arr == null || path_arr.length <= 1) //最多一张图
					prev_btn.alpha = next_btn.alpha = 0;
				
				imglistshow = new ImgListShow(rect, close_btn, next_btn, prev_btn);
				addChild(imglistshow);
				if (!_haslist)
				{
					all_loaded = true;
					imglistshow.init_bmpArr(path_arr);
					imglistshow.show(0);
				}
				
				imglistshow.addEventListener("showlist", show_list);
				imglistshow.addEventListener("hidelist", show_list);
			}
		}
		
		public function clear(e:Event = null):void
		{
			if (arrloader)
				arrloader.clear();
			if (path_arr)
				path_arr.splice(0, path_arr.length);
			if (mylist)
				mylist.removes();
			if (imglistshow)
				imglistshow.close();
		}
		
		public function prevPage():void
		{
			if (mylist)
				mylist.prevPage();
		}
		
		public function nextPage():void
		{
			if (mylist)
				mylist.nextPage();
		}
		
		private function allLoad(e:Event = null):void
		{
			all_loaded = true;
			if (imglistshow && arrloader)
			{
				imglistshow.init_bmpArr(arrloader.bmpArr);
			}
			trace("all done"); //
			if (arrloader && arrloader.bmpArr)
			{
				trace(arrloader.bmpArr.length);
				if (imglistshow)
					imglistshow.show(0);
			}
		}
		
		private function oneLoaded(e:Event = null):void
		{
			var index:uint = arrloader.bmpArr.length - 1;
			trace(index);
			var border_w:int = show_rect.width / cols;
			var border_h:int = show_rect.height / rows;
			var xx:int = show_rect.x + (index % cols) * border_w;
			var yy:int = show_rect.y + int(index / cols) * border_h;
			if (to == 2)
			{
				xx = show_rect.x + int(index / rows) * border_w;
				yy = show_rect.y + int(index % rows) * border_h;
			}
			trace(xx, yy, border_w, border_h);
			var pic:Sprite = new Sprite();
			pic.mouseChildren = false;
			pic.buttonMode = true;
			if (bgbmp)
			{
				var bg:Bitmap = new Bitmap(bgbmp.bitmapData);
				bg.width = border_w;
				bg.height = border_h;
				pic.addChild(bg);
				bg.alpha = 0; //背景透明
			}
			else
			{
				var picbg:Shape = new Shape();
				picbg.graphics.beginFill(0x0, .9);
				picbg.graphics.drawRect(gap, gap, border_w - gap * 2, border_h - gap * 2);
				picbg.graphics.endFill();
				pic.addChild(picbg);
			}
			pic.x = xx;
			pic.y = yy;
			if (arrloader.bmpArr && arrloader.bmpArr.length > index)
			{
				var bmp:Bitmap = arrloader.bmpArr[index];
				if (bmp)
				{
					pic.addChild(bmp);
					if (pic_rect == null)
						pic_rect = new Rectangle(gap, gap, border_w - gap * 2, border_h - gap * 2);
					ViewSet.center_rect(bmp, pic_rect);
				}
			}
			
			pic.name = "p" + index;
			mylist.addItem(pic);
		}
		private var bgbmp:Bitmap;
		
		/**
		   切换图标背景
		 */
		public function swapPicBg(obj:Bitmap):void
		{
			if (mylist == null)
				return;
			if (obj == null)
				return;
			bgbmp = obj;
			var i:int = mylist.numItems;
			while (i > 0)
			{
				--i;
				var item:Sprite = mylist.getItemAt(i) as Sprite;
				if (item)
				{
					if (item.numChildren > 1)
					{
						var old:DisplayObject = item.getChildAt(0);
						item.removeChild(old);
						old = null;
						if (obj is Bitmap)
						{
							var bg:Bitmap = new Bitmap(Bitmap(obj).bitmapData);
							item.width = border_w;
							item.height = border_h;
							item.addChild(bg);
							bg.alpha = 0; //背景透明
						}
					}
				}
			}
		}
		
		private function get border_w():int
		{
			return show_rect.width / cols;
		}
		
		private function get border_h():int
		{
			return show_rect.height / rows;
		}
		private var shape:Shape;
		private var imglistshow:ImgListShow;
		private var all_loaded:Boolean = false;
		
		private function on_click_show(e:Event = null):void
		{
			if (mylist == null)
				return;
			if (all_loaded)
			{
				var target:Sprite = mylist.ClickObject;
				var to_index:int = uint(target.name.substr(1));
				if (select_index != to_index)
				{
					select_index = to_index;
					set_select(target);
					trace("select_index:", select_index);
				}
				if (select_index < 0)
					select_index = 0;
				if (imglistshow)
					imglistshow.show(select_index);
				dispatchEvent(e);
			}
		}
		
		private function set_select(target:Sprite = null):void
		{
			if (mylist == null)
				return;
			if (target == null)
				target = mylist.getItemByName("p" + select_index) as Sprite;
			if (shape == null)
			{
				shape = new Shape();
				with (shape)
				{
					graphics.clear();
					graphics.lineStyle(border_w / 100, 0xff0000);
					/*picbg.graphics.beginFill(0x0,.9);*/
					graphics.drawRect(0, 0, border_w, border_h);
				}
			}
			mylist.show_index(select_index);
			target.addChild(shape);
		}
		
		public function get curbmp():Bitmap
		{
			if (select_index < arrloader.bmpArr.length)
				return arrloader.bmpArr[select_index];
			return null;
		}
		
		public function getItemByIndex(i:int):DisplayObject
		{
			if (mylist == null)
				return null;
			obj = mylist.getItemByName("p" + i) as DisplayObject;
			if (obj)
				return obj;
			return null;
			var obj:DisplayObject = mylist.getItemAt(i) as DisplayObject;
			if (obj)
				return obj;
		}
	}
}

