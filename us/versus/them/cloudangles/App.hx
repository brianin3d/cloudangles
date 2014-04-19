/*  Copyright (c) the Xinf contributors.  see http://xinf.org/copyright for license. */

package us.versus.them.cloudangles;

import opengl.GL;
import opengl.GLU;
import opengl.GLFW;

class App {
	public function display( i, cell, div ) {
		GL.clear( GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
		GL.loadIdentity();
		
		GLU.lookAt(
			0.0, 0.0, 5.0,
			0.0, 0.0, 0.0,
			0.0, 1.0, 0.0
		);
		GL.scale( 1.0, 1.0, 1.0 );
		GL.scale( 3.0, 3.0, 3.0 );
		
		var r = i*5;
		GL.rotate( r*.9124, 1., 0., 0. );
		GL.rotate( r*.6423, 0., 1., 0. );
		GL.rotate( r*.2352, 0., 0., 1. );

		var f = 1 / div;

		for( x in 0...div ) {
			var xv = x * f - 0.5;
			for( y in 0...div ) {
				var yv = y * f - 0.5;
				for( z in 0...div ) {
					var zv = z * f - 0.5;

					var v:Float = cell[ x ][ y ][ z ];
				   	//v = v * 0.6;// + 0.1;

					GL.pushMatrix();	
						GL.translate( xv, yv, zv );
						GL.color4( 1., 1., 1., v );
						GL.color4( v, v/2, 1-v, v );
						//GL.color3( v, 0, 1-v );

						Helper.solidCube( f * v * 2 );//* 2 );
					GL.popMatrix();
				}
			}
		}

		GL.color3( 1., 1., 1. );
		Helper.wireCube(2.0);

		GL.flush();
		GLFW.swapBuffers();
	}

	public function v( value:Float, scale:Float ) {
		var x:Float = value + Math.random() * scale * 2 - scale;// Math.random() * scale;
		if ( x < 0 ) x = 0;
		if ( x > 1 ) x = 1;
		return x;
	}

	public function cloud( x0:Int, y0:Int, z0:Int, x1:Int, y1:Int, z1:Int, cell, value:Float, scale:Float ) {
		var d = x1 - x0 + 1;
		if ( 2 > d ) return;

		var half = Std.int( d / 2 );
		var a = half - 1;
		var b = half;

		var xz = [ x0, x0 + a, x0 + b, x1 ];
		var yz = [ y0, y0 + a, y0 + b, y1 ];
		var zz = [ z0, z0 + a, z0 + b, z1 ];

		if ( a == 0 ) {
			xz = [ x0, x1 ];
			yz = [ y0, y1 ];
			zz = [ z0, z1 ];
		} 

		var count = 0;
		var sum = 0.0;

		for ( x in xz ) {
			for ( y in yz ) {
				for ( z in zz ) {
					sum += cell[ x ][ y ][ z ] = v( value, scale );
					count++;
				}
		   	}
		}

		if ( a == 0 ) {
			return;
		}

		var avg = sum / count;
		trace( 'count:' + count + ', sum:' + sum + ' avg:' + avg + ', d:' + d + ', half:' + half );
		
		var xa = x0 + a, xb = x0 + b;
		var ya = y0 + a, yb = y0 + b;
		var za = z0 + a, zb = z0 + b;

		var scaleDown = 0.5;

		cloud( x0,y0,z0, xa,ya,za, cell, avg, scale * scaleDown );
		cloud( xb,y0,z0, x1,ya,za, cell, avg, scale * scaleDown );
		cloud( x0,y0,zb, xa,ya,z1, cell, avg, scale * scaleDown );
		cloud( xb,y0,zb, x1,ya,z1, cell, avg, scale * scaleDown );

		cloud( x0,yb,z0, xa,y1,za, cell, avg, scale * scaleDown );
		cloud( xb,yb,z0, x1,y1,za, cell, avg, scale * scaleDown );
		cloud( x0,yb,zb, xa,y1,z1, cell, avg, scale * scaleDown );
		cloud( xb,yb,zb, x1,y1,z1, cell, avg, scale * scaleDown );

		cloud( x0,y0,z0, xa,ya,za, cell, avg, scale * scaleDown );
		cloud( xb,y0,z0, x1,ya,za, cell, avg, scale * scaleDown );
		cloud( x0,y0,zb, xa,ya,z1, cell, avg, scale * scaleDown );
		cloud( xb,y0,zb, x1,ya,z1, cell, avg, scale * scaleDown );

		cloud( x0,yb,z0, xa,y1,za, cell, avg, scale * scaleDown );
		cloud( xb,yb,z0, x1,y1,za, cell, avg, scale * scaleDown );
		cloud( x0,yb,zb, xa,y1,z1, cell, avg, scale * scaleDown );
		cloud( xb,yb,zb, x1,y1,z1, cell, avg, scale * scaleDown );

		return;
/*
		sum += cell[ x0 ][ y0 ][ z0 ] = v( value, scale );
		sum += cell[ x0 ][ y1 ][ z0 ] = v( value, scale );
		sum += cell[ x1 ][ y1 ][ z0 ] = v( value, scale );
		sum += cell[ x1 ][ y0 ][ z0 ] = v( value, scale );
		sum += cell[ x0 ][ y0 ][ z1 ] = v( value, scale );
		sum += cell[ x0 ][ y1 ][ z1 ] = v( value, scale );
		sum += cell[ x1 ][ y1 ][ z1 ] = v( value, scale );
		sum += cell[ x1 ][ y0 ][ z1 ] = v( value, scale );

		var avg = sum / 8;
		trace( 'avg:' + avg + ', sum:' + sum + ', scale:' + scale );

		// curse then curse again...

		var a = Std.int( d / 2 ) - 1;
		var b = Std.int( d / 2 ) + 1;

		var xa = x0 + a, xb = x0 + b;
		var ya = y0 + a, yb = y0 + b;
		var za = z0 + a, zb = z0 + b;

		var scaleDown = 0.8;

		cloud( x0,y0,z0, xa,ya,za, cell, avg, scale * scaleDown );
		cloud( xb,y0,z0, x1,ya,za, cell, avg, scale * scaleDown );
		cloud( x0,y0,zb, xa,ya,z1, cell, avg, scale * scaleDown );
		cloud( xb,y0,zb, x1,ya,z1, cell, avg, scale * scaleDown );

		cloud( x0,yb,z0, xa,y1,za, cell, avg, scale * scaleDown );
		cloud( xb,yb,z0, x1,y1,za, cell, avg, scale * scaleDown );
		cloud( x0,yb,zb, xa,y1,z1, cell, avg, scale * scaleDown );
		cloud( xb,yb,zb, x1,y1,z1, cell, avg, scale * scaleDown );

		cloud( x0,y0,z0, xa,ya,za, cell, avg, scale * scaleDown );
		cloud( xb,y0,z0, x1,ya,za, cell, avg, scale * scaleDown );
		cloud( x0,y0,zb, xa,ya,z1, cell, avg, scale * scaleDown );
		cloud( xb,y0,zb, x1,ya,z1, cell, avg, scale * scaleDown );

		cloud( x0,yb,z0, xa,y1,za, cell, avg, scale * scaleDown );
		cloud( xb,yb,z0, x1,y1,za, cell, avg, scale * scaleDown );
		cloud( x0,yb,zb, xa,y1,z1, cell, avg, scale * scaleDown );
		cloud( xb,yb,zb, x1,y1,z1, cell, avg, scale * scaleDown );
*/
	}

	public function new() {
		var done = false;

		var div = 16;

		var cell:Array< Array< Array< Float > > > = new Array();

		for ( i in 0...div ) {
			cell[ i ] = new Array();
			for ( j in 0...div ) {
				cell[ i ].push( new Array() );
				for ( k in 0...div ) {
					cell[ i ][ j ][ k ] = 0;
				}
			}
		}

		cloud( 0, 0, 0, 15, 15, 15 , cell, 0.5, 0.5 );

/*
		for( x in 0...div ) {
			for( y in 0...div ) {
				for( z in 0...div ) {
					trace( 'derp:' + cell[ x ][ y ][ z ] );
				}
			}
		}
*/

		var f = 2;
		Helper.init( 

			320 * f , 240 * f
			, function( type ) {
				if ( "close" == type ) {
					done = true;
				}
			}
		);

		GL.enable( GL.BLEND );
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);

		var i = 0;	
		while( !done ) {
			GLFW.pollEvents();
			this.display( i++, cell, div );
			neko.Sys.sleep(1./25);
		}
		GLFW.terminate();
	}
}
