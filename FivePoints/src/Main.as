package
{
	import org.flixel.*;
	import state.GameStartState;
	[SWF(width="320", height="320", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(320, 320, GameStartState, 1, 20, 20);
		}
	}
}
