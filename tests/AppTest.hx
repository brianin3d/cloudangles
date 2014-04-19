package tests;

import us.versus.them.cloudangles.App;

class AppTest extends haxe.unit.TestCase {
	public function testBasic () {
		var app = new App();
		assertEquals( app, app );
	}
}
