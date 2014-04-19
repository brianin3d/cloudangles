package us.versus.them.cloudangles;

import opengl.GL;
import opengl.GLU;
import opengl.GLFW;

class Helper {
	public static function wireCube( dSize:Float) {
		cube( dSize, GL.LINE_LOOP );
	}

	public static function solidCube( dSize:Float ) {
		cube( dSize, GL.QUADS );
	}

	public static function cube( dSize:Float, tipo ) {
		var s = dSize*.5;
		GL.begin( tipo );
			GL.vertex3( s,-s, s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s, s, s);
		GL.end();
		GL.begin( tipo );
			GL.vertex3( s, s, s);
			GL.vertex3( s, s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s, s, s);
		GL.end();
		GL.begin( tipo );
			GL.vertex3( s, s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s,-s, s);
			GL.vertex3( s,-s, s);
		GL.end();
		GL.begin( tipo );
			GL.vertex3(-s,-s, s);
			GL.vertex3(-s, s, s);
			GL.vertex3(-s, s,-s);
			GL.vertex3(-s,-s,-s);
		GL.end();
		GL.begin( tipo );
			GL.vertex3(-s,-s, s);
			GL.vertex3(-s,-s,-s);
			GL.vertex3( s,-s,-s);
			GL.vertex3( s,-s, s);
		GL.end();
		GL.begin( tipo );
			GL.vertex3(-s,-s,-s);
			GL.vertex3(-s, s,-s);
			GL.vertex3( s, s,-s);
			GL.vertex3( s,-s,-s);
		GL.end();
	}

	public static function init( w=320, h=240, duhCallback:Dynamic = null ) {
		GLFW.openWindow( w, h, 8,8,8, 8,8,0, GLFW.WINDOW );
		
		GLFW.setWindowSizeFunction( function( w:Int, h:Int ) {
			if ( duhCallback ) duhCallback( "resize", w, h );
		});
		GLFW.setWindowCloseFunction( function() {
			if ( duhCallback ) duhCallback( "close" );
			return 1;
		});
		GLFW.setWindowRefreshFunction( function() {
			if ( duhCallback ) duhCallback( "refresh" );
		});
		GLFW.setKeyFunction( function( a:Int, b:Int ) {
			if ( duhCallback ) duhCallback( "key", a, b );
		});
		GLFW.setCharFunction( function( a:Int, b:Int ) {
			if ( duhCallback ) duhCallback( "char", a, b );
		});
		GLFW.setMouseButtonFunction( function( a:Int, b:Int ) {
			if ( duhCallback ) duhCallback( "mouseButton", a, b );
		});
		GLFW.setMousePosFunction( function( a:Int, b:Int ) {
			if ( duhCallback ) duhCallback( "mousePosition", a, b );
		});
		GLFW.setMouseWheelFunction( function( a:Int ) {
			if ( duhCallback ) duhCallback( "mouseWheel", a );
		});

		GL.clearColor( 0, 0, 0, 0 );
		GL.shadeModel( GL.FLAT );
		
		GL.matrixMode( GL.PROJECTION );
		GL.loadIdentity();
		GL.frustum( -1., 1., -1., 1., 1.5, 20. );
		GL.matrixMode( GL.MODELVIEW );
		
		GL.enable( GL.DEPTH_TEST );
	}
}
