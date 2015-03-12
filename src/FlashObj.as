package 
{
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class FlashObj extends BaseSprite
	{
		private var flashBg:Bitmap;
		private var timeoutId:uint;
		private var dimrate:Number=.05;
		private var _isFlashing:Boolean = false;
		public function get flashing():Boolean
		{
			return _isFlashing;
		}

		public function FlashObj(ww:int,hh:int)
		{
			flashBg= new Bitmap(new BitmapData(ww,hh,false,0xff0000));
			addChild(flashBg);
			stopFlash();
		}

		public function set flashing(b:Boolean):void
		{
			dimrate = Math.abs(dimrate);
			_isFlashing = b;
			if(b){
				startFlash();
			}else{
				stopFlash();
			}
		}

		private function startFlash():void
		{
			/*trace(flashing);*/
			parent.addChild(this);
			clearTimeout(timeoutId);
			flashBg.alpha += dimrate;
			if(flashBg.alpha >.4)dimrate = -Math.abs(dimrate);
			else if(flashBg.alpha <.01)dimrate = Math.abs(dimrate);
			timeoutId = setTimeout(startFlash,50);
		}

		private function stopFlash(e:Event=null):void
		{
			/*trace(flashing);*/
			clearTimeout(timeoutId);
			flashBg.alpha = .0;
		}
	}
}

