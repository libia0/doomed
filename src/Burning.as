package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	[SWF(width=250, height=450, backgroundColor=0x000000)]

	/**
	* Demonstrates how flames may be dynamically generated from any object. This uses a loaded image
	* that is then recolored and distorted, constantly over time, creating the flame illusion.
	*/
	public class Burning extends Sprite {

		// the rate at which the flames should move
		private static const FLICKER_RATE:Number = 10;

		private var _flame:BitmapData;
		private var _perlinNoise:BitmapData;
		private var _perlinOffsets:Array;
		private var _perlinSeed:int;
		
		private var bmp:Bitmap;
		private var srcbmp:Bitmap;

		/**
		* Constructor. Sends path of image to load to super class.
		*/
		public function Burning() {
			//super("man.png");
			addEventListener(Event.REMOVED_FROM_STAGE, clears);
		}
		
		private function clears(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, clears);
			removeEventListener(Event.ENTER_FRAME, drawFlame);
			if(srcbmp)
			if(srcbmp.parent)
			srcbmp.parent.removeChild(srcbmp);
			srcbmp = null
		}

		/**
		* Called after image loads in super class. This places loaded image, recolors it using
		* a GradientGlowFilter, then sets up the flame and noise properties that will be used in
		* the flame animation. Finally, the handler for the animation is set up.
		*/
		public function runPostImageLoad(_loadedBitmap:Bitmap):void {
			srcbmp = _loadedBitmap;
			//_loadedBitmap.x = (stage.stageWidth - _loadedBitmap.width)/2;
			//_loadedBitmap.y = stage.stageHeight - _loadedBitmap.height - 5;
			// creates flame colors on image using a filter
			_loadedBitmap.filters = [
				new GradientGlowFilter(
					0,
					45,
					[0xFF0000, 0xFFFF00],
					[1, 1],
					[50, 255],
					15,
					15
				)
			];
			// initializes properties that will be used in the animating
			makeFlame(_loadedBitmap);
			makeNoise();
			addChild(_loadedBitmap);
			addEventListener(Event.ENTER_FRAME, drawFlame);
		}

		/**
		* Creates the bitmap data that will be used to draw the flames.
		*/
		private function makeFlame(_loadedBitmap:Bitmap):void {
			// flame image is same size as stage, fully transparent
			_flame = new BitmapData(
				_loadedBitmap.width,
				_loadedBitmap.height*2,
				true,
				0x00000000
			);
			bmp = new Bitmap(_flame);
			bmp.x = _loadedBitmap.x;
			bmp.y = _loadedBitmap.y;
			addChild(bmp);
		}

		/**
		* Initializes Perlin noise properties that will be used in flame animation.
		*/
		private function makeNoise():void {
			// noise bitmap data is same size as flame bitmap data
			_perlinNoise = _flame.clone();
			_perlinSeed = int(new Date());
			// only one octave requires only one point
			_perlinOffsets = [new Point()];
		}

		/**
		* Applies the Perlin noise to the bitmap data, offsetting the octave displacement
		* by the FLICKER_RATE each time this method is called.
		*/
		private function applyNoise():void {
			_perlinNoise.perlinNoise(
				20,
				20,
				1,
				_perlinSeed,
				false,
				true,
				BitmapDataChannel.RED,
				true,
				_perlinOffsets
			);
			// altering offset contributes to upward animation of flames
			(_perlinOffsets[0] as Point).y += FLICKER_RATE;
		}

		/**
		* Updates the flame bitmap data each frame, creating the animation.
		*/
		private function drawFlame(event:Event):void {
			// draw the current stage image into flame at a reduced brightness and alpha
			_flame.draw(
				srcbmp,
				null,
				new ColorTransform(.9, .9, .9, .7)
			);
			// move the flame image up slightly, creating upward movement of flames
			_flame.scroll(0, -4);
			// apply new Perlin noise with altered offset
			applyNoise();
			// displacement flame image with updates Perlin noise
			// blur drawn image slightly, more on y axis
			bmp.filters = [new BlurFilter(5, 50),new DisplacementMapFilter(
					_perlinNoise,
					new Point(),
					BitmapDataChannel.RED,
					BitmapDataChannel.RED,
					12,
					50,
					DisplacementMapFilterMode.CLAMP
				)];
		}

	}

}
