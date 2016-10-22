package framework.controller
{
	public class CommandStartup
	{
		public function CommandStartup()
		{
		}
		
		public static function execute():void
		{
			CommandModelPrep.execute();
			CommandViewPrep.execute();
			CommandRemotePrep.execute();
		}
	}
}