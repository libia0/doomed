/**
  街区漫游
  街区漫游添加4个切换4段街区漫游的按钮
 */
package dc {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class I6 extends Sprite{
		public function I6(){
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

		/*
		   private var backBtn:Sprite;
		   private function back(e:Event):void
		   {
		   if(curBig){
		   ViewSet.clearObj(curBig);
		   curBig = null;
		   }else{
		   visible = false;
		   }
		   visible = false;
		   }
		 */
		private static var pic_path_arr:Array;
		private static var dir_arr:Array;
		private var btns:Sprite;
		private function show(b:Boolean=true):void
		{
			curDir = "";
			ViewSet.removes(this);
			if(b){
				playByDir("品牌旗舰街区");
				//playByDir("红星美凯龙");
			}
		}
		public static function play(dir:String=null):void
		{
			trace(dir);
			main.playByDir(dir);
		}

		public static var curDir:String="";
		private function playByDir(dir:String=null):void
		{
			if(curDir == dir)return;
			if(dir_arr==null)
				dir_arr = SwfLoader.dirsInDir(data.asset_root+data.m6,".*");
			trace("dir_arr:",dir_arr);
			if(dir_arr==null){
				return;
			}

			var _dir:String= null;
			if(dir==null){
				_dir = dir=dir_arr[0];
			}else{
				for each(var s:String in dir_arr){
					var i:int = String(s).replace(/[\\\/\r\n\s]/g,"").search(String(dir).replace(/[\r\n\s\\\/]/g,""));
					var b:Boolean = Boolean(i>=0);
					trace(s,dir,i);
					if(b)
					{
						_dir = s;
						break;
					}
				}
			}
			if(_dir){
				curDir = dir;
				trace(curDir,_dir);
				pic_path_arr = SwfLoader.filesInDir(_dir,SwfLoader.imgReg);
			}else{
				trace("get no dir ");
			}
			play_pics();
		}
		private function play_pics():void
		{
			if(pic_path_arr){
				ViewSet.removes(this);
				var sequenceplayer:SequencePlayer = new SequencePlayer(pic_path_arr,true);
				sequenceplayer.setSize(data.stageW,data.stageH);
				addChild(sequenceplayer);
				
				initPlayBtns(sequenceplayer);
				//sequenceplayer.addEventListener(Event.COMPLETE,completed);
			}
			completed(null);
		}
		public static function initPlayBtns(sequenceplayer:SequencePlayer=null):void
		{
			if (sequenceplayer) {
				var playbmp:Bitmap = new Assets.play;
				var pausebmp:Bitmap = new Assets.pause;
				var forwardbmp:Bitmap = new Assets.forward;
				var backwordbmp:Bitmap = new Assets.backward;
				
				playbmp.smoothing = true;
				pausebmp.smoothing = true;
				forwardbmp.smoothing = true;
				backwordbmp.smoothing = true;
				
				
				var playBtn:Sprite = new Sprite();
				var pauseBtn:Sprite = new Sprite();
				var forwardBtn:Sprite = new Sprite();
				var backwardBtn:Sprite = new Sprite();
				
				playBtn.mouseChildren = false;
				pauseBtn.mouseChildren = false;
				forwardBtn.mouseChildren = false;
				backwardBtn.mouseChildren = false;
				
				playBtn.addChild(playbmp);
				pauseBtn.addChild(pauseBtn);
				forwardBtn.addChild(forwardBtn);
				backwardBtn.addChild(backwardBtn);
				
				var btnx:int = 0;
				var btny:int = 0;
				var gapy:int = playBtn.height * 1.2;
				var gapx:int = 0;
				playBtn.x = btnx;
				pauseBtn.x += gapx;
				forwardBtn.x += gapx;
				backwardBtn.x += gapx;
				
				playBtn.y = btny;
				pauseBtn.y += gapy;
				forwardBtn.y += gapy;
				backwardBtn.y += gapy;
				
				sequenceplayer.initBtns(playBtn,pauseBtn,backwardBtn,forwardBtn);
			}
		}
		private function completed(e:Event):void
		{
			if(btns==null){
				btns = ViewSet.makeBtnByDirs(dir_arr) as Sprite;
			}
			if(btns){
				addChild(btns);
				var i:int = 0;
				while(i < btns.numChildren)
				{
					var btn:TxtBtn = btns.getChildAt(i) as TxtBtn;
					if (btn) {
						var btn_obj:String = btn.cur_obj as String;
						var bmp:Bitmap;
						if (btn_obj.match("红星")) {
							bmp = new Assets.n6hongxing;
						}else if (btn_obj.match("品牌")) {
							bmp = new Assets.n6pingpai;
						}else if (btn_obj.match("一")) {
							bmp = new Assets.n61;
						}else if (btn_obj.match("二")) {
							bmp = new Assets.n62;
						}else {
							bmp = new Assets.n6pingpai;
						}
						bmp.smoothing = true;
						btn.addChild(bmp);
						btn.x = data.stageW *.9 - btn.width/2;
						btn.y = data.stageH *.2 + btn.height*2.*i;
						btn.mouseChildren = false;
						btn.addEventListener(MouseEvent.CLICK,btnClicked);
					}
					++i;
				}
			}
			curDir = " ";
		}
		private function btnClicked(e:MouseEvent):void
		{
			if (e) {
				var s:String = TxtBtn(e.currentTarget).cur_obj as String;
				s = s.replace(/^.*\/\/?([^\/]+)\/?$/,"$1");
				trace("clicked:",s);
				play(s);
			}
		}
		private static var _main:I6;
		private static function get main():I6
		{
			if(_main==null)_main = new I6;
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

