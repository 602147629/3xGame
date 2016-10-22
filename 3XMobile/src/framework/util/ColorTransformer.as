package framework.util
{
	/** 
	 * @author melody
	 */	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class ColorTransformer {
		
		public function ColorTransformer() {
		}
		
		public static function setGrayTransform(target:DisplayObject):void {
			target.filters=[
				new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1])
			];
		}
		
		public static function setDarkGrayTransform(target:DisplayObject):void{
			target.filters=[
				new ColorMatrixFilter([
					0.3086,0.3094,0.082,0,0,
					0.3086,0.3094,0.082,0,0,
					0.3086,0.3094,0.082,0,0,
					0,0,0,1,0,
					0,0,0,0,1
				])
			];
			
		}

		public static function clearTransform(target:DisplayObject):void {
			target.filters=[];
		}
		
		//add sketch transform

	}
}