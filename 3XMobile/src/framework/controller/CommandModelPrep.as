package framework.controller
{
	import framework.fibre.core.Fibre;
	import framework.model.BackgroundLoadProxy;
	import framework.model.DialogManagerProxy;
	import framework.model.FileProxy;
	import framework.model.LoadStrategyProxy;
	import framework.model.RpcProxy;
	import framework.model.StaticResProxy;
	import framework.model.SwapLogicProxy;
	import framework.model.UserInfoProxy;
	import framework.tutorial.TutorialManagerProxy;
	
	public class CommandModelPrep// extends Command
	{
		public function CommandModelPrep()
		{
		}
		
		public static function execute():void
		{			
			Fibre.getInstance().registerProxy( new DialogManagerProxy() );
			Fibre.getInstance().registerProxy( new FileProxy() );
			Fibre.getInstance().registerProxy( new StaticResProxy() );
			Fibre.getInstance().registerProxy( new BackgroundLoadProxy() );
			Fibre.getInstance().registerProxy(new LoadStrategyProxy());
			Fibre.getInstance().registerProxy(new RpcProxy());
			Fibre.getInstance().registerProxy(new UserInfoProxy());
			Fibre.getInstance().registerProxy(new SwapLogicProxy());
			Fibre.getInstance().registerProxy(new TutorialManagerProxy());
			Fibre.getInstance().registerProxy(new MessageQueue());

		}

	}
}