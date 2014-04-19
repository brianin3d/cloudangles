import haxe.unit.TestRunner;

class Test extends TestRunner {

	function new() {
		super();

		// you have to add this manually... :-(
		add( new tests.AppTest() );

		// finally, run the tests
		run();
	}

	static function main() {
		new Test();
	}
}
