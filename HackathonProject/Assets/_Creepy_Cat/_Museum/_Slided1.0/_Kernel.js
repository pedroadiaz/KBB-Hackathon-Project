static class Engine { 

	//------------------------------------------------------------------------
	// Interpolate a value to another with smooth (smooth must ba < 1)
	// ------------------------------------------------------------------------
	function InterpolateValue(ValueA:float, ValueB:float, Smooth:float, Velocity:float) {
		return  Mathf.SmoothDamp(ValueA,ValueB,Velocity,Smooth);		
	}

	//---------------------
	// Interpolate angle
	// --------------------
	function InterpolateAngle(ValueA:float, ValueB:float, Smooth:float) {
		var ix:float=Mathf.Sin(ValueA);
		var iy:float=Mathf.Cos(ValueA);		
		var jx:float=Mathf.Sin(ValueB);
		var jy:float=Mathf.Cos(ValueB);
		
		return Mathf.Atan2(ix-(ix-jx)*Smooth,iy-(iy-jy)*Smooth);
	}	
	
	
}