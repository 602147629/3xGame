package framework.controller
{
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewLoadingUI;
	import framework.fibre.core.Fibre;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.mediator.MediatorLoadingUi;

	/** 
	 * @author melody
	 */	
	public class CommandLoadingUi
	{
		public function CommandLoadingUi()
		{
		}
		public static function openLoadingUI(loadNum:int ,text:String = null):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramViewLoadingUI(ConstantUI.LOADING_UI,loadNum));
		}
		public static function setLoadingProcess(completeNum:int = 1,text:String = null):void
		{
			var obj:Object = new Object();
			obj.completeNum = completeNum;
			obj.txt = text;
			Fibre.getInstance().sendNotification(MediatorLoadingUi.SET_LOADING_PERCENT,obj);
		}
		public static function closeLoadingUI():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL, new DatagramView(ConstantUI.LOADING_UI));
		}
	}
}