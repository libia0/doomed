/**
 * @file ScoreEffect.as

 ScoreEffect.plays("+1111",this);


 * @author db0@qq.com
 * @version 1.0.1
 * @date 2014-08-06
 */
package
{
	import com.greensock.TweenLite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	public class ScoreEffect extends Sprite 
	{
		public function ScoreEffect() {
			_main = this;
		}

		private static var scoreTxt:ScoreTxt;
		private static var timeoutId:uint;
		private static var bg:Bitmap;

		private static var _main:ScoreEffect=null;
		private static function get main():ScoreEffect {
			if(_main == null)
				new ScoreEffect();
			return _main;
		}


		public static function plays(s:String,curObj:DisplayObject=null):void
		{
			if(_main==null)new ScoreEffect();
			if(curObj as DisplayObject ==null || curObj.parent == null)return;
			curObj.parent.addChild(main);
			trace(s,curObj,curObj.width,curObj.height);
			clearTimeout(timeoutId);
			main.visible = true;
			if(scoreTxt ==null)scoreTxt = new ScoreTxt();
			scoreTxt.text = s;

			if(bg==null) bg = new Bitmap(new BitmapData(100,100));
			if(curObj && curObj.width >0 && curObj.height >0){
				bg.width = curObj.width;
				bg.height= curObj.height;
				bg.x = curObj.x;
				bg.y = curObj.y;
			}

			main.addChild(bg).alpha=0;
			main.addChild(scoreTxt);

			scoreTxt.scaleX = scoreTxt.scaleY = 1;
			scoreTxt.x= curObj.x ;
			scoreTxt.y= curObj.y - curObj.height/2;
			var toscaleX:Number = bg.width/scoreTxt.width;

			TweenLite.to(scoreTxt,
					.8,
					{y:bg.y-toscaleX*scoreTxt.height-bg.height,
scaleX:toscaleX,
scaleY:toscaleX,
onComplete:disapear});
		}

		private static function disapear():void
		{
			clearTimeout(timeoutId);
			timeoutId = setTimeout(notxt,1000);
		}

		private static function notxt():void
		{
			clearTimeout(timeoutId);
			main.visible = false;
			ViewSet.removeObj(main);
		}
	}
}

import flash.text.TextField;
class ScoreTxt extends BaseSprite
{
	private var txts:TextField = new TextField();
	public function ScoreTxt(s:String="")
	{
		/*addChild(new Bitmap(new BitmapData(100,100,false,0)));*/
		text = s;
		txts.textColor=0xffff00;
		addChild(txts);
	}

	public function set text(s:String):void
	{
		txts.autoSize = "left";
		txts.text = String(s);
		txts.x = -txts.width/2;
		txts.y = -txts.height/2;
	}
}

