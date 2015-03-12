/**
 *
 * *首页进入时先播放一段片头动画，点击动画或自动播放完时进到区域沙盘页面。
 *下侧菜单中首页按钮改为“项目影片按钮”点击后播放片头动画。
 *
 * 2、在首页动画界面增加一个skip图标，可跳过播放直接到区域沙盘；
 */
package dc
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class I1 extends Sprite
	{
		public function I1()
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
		private var firstbmp:Sprite;
		
		private function clicked(e:Event = null):void
		{
			firstbmp.visible = false;
		}
		/*
		   private function addfirst():void
		   {
		   firstbmp = new Sprite();
		   addChild(firstbmp);
		   ViewSet.removes(firstbmp);
		   Bitmap(firstbmp.addChild(new Assets.b10)).smoothing = true;
		   firstbmp.visible = true;
		   var bw:int = data.stageW/10;
		   var btn:Sprite = ViewSet.makebtn(firstbmp.width-bw,firstbmp.height*.15,"b",bw,bw,clicked);
		   firstbmp.addChild(btn);
		   ViewSet.fullCenter(firstbmp,0.,0,data.stageW,data.stageH);
		   }
		 */
		private var start_flv:Videos;
		
		private function show(b:Boolean = true):void
		{
			if (b)
			{
				var dir:String = data.asset_root + data.m1;
				logs.adds(dir);
				var files:Array = SwfLoader.filesInDir(dir, SwfLoader.vidReg);
				if (files)
				{
					start_flv = new Videos(files[0]);
					start_flv.addEventListener(Event.COMPLETE, gotoNext);
					[Embed(source="cut/1/skip.png")]
					var skippng:Class;
					var skipbtn:Sprite = new Sprite();
					var skipbmp:Bitmap = new skippng;
					skipbmp.smoothing = true;
					skipbtn.addChild(skipbmp);
					skipbtn.mouseChildren = false;
					start_flv.addChild(skipbtn);
					skipbtn.addEventListener(MouseEvent.CLICK, skipPlay);
					addChild(start_flv);
				}
				else
				{
					gotoNext();
				}
				
				/*
				   addfirst();
				
				   var bg0:Bitmap = new Assets.b11;
				   bg0.smoothing = true;
				   ViewSet.fullCenter(bg0,0,0,data.stageW,data.stageH);
				   addChildAt(bg0,0);
				 */
			}
			else
			{
				ViewSet.removes(this);
			}
		}
		
		private function skipPlay(e:MouseEvent):void
		{
			gotoNext();
			try
			{
				start_flv.stop();
			}
			catch (e:Error)
			{
				ViewSet.removes(start_flv);
			}
		}
		
		private function gotoNext(e:Event = null):void
		{
			smain.main.clickBtn(2);
		}
		private static var _main:I1;
		
		private static function get main():I1
		{
			if (_main == null)
				_main = new I1;
			return _main;
		}
		
		public static function show(b:Boolean = true):void
		{
			main.visible = b;
			if (b)
			{
				ViewSet.removes(smain.bg_container);
				ViewSet.removes(main);
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

