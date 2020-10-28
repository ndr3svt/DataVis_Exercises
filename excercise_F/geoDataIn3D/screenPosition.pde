// void screenPosition(x, y, z) {

// 			PVector v = new PVector(x, y, z);
// 			// this v2 is to use the diametrically opposed value to see if point is behind or on front the spherical projection
// 			PVector v2 = new PVector(-x,-y,-z);
// 			// Calculate the ModelViewProjection Matrix.
// 			let mvp = (p._renderer.uMVMatrix.copy()).mult(p._renderer.uPMatrix);

// 			// Transform the vector to Normalized Device Coordinate.
// 			let vNDC = multMatrixVector(mvp, v);
// 			let vNDC2 = multMatrixVector(mvp,v2);

// 			// Transform vector from NDC to Canvas coordinates.
// 			let vCanvas = p.createVector();
// 			vCanvas.x = 0.5 * vNDC.x * p.width;
// 			vCanvas.y = 0.5 * -vNDC.y * p.height;
// 			// in case you prefer to ignore z set it to 0
// 			// vCanvas.z = 0;


// 			// to know if z in front or behind the earth / spherical projection
// 			if(vNDC2.z>vNDC.z){
// 				vCanvas.z = 1
// 			}else{
// 				vCanvas.z = -1
// 			}
// 			vCanvas.z = vNDC2.z-vNDC.z

// 			return vCanvas;
// 		}

// }

// void multMatrixVector(m, v) {
// 		// if (!(m instanceof p5.Matrix) || !(v instanceof p5.Vector)) {
// 		// 	print('multMatrixVector : Invalid arguments');
// 		// 	return;
// 		// }

// 		PVector _dest = new PVector();
// 		var mat = m.mat4;

// 		// Multiply in column major order.
// 		_dest.x = mat[0] * v.x + mat[4] * v.y + mat[8] * v.z + mat[12];
// 		_dest.y = mat[1] * v.x + mat[5] * v.y + mat[9] * v.z + mat[13];
// 		_dest.z = mat[2] * v.x + mat[6] * v.y + mat[10] * v.z + mat[14];
// 		var w = mat[3] * v.x + mat[7] * v.y + mat[11] * v.z + mat[15];

// 		if (Math.abs(w) > Number.EPSILON) {
// 			_dest.mult(1.0 / w);
// 		}

// 		return _dest;
// 	}