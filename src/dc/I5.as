/**
  商铺户型
  商铺户型模块新添加楼层切换按钮，点击相应楼层切换相应楼层的序列帧，该序列帧不需要自动播放但是需要能滑动播放，并且每个楼层都有相应的按钮连接 全景360。
 */
package dc {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class I5 extends Sprite{
		public function I5(){
			_main = this;
		}

		private static var _btnsStrArr:Array;
		public static function get btnsStrArr():Array
		{
			if(_btnsStrArr)
				return _btnsStrArr;
			if(dir_arr==null)
				dir_arr = SwfLoader.dirsInDir(data.asset_root+data.m5,".*") as Array;
			if(dir_arr==null)
				return null;
			for each(var s:String in dir_arr)
			{
				if(_btnsStrArr==null)_btnsStrArr = new Array();
				var _str:String = s.replace(/^.*[\/\\]([^\/\\]+)[\/\\]*$/,"$1");
				_btnsStrArr.push(_str);
			}
			return _btnsStrArr;
		}

		private static var pic_path_arr:Array = null;

		private static var dir_arr:Array;
		private function show(b:Boolean=true):void
		{
			ViewSet.removes(this);
			if(b){
				play();
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
				dir_arr = SwfLoader.dirsInDir(data.asset_root+data.m5,".*");
			trace("dir_arr:",dir_arr);
			if(dir_arr==null){
				return;
			}

			var _dir:String= null;
			if(dir==null){
				_dir = dir = dir_arr[0];
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
				var sequenceplayer:SequencePlayer = new SequencePlayer(pic_path_arr,false);
				sequenceplayer.setSize(data.stageW,data.stageH);
				addChild(sequenceplayer);
				//sequenceplayer.addEventListener(Event.COMPLETE,completed);
			}
			completed(null);
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
						if (btn_obj.match("一")) {
							bmp = new Assets.n51;
						}else if (btn_obj.match("二")) {
							bmp = new Assets.n52;
						}else if (btn_obj.match("三")) {
							bmp = new Assets.n53;
						}else {
							bmp = new Assets.n50;
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
		private var btns:Sprite;
		private static var _main:I5;
		private static function get main():I5
		{
			if(_main==null)_main = new I5;
			return _main;
		}
		public static function show(b:Boolean=true):void {
			main.visible = b;
			if(b){
				ViewSet.removes(smain.bg_container);
				smain.bg_container.addChild(main);
				main.show(b);
			}else{
				return;
			}
		}
	}
}

