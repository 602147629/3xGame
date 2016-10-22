package framework.ui
{
	

	public class AnimationManager
	{
		public var animationMoveItems:Vector.<AnimationMoveItem>;
		public var animationPlayItems:Array;
		
		public function AnimationManager()
		{
			animationMoveItems = new Vector.<AnimationMoveItem>();
			animationPlayItems = new Array();
		}
		
		
		
		public function tick():void
		{
			if(animationMoveItems.length == 0)
			{
				//noticeExecuteLogic
				
			}
		}
	}
}