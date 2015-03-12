/**
  建筑单体 高端建材专区
  建筑单体模块进入后自动播放序列帧动画到最后一帧停止出现商铺户型按钮，点击后链接到商铺户型模块。
 */
package dc {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class I4 extends Sprite{
		public function I4(){
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
			firstbmp = new Sprite();
			addChild(firstbmp);
			ViewSet.removes(firstbmp);
			Bitmap(firstbmp.addChild(new Assets.b40)).smoothing = true;
			firstbmp.visible = true;
			var bw:int = data.stageW/10;
			var btn:Sprite = ViewSet.makebtn(firstbmp.width-bw,firstbmp.height*.05,"b",bw,bw,clicked);
			firstbmp.addChild(btn);
			ViewSet.fullCenter(firstbmp,0.,0,data.stageW,data.stageH);

			/*
			   var bg0:Bitmap = new Assets.b41;
			   bg0.smoothing = true;
			   ViewSet.fullCenter(bg0,0,0,data.stageW,data.stageH);
			   firstbmp.addChildAt(bg0,0);
			 */
		}
		private var dir_arr:Array;
		private function show(b:Boolean=true):void
		{
			if(b){
				var dir:String = data.asset_root+data.m4;
				logs.adds(dir);
				var path_arr:Array = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
				//addfirst();
				//return;
				if(dir){
					var sequenceplayer:SequencePlayer = new SequencePlayer(path_arr,true);
					sequenceplayer.setSize(data.stageW,data.stageH);
					addChildAt(sequenceplayer,0);
					sequenceplayer.stop_play();
					sequenceplayer.addEventListener(Event.COMPLETE,completed);
				}

			}else{
				ViewSet.removes(this);
			}
		}
		private function makebtn():Sprite
		{
			var sprite:Sprite = new Sprite;
			//[Embed(source="assets/hxzsbg.png")] var  hxzsbgbg:Class;
			//sprite.addChild(new hxzsbgbg);
			//[Embed(source="assets/hxzs.png")] var  hxzs:Class;
			//var txt:Bitmap = new hxzs;
			//ViewSet.center(txt,0,0,sprite.width,sprite.height);
			var bmp:Bitmap = new Assets.n50 as Bitmap;
			bmp.smoothing = true;
			sprite.addChild(bmp);
			return sprite;
		}
		private function completed(e:Event):void
		{
			trace(e.type);
			if(btns==null){
				//btns = ViewSet.makeBtnByDirs(["商铺户型"]) as Sprite;
				btns = new Sprite;
				btns.addChild(makebtn());
				if(btns)addChild(btns);
				var i:int = 0;
				if(btns){
					while(i < btns.numChildren)
					{
						var btn:Sprite = btns.getChildAt(i) as Sprite;
						if(btn){
							btn.x = data.stageW *.9 - btn.width/2;
							btn.y = data.stageH *.2 + btn.height*2*i;
							btn.mouseChildren = false;
							btn.addEventListener(MouseEvent.CLICK,tohx);
						}
						++i;
					}
				}
			}
			if(btns)addChild(btns);
		}
		private function tohx(e:MouseEvent):void
		{
			smain.main.clickBtn(5);
			ViewSet.removes(this);
		}
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
					case "商铺户型":
						smain.main.clickBtn(5);
						break;
				}
			}
			ViewSet.removes(this);
		}
		private var btns:Sprite;
		private static var _main:I4;
		private static function get main():I4
		{
			if(_main==null)_main = new I4;
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

