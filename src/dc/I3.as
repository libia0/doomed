/**
  项目沙盘
  项目沙盘进入时自动播放序列帧动画到最后一帧停止，在界面上出现 中心广场、建筑单体（即高端........）、4个街区漫游 的链接按钮，点击相应的按钮连接到相应的模块。
  
  
  3、项目沙盘：快捷按钮去掉，只增加一个分层业态的按钮；
 */

package dc {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class I3 extends Sprite {
		private const btnsStrArr:Array = ["中心广场","高端建材专区","红星美凯龙","品牌旗舰区","十字金街一层","十字金街二层"];
		public function I3(){
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
		private var firstbmp:Sprite;
		private function clicked(e:Event=null):void
		{
			firstbmp.visible = false;
		}
		private function addfirst():void
		{
			firstbmp = new Sprite;
			addChild(firstbmp);
			ViewSet.removes(firstbmp);
			Bitmap(firstbmp.addChild(new Assets.b30)).smoothing = true;
			firstbmp.visible = true;
			var bw:int = data.stageW/10;
			var btn:Sprite = ViewSet.makebtn(firstbmp.width-bw,firstbmp.height*.05,"b",bw,bw,clicked);
			firstbmp.addChild(btn);
			ViewSet.fullCenter(firstbmp,0.,0,data.stageW,data.stageH);
		}
		private static var pic_path_arr:Array;
		private function show(b:Boolean=true):void
		{
			if(b){
				//addfirst();
				var dir:String = data.asset_root+data.m3;
				logs.adds(dir);
				/*
				   var dir_arr:Array = SwfLoader.dirsInDir(dir,".*");
				   if(dir_arr){
				   for each(var path:String in dir_arr)
				   {
				   var arr:Array = SwfLoader.filesInDir(path,SwfLoader.imgReg);
				   if(arr){

				   if(pic_path_arr==null) pic_path_arr = new Array;
				   for each(var p:String in arr)
				   pic_path_arr.push(p);
				   }
				   }
				   }
				 */
				if(pic_path_arr==null) pic_path_arr = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
				//return;
				//var sequenceplayer:SequencePlayer = new SequencePlayer(dir_arr[0]);
				var sequenceplayer:SequencePlayer = new SequencePlayer(pic_path_arr,true);
				sequenceplayer.setSize(data.stageW,data.stageH);
				sequenceplayer.addEventListener(Event.COMPLETE,completed);
				addChildAt(sequenceplayer,0);

			}else{
				ViewSet.removes(this);
			}
		}
		private function completed(e:Event):void
		{
			/*
			trace(e.type);
			if(btns==null && btnsStrArr){
				btns = ViewSet.makeBtnByDirs(btnsStrArr) as Sprite;
			}
			if(btns){
				addChild(btns);
				var i:int = 0;
				while(i < btns.numChildren)
				{
					var btn:TxtBtn = btns.getChildAt(i) as TxtBtn;
					if(btn){
						btn.x = data.stageW *.9 - btn.width/2;
						btn.y = data.stageH *.2 + btn.height*2.*i;
						btn.mouseChildren = false;
						btn.addEventListener(MouseEvent.CLICK,btnClicked);
					}
					++i;
				}
			}
			*/
			[Embed(source = "cut/3/btn.png")]var btnpng:Class;
			var btnbmp:Bitmap = new btnpng;
			btnbmp.smoothing = true;
			var nextbtn:Sprite = new Sprite();
			nextbtn.mouseChildren = false;
			nextbtn.addEventListener(MouseEvent.CLICK,showNex);
			nextbtn.addChild(btnbmp);
		}
		
		private function showNex(e:MouseEvent):void 
		{
			var dir:String = data.asset_root + data.m31;
			var arr:Array = SwfLoader.filesInDir(dir, SwfLoader.imgReg);
			if (arr) {
				ViewSet.removes(main);
				var sequenceplayer:SequencePlayer = new SequencePlayer(arr,true);
				sequenceplayer.setSize(data.stageW,data.stageH);
				//sequenceplayer.addEventListener(Event.COMPLETE,ended);
				addChildAt(sequenceplayer,0);
			}
		}


		/**
		 * 
		 private const btnsStrArr:Array = ["中心广场","建筑单体","红星美凯龙","品牌旗舰区","十字金街一层","十字金街二层"];
		 * @param	e
		 */
		private function btnClicked(e:MouseEvent):void
		{
			if (e) {
				var s:String = TxtBtn(e.currentTarget)["cur_obj"] as String;
				s = s.replace(/[\r\n\s]/g,"");
				trace(s);
				switch(s) {
					case "中心广场":
						smain.main.clickBtn(7);
						//I7.show();
						break;
					case "高端建材专区":
						//I4.show();
						smain.main.clickBtn(4);
						break;
					case "红星美凯龙":
					case "品牌旗舰区":
					case "十字金街一层":
					case "十字金街二层":
						smain.main.clickBtn(6);
						I6.play(s);
						break;
				}
			}
			ViewSet.removes(this);
		}
		private var btns:Sprite;
		private static var _main:I3;
		private static function get main():I3
		{
			if(_main==null)_main = new I3;
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

