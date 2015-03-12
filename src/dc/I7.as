/**
   中心广场
   中心广场依旧是序列帧动画进入时自动播放到最后一帧
 */
package dc
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class I7 extends Sprite
	{
		public function I7()
		{
			_main = this;
		
		/*
		   //var imglist:ImgList = new ImgList(new Rectangle(0,0,data.stageW,data.stageH/8),6,1,5);
		   var imglist:ImgList = new ImgList(null);
		   imglist.haslist=false;
		   imglist.show_close = true;
		   imglist.show_change= true;
		   var dir:String = data.asset_root+data.m8;
		   var path_arr:Array = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
		   //imglist.init(path_arr,2,new Bitmap(new BitmapData(100,100)));
		   imglist.init(path_arr);
		   addChild(imglist);
		   backBtn = ViewSet.makebtn(data.scalex(12),data.scaley(201),"back",data.scalex(150),data.scaley(65),back);
		   addChild(backBtn);
		 */
		
		}
		
		private var backBtn:Sprite;
		
		private function back(e:Event):void
		{
			/*
			   if(curBig){
			   ViewSet.clearObj(curBig);
			   curBig = null;
			   }else{
			   visible = false;
			   }
			 */
			visible = false;
		}
		
		private static var pic_path_arr:Array;
		private static var s360:S360;
		
		private function show(b:Boolean = true):void
		{
			if (b && s360)
			{
				addChild(s360);
				return;
			}
			
			ViewSet.removes(this);
			if (b)
			{
				
				var dir:String = data.asset_root + data.m7;
				logs.adds(dir);
				var dir_arr:Array = SwfLoader.dirsInDir(dir, ".*");
				if (dir_arr)
				{
					for each (var path:String in dir_arr)
					{
						var arr:Array = SwfLoader.filesInDir(path, SwfLoader.imgReg);
						if (arr)
						{
							
							if (pic_path_arr == null)
								pic_path_arr = new Array;
							for each (var p:String in arr)
								pic_path_arr.push(p);
						}
					}
						//return;
				}
				else
				{
					if (pic_path_arr == null)
						pic_path_arr = SwfLoader.filesInDir(dir, SwfLoader.imgReg);
				}
				if (pic_path_arr)
				{
					if (pic_path_arr.length == 1)
					{
						if (s360 == null)
							s360 = new S360(pic_path_arr[0]);
						addChild(s360);
					}
					else
					{
						
						//var sequenceplayer:SequencePlayer = new SequencePlayer(dir_arr[0]);
						var sequenceplayer:SequencePlayer = new SequencePlayer(pic_path_arr, true);
						sequenceplayer.setSize(data.stageW, data.stageH);
						addChildAt(sequenceplayer, 0);
						sequenceplayer.addEventListener(Event.COMPLETE, completed);
					}
				}
				/*
				   if(btns==null){
				   btns = ViewSet.makeBtnByDirs(dir_arr) as Sprite;
				   if(btns)addChild(btns);
				   var i:int = 0;
				   if(btns){
				   while(i < btns.numChildren)
				   {
				   var btn:TxtBtn = btns.getChildAt(i) as TxtBtn;
				   if(btn){
				   btn.x = data.stageW *.8 - btns.width;
				   btn.y = data.stageH *.2 + btns.height*2*i;
				   }
				   ++i;
				   }
				   }
				   }
				   if(btns)addChild(btns);
				 */
				
			}
		}
		private var btns:Sprite;
		
		private function completed(e:Event):void
		{
			trace(e.type);
		}
		/*
		   private function show(b:Boolean=true):void
		   {
		   if(b){
		   var dir:String = data.asset_root+data.m7;
		   var dir_arr:Array = SwfLoader.dirsInDir(dir,".*");
		   if(dir_arr){
		   //var path_arr:Array = new Array();
		   //for each(var arr:Array in dir_arr){
		   //path_arr.concat(arr);
		   //}
		   var sequenceplayer:SequencePlayer = new SequencePlayer(dir_arr[0]);
		   sequenceplayer.setSize(data.stageW,data.stageH);
		   addChild(sequenceplayer);
		   }
		   }else{
		   ViewSet.removes(this);
		   }
		   }
		 */
		private static var _main:I7;
		
		private static function get main():I7
		{
			if (_main == null)
				_main = new I7;
			return _main;
		}
		
		public static function show(b:Boolean = true):void
		{
			main.visible = b;
			if (b)
			{
				//ViewSet.removes(smain.bg_container);
				smain.bg_container.addChild(main);
				main.show(b);
			}
			else
			{
				return;
			}
		}
	}
}

