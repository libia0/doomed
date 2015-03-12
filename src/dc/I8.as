/**
  品牌楼书
  品牌楼书 为图片浏览模块，每张图片可多点放大缩小
  
  
  
4、品牌图片缩小，不小于全屏的宽高，或者缩小松开后弹回全屏；
5、品牌图片浏览时，会出现之前栏目在底下（不是全屏图片时）；
 */
package dc {
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class I8 extends Sprite{
		public function I8(){
			_main = this;

			var imglist:ImgList = new ImgList(new Rectangle(0,0,data.stageW,data.stageH/8),10,1,5);
			//var imglist:ImgList = new ImgList(null);
			//imglist.haslist=false;
			imglist.show_close = false;
			imglist.show_change= false;
			var dir:String = data.asset_root+data.m8;
			logs.adds(dir);
			var path_arr:Array = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
			/*imglist.init(path_arr,2,new Bitmap(new BitmapData(100,100)));*/
			imglist.init(path_arr);
			addChild(imglist);
			//backBtn = ViewSet.makebtn(data.scalex(12),data.scaley(201),"back",data.scalex(150),data.scaley(65),back);
			//addChild(backBtn);
		}

		//private var backBtn:Sprite;
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
		private static var _main:I8;
		private static function get main():I8
		{
			if(_main==null)_main = new I8;
			return _main;
		}
		public static function show(b:Boolean=true):void {
			main.visible = b;
			if(b){
				ViewSet.removes(smain.bg_container);
				smain.bg_container.addChild(main);
			}else{
				return;
			}
		}
	}
}

