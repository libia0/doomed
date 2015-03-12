/**
  区域沙盘
 */
package dc {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class I2 extends Sprite{
		public function I2(){
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
		private function addChilds(e:Event):void
		{
			ViewSet.removes(this);
			var bmp:Bitmap = e.target.content as Bitmap;
			if(bmp){
				bmp.width = data.stageW;
				bmp.height = data.stageH;
				addChildAt(bmp,0);
			}
		}
		private var firstbmp:Sprite;
		private function clicked(e:Event=null):void
		{
			firstbmp.visible = false;
		}
		private function addfirst():void
		{
			firstbmp= new Sprite();
			addChild(firstbmp);
			ViewSet.removes(firstbmp);
			Bitmap(firstbmp.addChild(new Assets.b20)).smoothing = true;
			firstbmp.visible = true;
			var bw:int = data.stageW/10;
			var btn:Sprite = ViewSet.makebtn(firstbmp.width-bw,firstbmp.height*.05,"b",bw,bw,clicked);
			firstbmp.addChild(btn);
			ViewSet.fullCenter(firstbmp,0.,0,data.stageW,data.stageH);
		}
		private static var pic_path_arr:Array = null;
		private function show(b:Boolean=true):void
		{
			ViewSet.removes(this);
			if(b){
				//addfirst();
				var dir:String = data.asset_root+data.m2;
				logs.adds(dir);
				pic_path_arr = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
				/*
				if(pic_path_arr){
					SwfLoader.SwfLoad(pic_path_arr[0],addChilds);
					return;
				}
				var dir_arr:Array = SwfLoader.dirsInDir(dir,".*") as Array;
				if(dir_arr && pic_path_arr == null){
					var i:int = 0;
					var arrarr:Array = new Array;
					while(i<dir_arr.length)
					{
						var path:String = dir_arr[i] as String;
						var arr:Array = SwfLoader.filesInDir(path,SwfLoader.imgReg) as Array;
						if(arr && arr.length>1){
							trace(arr);
							if(pic_path_arr==null) pic_path_arr = new Array;
							for each(var p:String in arr)
								pic_path_arr.push(p);
						}
						++i;
					}
					//return;
					//var sequenceplayer:SequencePlayer = new SequencePlayer(dir_arr[0]);
				}
				*/
				if(pic_path_arr){
					var sequenceplayer:SequencePlayer = new SequencePlayer(pic_path_arr,true);
					sequenceplayer.setSize(data.stageW,data.stageH);
					sequenceplayer.addEventListener(Event.COMPLETE,completed);
					addChildAt(sequenceplayer,0);
				}
				/*
				if(btns==null){
					btns = ViewSet.makeBtnByDirs(dir_arr) as Sprite;
					if(btns)addChild(btns);
					i = 0;
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
			}else{
				ViewSet.removes(this);
			}
		}
		private function completed(e:Event):void
		{
			trace(e.type);
		}
		private var btns:Sprite;
		private static var _main:I2;
		private static function get main():I2
		{
			if(_main==null)_main = new I2;
			return _main;
		}
		public static function show(b:Boolean=true):void {
			main.visible = b;
			if(b){
				ViewSet.removes(smain.bg_container);
				ViewSet.removes(main);
				smain.bg_container.addChild(main);
				main.show(b);
			}else{
				return;
			}
		}
	}
}

