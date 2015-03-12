package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	//import shine.loaders.ItemsLoader;
	//import shine.loaders.PicturesLoader;
	//import shine.tool.BitmapUtils;
	/**
	 * 序列帧播放器
	 * @author
	 */
	public class SequencePlayer extends Sprite
	{
		//private var _images:Array = new Array();
		private var _index:int = 0;
		//private var _progress:Sprite = new Sprite();
		//private var icon:Bitmap;
		
		private var _isCyclicRotation:Boolean;
		private var _rotationDirec:int;
		private var _autoPlay:Boolean = false;
		private var _stoped:Boolean = true;
		
		private const _fps:uint = 60;
		
		//自动播放
		//private var _timer:Timer = new Timer(500);
		//private var _autoPlay:Boolean = true;
		
		private var pic_path_arr:Array;
		
		/**
		 *
		 * @param	path  目录名
		 * @param	isCyclicRotation 是否循环转动
		 * @param	rotationDirec  旋转方向 1=正 0=反
		 */
		public function SequencePlayer(path:Array, autoPlay:Boolean = false, isCyclicRotation:Boolean = true, rotationDirec:int = 1)
		{
			if (path as Array)
			{
				pic_path_arr = path as Array;
			}
			else
			{
				//pic_path_arr = SwfLoader.filesInDir(path,SwfLoader.imgReg);
			}
			_isCyclicRotation = isCyclicRotation;
			_rotationDirec = rotationDirec;
			_autoPlay = autoPlay;
			_stoped = !_autoPlay;
			addEventListener(Event.REMOVED_FROM_STAGE, removeStage);
			start_play();
		}
		
		public function start_play():void
		{
			_stoped = false;
			clearTimeout(timeoutId);
			clearTimeout(nextFrameTimeoutId);
			if (pic_path_arr)
				play(0);
		}
		
		public function stop_play():void
		{
			_stoped = true;
			clearTimeout(timeoutId);
			clearTimeout(nextFrameTimeoutId);
		}
		
		private static var ww:int = 1024;
		private static var hh:int = 768;
		
		public function setSize(w:int, h:int):void
		{
			ww = w;
			hh = h;
		}
		
		private function removeStage(e:Event):void
		{
			stop_play();
			//removeEventListener(Event.REMOVED_FROM_STAGE, removeStage);
			//upHandler(null);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		public function get index():int
		{
			return _index;
		}
		
		private function init():void
		{
			//进度条
			//_progress.graphics.beginFill(0xf3d7a6);
			//_progress.graphics.drawRect(0, 0, stage.stageWidth, 6);
			//_progress.graphics.endFill();
			//_progress.y = stage.stageHeight - _progress.height;
			//addChild(_progress);
			//加载所有图片
			play(0);
		/*
		   try{
		   //加载列表
		   //arrloader = new ArrLoader(pic_path_arr,all_loaded,one_loaded);
		   }catch(er:Error){
		   trace("file_arr:",er);
		   }
		 */
		}
		
		/*
		   //private var arrloader:ArrLoader;
		   private function all_loaded(e:Event=null):void {
		   }
		   private function one_loaded(e:Event=null):void {
		   if (arrloader.bmpArr.length == 1)
		   {
		   play(0);
		   addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		   }
		   }
		 */
		
		/*
		   private function loaded(e:Event):void
		   {
		   if (!stage) return;
		   _images = ItemsLoader(e.target).items;
		
		   if (e.type == ItemsLoader.COMPLETE) {
		   //显示操作提示
		   [Embed(source = "dc/assets/180.png")] var sou:Class;
		   icon = new sou;
		   icon.x = (stage.stageWidth/2 - icon.width) / 2;
		   icon.y = stage.stageHeight/2 - icon.height - 30;
		   addChild(icon);
		   //加载完成
		   //if (_progress.parent) removeChild(_progress);
		   //addChild(_images[_index]);
		
		   }else if (e.type == ItemsLoader.COMPLETE_ONE) {
		   //[Embed(source = "../../lib/content/bg.png")]
		   //var bcc:Class;
		   //var bg:Bitmap = new bcc;
		
		   var ary:Array = ItemsLoader(e.target).items;
		   //var bp:Bitmap = Bitmap(ary[ary.length - 1]);
		
		   //bg.bitmapData.copyPixels(	bp.bitmapData, new Rectangle(0, 0, bp.bitmapData.width, bp.bitmapData.height), new Point(0, 0), null, null, true);
		   //_images.push(bg);
		   //显示一张
		   if (_images.length == 1)
		   {
		   play(0);
		   addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		   //_timer.addEventListener(TimerEvent.TIMER, function():void
		   //{
		   //if (_autoPlay) play(1);
		   //});
		   //_timer.start();
		   }
		   //加载进度
		   //addChild(_progress);
		   //_progress.graphics.clear();
		   //_progress.graphics.beginFill(0xf3d7a6);
		   //var l:Number = stage.stageWidth * (1 - _images.length / pic_path_arr.length);
		   //trace(_images.length,pic_path_arr.length,l);
		   //_progress.graphics.drawRect(stage.stageWidth - l, 0, l, 6);
		   //_progress.graphics.endFill();
		   }
		   }
		 */
		
//**************** 交互操作 ******************
		private var _downPoint:Point;
		private const _step:int = 8;
		private var tmpIndex:int = 0;
		
		private function downHandler(e:MouseEvent):void
		{
			//autoDelay();
			_downPoint = new Point(mouseX, mouseY);
			addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		private function upHandler(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		private function moveHandler(e:MouseEvent):void
		{
			//autoDelay();
			var i:int = tmpIndex;
			tmpIndex = Math.round((mouseX - _downPoint.x) / _step);
			if (_rotationDirec == 1)
			{
				if (tmpIndex != i)
					play((tmpIndex > i) ? -2 : 2);
			}
			else
			{
				if (tmpIndex != i)
					play((tmpIndex > i) ? 2 : -2);
			}
		}
		
		public function play(i:int):void
		{
			clearTimeout(timeoutId);
			clearTimeout(nextFrameTimeoutId);
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_index += i;
			var _images:Array = pic_path_arr;
			
			if (_isCyclicRotation)
			{
				while (_index < 0)
					_index += _images.length;
				while (_index > _images.length - 1)
					_index -= _images.length;
			}
			else
			{
				if (_index < 0)
					_index = 0;
				if (_index > _images.length - 1)
					_index = _images.length - 1;
			}
			//removeChildren();
			dispatchEvent(new Event(Event.CHANGE));
			var url:String = pic_path_arr[_index];
			//trace("3:",i,index,url);
			//trace(url);
			if (url)
			{
				SwfLoader.SwfLoad(String(pic_path_arr[_index]), addbmp);
			}
			else
			{
				trace("no pic url");
			}
		}
		private var lastdate:Date = new Date;
		private var timeoutId:uint;
		private var nextFrameTimeoutId:uint;
		
		private function addbmp(e:Event):void
		{
			if (e && e.type == Event.COMPLETE)
			{
				var bmp:Bitmap = e.target.content as Bitmap;
			}
			else
			{
				trace(e);
			}
			var wait_time:int = 1000 / _fps - (Number(new Date) - Number(lastdate));
			if (wait_time <= 0)
			{
				show_pic(bmp);
			}
			else
			{
				clearTimeout(timeoutId);
				timeoutId = setTimeout(show_pic, wait_time, bmp);
			}
		}
		
		private function show_pic(bmp:Bitmap):void
		{
			clearTimeout(timeoutId);
			clearTimeout(nextFrameTimeoutId);
			if (bmp)
			{
				ViewSet.removes(this);
				bmp.width = ww;
				bmp.height = hh;
				bmp.smoothing = true;
				addChild(bmp);
				if (!_autoPlay)
					addChild(icon);
			}
			else
			{
				trace("no photo");
			}
			lastdate = new Date();
			
			if (_autoPlay && _index + 1 < pic_path_arr.length && !_stoped)
			{
				clearTimeout(nextFrameTimeoutId);
				nextFrameTimeoutId = setTimeout(play, 1000 / _fps, 1);
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private static var _icon:Bitmap = null;
		
		private static function get icon():Bitmap
		{
			_icon = null;
			if (_icon == null)
			{
				//[Embed(source = "dc/assets/180.png")] 
				[Embed(source="dc/cut/360.png")]
				var soupng:Class;
				_icon = new soupng;
				_icon.x = (ww - _icon.width) / 2;
				_icon.y = hh * .8 - (_icon.height) / 2;
			}
			return _icon;
		}
		private var playBtn:Sprite;
		private var pauseBtn:Sprite;
		private var backwardBtn:Sprite;
		private var forwardBtn:Sprite;
		public function initBtns(_playBtn:Sprite=null,_pauseBbtn:Sprite=null,_backwardBtn:Sprite=null,_forwardBtn:Sprite=null):void
		{
			if (_playBtn) {
				playBtn = _playBtn;
				addChild(playBtn);
				playBtn.addEventListener(MouseEvent.CLICK,plays);
			}
			if (_pauseBbtn) {
				pauseBtn = _pauseBbtn;
				addChild(pauseBtn);
				pauseBtn.addEventListener(MouseEvent.CLICK,pause);
			}
			if (_backwardBtn)
			{
				backwardBtn = _backwardBtn;
				addChild(backwardBtn);
				backwardBtn.addEventListener(MouseEvent.CLICK,backwark);
			}
			if (_forwardBtn) {
				forwardBtn = _forwardBtn;
				addChild(forwardBtn);
				forwardBtn.addEventListener(MouseEvent.CLICK,forward);
			}
		}
		public function plays(e:Event = null):void
		{
			if (_stoped)
			{
				_stoped = false;
			}
			if (playBtn) playBtn.visible = false;
			if (pauseBtn) pauseBtn.visible = true;
			clearTimeout(nextFrameTimeoutId);
			if (_index + 1 < pic_path_arr.length)
				nextFrameTimeoutId = setTimeout(play, 1000 / _fps, 1);
		}
		
		public function pause(e:Event = null):void
		{
			if (_stoped)
			{
				return;
			}
			_stoped = true;
			if (playBtn) playBtn.visible = true;
			if (pauseBtn) pauseBtn.visible = false;
			clearTimeout(nextFrameTimeoutId);
		}
		
		public function forward(e:Event = null):void
		{
			if (_index + _step < pic_path_arr.length)
			{
				play(_step);
			}
		}
		
		public function backwark(e:Event = null):void
		{
			if (_index - _step > 0)
			{
				play(-_step);
			}
		}
	
//private var EE:int;
//private function autoDelay():void
//{
//_autoPlay = false;
//clearTimeout(EE);
//EE = setTimeout(function():void
//{
//_autoPlay = true;
//},1000 * 5);
//}
	
	}

}
