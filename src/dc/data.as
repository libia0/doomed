/**
 */
package dc{
	public class data{
		public static const m1:String = "项目影片/";
		public static const m2:String = "区域沙盘/";
		public static const m3:String = "项目沙盘/";
		public static const m31:String = "分层业态/";
		public static const m4:String = "建筑单体/";
		public static const m5:String = "商铺户型/";
		public static const m6:String = "街区漫游/";
		public static const m7:String = "中心广场/";
		public static const m8:String = "品牌楼书/";



		public static var stageW:int=1024;
		public static var stageH:int=768;

		public static const realW:int=1024;
		public static const realH:int=768;

		public static const asset_root:String = SwfLoader.rootPath +"resource/";
		//2048*1536
		public static function scalex(i:int):int {
			return i*stageW/realW;
		}
		public static function scaley(i:int):int {
			return i*stageH/realH;
		}
	}
}

