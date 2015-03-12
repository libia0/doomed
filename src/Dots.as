package  {
	import flash.display.Shape;
	import flash.display.Sprite;
	public class Dots extends Sprite
	{
		private static var _main:Dots;
		private static function get main():Dots
		{
			if(_main==null)_main = new Dots;
			return _main;
		}
		public function Dots():void
		{
			_main = this;
		}
		public static function show(cur:int,total:int):void
		{
			main.visible = true;
			main.show(cur,total);
		}
		public static function hide():void
		{
			main.visible = false;
		}

		private function get c_rad():int
		{
			return data.scalex(10);
		}
		private function get c_dot():Shape
		{
			var shape:Shape = new Shape();
			with(shape){
				graphics.lineStyle(1,0xffffff);
				graphics.drawRect(0,0,c_rad,c_rad);
			}
			return shape;
		}
		private function get d_dot():Shape
		{
			var shape:Shape = new Shape();
			with(shape){
				graphics.beginFill(0xffffff);
				graphics.drawRect(0,0, c_rad,c_rad);
				graphics.endFill();
			}
			return shape;
		}

		private function show(cur:int,total:int):void
		{
			logs.adds("show Dots:",cur,total,".............................................");
			ViewSet.removes(main);
			var gap:int = data.scalex(20);
			var i:int = 0;
			while(i<total)
			{
				var dot:Shape = c_dot;
				dot.x = i * gap;
				main.addChild(dot);
				++i;
			}
			var dot2:Shape = d_dot;
			dot2.x = cur * gap;
			main.addChild(dot2);
			x = data.scalex(1251)-width/2;
			y = data.scaley(1017)-height/2;
			smain.main.stage.addChild(main);
		}
		
	}
}
