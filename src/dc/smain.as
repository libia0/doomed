/**
 * @file smain.as
 *  主文档类，
 * flashdevelop 中需加编译参数：-define=CONFIG::debugging,false -define=CONFIG::PUBLISH,true -define=CONFIG::FANTI,false
 * debugging为false是发布版本，设为true为调试版本，参数PUBLISH相反，参数FANTI不应考虑。
 * 下侧菜单按钮默认为隐藏状态，下侧会有一个小按钮提供菜单呼出，点击完菜单中的按钮或没有任何操作5秒后自动回到隐藏状态。呼出的效果最好是做成滑动下面部分菜单自己跟上来
 *
 *
 * 1、屏幕两侧增指向按钮，可滑动切换栏目；
 *
 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-12-14
 */
package dc
{
	import com.greensock.TweenLite;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.utils.*;
	//CONFIG::PUBLISH
	//{
		//[SWF(width="1024",height="768",frameRate="60",backgroundColor=0x0)]
	//}
	
		[SWF(width="256",height="192",frameRate="60",backgroundColor=0x0)]
	public class smain extends Sprite
	{
		private static var _main:smain;
		
		public static function get main():smain
		{
			if (_main == null)
				_main = new smain;
			return _main;
		}
		private var bottom1:Sprite;
		private var btnContainer:Sprite = new Sprite();
		
		public function smain()
		{
			_main = this;
			logs.adds("hello..");
			
			data.stageW = stage.stageWidth;
			data.stageH = stage.stageHeight;
			CONFIG::PUBLISH
			{
				stage.displayState = "fullScreen";
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			var head:Bitmap = new Assets.headjpg;
			head.smoothing = true;
			head.width = data.stageW;
			head.scaleY = head.scaleX;
			addChild(head);
			
			if (bottom1 == null)
			{
				bottom1 = new Sprite;
				bottom1.mouseChildren = false;
				var bottombmp:Bitmap = new Assets.bottomjpg;
				bottom1.addChild(bottombmp);
				bottombmp.smoothing = true;
				bottombmp.width = data.stageW;
				bottombmp.scaleY = bottom1.scaleX;
				bottombmp.y = data.stageH - bottombmp.height;
				bottom1.addEventListener(MouseEvent.CLICK, show_hide);
			}
			addChild(btnContainer);
			addChild(bottom1);
			
			CONFIG::debugging
			{
				//addChild(new logs);
				init();
				return;
			}
			
			init();
			return;
		/*
		   var start_flv:Videos = new Videos();
		   start_flv.addEventListener(Event.COMPLETE,init);
		   stage.addChild(start_flv);
		 */
		}
		
		private const yrate_unchoosen:Number = .8;
		private const yrate_choosen:Number = .75;
		public static var bg_container:Sprite = new Sprite();
		
		private function changeBg(i:int):void
		{
			SwfLoader.SwfLoad(i + ".jpg", loaded)
		}
		
		private function loaded(e:Event):void
		{
			ViewSet.removes(bg_container);
			if (e && e.type == Event.COMPLETE)
			{
				bg_container.addChild(e.target.content);
				bg_container.width = data.stageW;
				bg_container.height = data.stageH;
			}
		}
		
		private function init(e:Event = null):void
		{
			if (e)
				e.target.removeEventListener(Event.COMPLETE, init);
			data.stageW = stage.stageWidth;
			data.stageH = stage.stageHeight;
			addChildAt(bg_container, 0);
			clicked();
			
			CONFIG::debugging
			{
				/*
				   var dir:String = data.asset_root+data.m4;
				   logs.adds(dir);
				   var path_arr:Array = SwfLoader.filesInDir(dir,SwfLoader.imgReg);
				   logs.adds("path_arr:",path_arr);
				   if(dir){
				   var sequenceplayer:SequencePlayer = new SequencePlayer(path_arr);
				   sequenceplayer.setSize(data.stageW,data.stageH);
				   addChild(sequenceplayer);
				   }
				 */ /*
				   var btns:Sprite;
				   if(btns==null){
				   btns = ViewSet.makeBtnByDirs(["test"]);
				   addChild(btns);
				   var i:int = 0;
				   if(btns){
				   while(i < btns.numChildren)
				   {
				   var btn:TxtBtn = btns.getChildAt(i) as TxtBtn;
				   if(btn){
				   btn.x = data.stageW *.8 - btn.width;
				   btn.y = data.stageH *.2 + btn.height*2*i;
				   }
				   ++i;
				   }
				   }
				   }
				   if(btns)addChild(btns);
				 */
				clickBtn(8);
				return;
			}
		}
		
		private function addbtns():void
		{
			logs.adds("addbtns()");
			var curx:int = scalex(0);
			var cury:int = scaley(data.stageH * yrate_unchoosen);
			var gap:int = scalex(data.stageW / 8);
			var cx:int = gap;
			var cy:int = scaley(data.stageH * (1 - yrate_unchoosen));
			var i:int = 0;
			var numbtns:uint = 8;
			while (i < numbtns)
			{
				if (btnContainer.getChildByName("b" + (i + 1)) as Sprite)
				{
					//logs.adds((i+1) +"already exists");
				}
				else
				{
					var btn:Sprite = ViewSet.makebtn(curx, cury, "b" + (i + 1), cx, cy, clicked);
					var bg0:Bitmap = new Assets.bg0;
					var bg1:Bitmap = new Assets.bg1;
					var txt:Bitmap = new Assets["t" + (i + 1)];
					bg1.smoothing = bg0.smoothing = txt.smoothing = true;
					bg0.width = bg1.width = gap;
					bg0.height = bg1.height = cy;
					bg1.visible = false;
					if (txt.width < gap && txt.height < cy)
					{
						ViewSet.center(txt, 0, 0, gap, cy);
					}
					else
					{
						ViewSet.fullCenter(txt, 0, 0, gap, cy);
					}
					btn.addChildAt(bg0, 0);
					btn.addChildAt(bg1, 1);
					btn.addChild(txt);
					curx += gap;
					btnContainer.addChild(btn);
					logs.adds((i + 1) + "added");
				}
				++i;
			}
			btnContainer.y = -bottom1.height * .9;
			hide_btns();
			
			makeArrowBtn();
		}
		
		private function makeArrowBtn():void
		{
			var leftbtn:Sprite = new Sprite();
			var rightbtn:Sprite = new Sprite();
			leftbtn.addChild(new Assets.leftpng);
			rightbtn.addChild(new Assets.rightpng);
			leftbtn.mouseChildren = false;
			rightbtn.mouseChildren = false;
			leftbtn.name = "left";
			rightbtn.name = "right";
			leftbtn.y = rightbtn.y = data.stageH / 2 - leftbtn.height / 2;
			leftbtn.x = data.stageW * .2 / 2 - leftbtn.width / 2;
			rightbtn.x = data.stageW * .8 / 2 - rightbtn.width / 2;
			leftbtn.addEventListener(MouseEvent.CLICK, changItems);
			rightbtn.addEventListener(MouseEvent.CLICK, changItems);
		}
		
		private function changItems(e:MouseEvent):void
		{
			var curSelected:int = curIndex;
			if (e && e.type == MouseEvent.CLICK)
			{
				switch (e.currentTarget.name)
				{
					case "left": 
						curSelected--;
						break;
					case "right": 
						curSelected++;
						break;
				}
			}
			curSelected %= 8;
			clickBtn(curSelected);
		}
		
		private var showTimeOut:uint;
		private var btnIsShow:Boolean = false;
		
		private function show_btns():void
		{
			btnIsShow = true;
			resetTimer();
			TweenLite.to(btnContainer, .5, {y: -bottom1.height * .9});
		}
		
		private function show_hide(e:MouseEvent):void
		{
			if (btnIsShow)
			{
				hide_btns();
			}
			else
			{
				show_btns();
			}
		}
		
		private function resetTimer():void
		{
			if (btnIsShow)
			{
				clearTimeout(showTimeOut);
				showTimeOut = setTimeout(hide_btns, 6000);
			}
		}
		
		private function hide_btns():void
		{
			btnIsShow = false;
			clearTimeout(showTimeOut);
			TweenLite.to(btnContainer, .5, {y: btnContainer.height * 1.2 - bottom1.height * .9});
			stage.addEventListener(MouseEvent.MOUSE_DOWN, contrlBtns);
		}
		
		private var _mouseY:int = 0;
		
		private function contrlBtns(e:MouseEvent):void
		{
			if (stage == null)
				return;
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN: 
					logs.adds("MOUSE_DOWN:", stage.mouseY);
					resetTimer();
					if (mouseY > data.stageH * .9 && !btnIsShow)
					{
						stage.addEventListener(MouseEvent.MOUSE_MOVE, contrlBtns);
						//stage.addEventListener(MouseEvent.MOUSE_OUT, contrlBtns);
						stage.addEventListener(MouseEvent.MOUSE_UP, contrlBtns);
						_mouseY = stage.mouseY;
					}
					break;
				case MouseEvent.MOUSE_MOVE: 
					if (stage.mouseY < data.stageH * .75 && !btnIsShow)
					{
						logs.adds("MOUSE_MOVE:", stage.mouseY);
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, contrlBtns);
						show_btns();
					}
					break;
				case MouseEvent.MOUSE_UP: 
				case MouseEvent.MOUSE_OUT: 
					logs.adds("MOUSE_UP:");
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, contrlBtns);
					stage.removeEventListener(MouseEvent.MOUSE_UP, contrlBtns);
					stage.removeEventListener(MouseEvent.MOUSE_OUT, contrlBtns);
					break;
			}
		}
		
		private var curIndex:int = 0;
		
		private function scaley(i:int):int
		{
			return i;
		}
		
		private function scalex(i:int):int
		{
			return i;
		}
		
		private function clicked(e:Event = null):void
		{
			if (e)
				clickBtn(int(e.currentTarget.name.substr(1)));
			else
				clickBtn(1);
		}
		
		public function clickBtn(to:int):void
		{
			var prevBtn:Sprite = btnContainer.getChildByName("b" + curIndex) as Sprite;
			if (prevBtn)
			{
				prevBtn.y = data.stageH * yrate_unchoosen;
				prevBtn.getChildAt(1).visible = false;
			}
			else
			{
				addbtns();
			}
			
			curIndex = to;
			
			var curBtn:Sprite = btnContainer.getChildByName("b" + curIndex) as Sprite;
			if (curBtn)
			{
				curBtn.getChildAt(1).visible = true;
				curBtn.y = data.stageH * yrate_choosen;
			}
			
			hide_btns();
			I1.show(false);
			I2.show(false);
			I3.show(false);
			I4.show(false);
			I5.show(false);
			I6.show(false);
			I7.show(false);
			I8.show(false);
			switch (curIndex)
			{
				case 1: 
					I1.show();
					break;
				case 2: 
					I2.show();
					break;
				case 3: 
					I3.show();
					break;
				case 4: 
					I4.show();
					break;
				case 5: 
					I5.show();
					break;
				case 6: 
					I6.show();
					break;
				case 7: 
					I7.show();
					break;
				case 8: 
					I8.show();
					break;
			}
			//changeBg(curIndex);
		}
		
		public static function get stage():Stage
		{
			return main.stage;
		}
	
	}
}

