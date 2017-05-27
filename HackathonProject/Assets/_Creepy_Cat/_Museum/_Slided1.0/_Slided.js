// Slided engine 1.0 par Creepy Cat (C)2015
// The code is for example only, you should 
// not resale it directly (or modified).

//L'interface
public  var slidepivot:GameObject;

public  var camspeed:float=14.5;
public  var pivotspeed:float=12.5;

public  var decalX:float=0.0;
public  var decalY:float=0.0;

// Index du waypoint courant
static  var currentWaypoint:int = 0; //First Slide index
static  var totalWaypoint:int = 0; //Total Slide number
static  var videoStop:int=0;
public  var waypoints:GameObject[];

// Positions du pivot
private  var currentPivotX:float;
private  var  currentPivotY:float;
private  var  currentPivotZ:float;

private  var  nextPivotX:float;
private  var  nextPivotY:float;
private  var  nextPivotZ:float;

// Positions des slides
private  var currentSlideX:float;
private  var  currentSlideY:float;
private  var  currentSlideZ:float;

private  var  nextslideX:float;
private  var  nextslideY:float;
private  var  nextslideZ:float;

// Variables de l'engine
private  var cameraSmooth:float;
private  var pivotSmooth:float;

private  var zoomIn:float=0.9;
private  var zoomOut:float=5;
private  var zoomSwitch:int=0;
private  var zoomValue:float=zoomIn;

static var videoDownloaded:int=0;

// Wake up neo
function Awake() {
	
	// If more than 0 waypoint
	if (waypoints.Length > 0) { 
		
		// getting first slide coordinates
		var posi:Vector3 =  waypoints[0].transform.TransformPoint (Vector3(decalX,decalY,zoomValue));
		
		nextslideX=posi.x;
		nextslideY=posi.y;
		nextslideZ=posi.z;
		
		
		currentSlideX=posi.x;
		currentSlideY=posi.y;
		currentSlideZ=posi.z;
		
		nextPivotX=nextslideX;
		nextPivotY=nextslideY;
		nextPivotZ=nextslideZ;
		
		currentPivotX=nextslideX;
		currentPivotY=nextslideY;
		currentPivotZ=nextslideZ;
		
		currentPivotX=waypoints[currentWaypoint].transform.position.x;
		currentPivotY=waypoints[currentWaypoint].transform.position.y;
		currentPivotZ=waypoints[currentWaypoint].transform.position.z;

	}

}

// ---------------
// Function update
// ---------------
function Update () {
	GetInputKey();
	FacingCamera();
}


//-----------------------------------------
// Deplacement de la camera avec pivot
// ----------------------------------------
function FacingCamera(){

	// Move camera and pivot
	cameraSmooth=Time.deltaTime * camspeed;
	pivotSmooth=Time.deltaTime * pivotspeed;
	
	// New pivot position searching
	if (zoomSwitch==0){
		nextPivotX=waypoints[currentWaypoint].transform.position.x;
		nextPivotY=waypoints[currentWaypoint].transform.position.y;
		nextPivotZ=waypoints[currentWaypoint].transform.position.z;
		
		var posi:Vector3 =  waypoints[currentWaypoint].transform.TransformPoint (Vector3(decalX,decalY,zoomValue));
		
		nextslideX=posi.x;
		nextslideY=posi.y;
		nextslideZ=posi.z;
	}
	else {
		nextPivotX=0;
		nextPivotY=2;
		nextPivotZ=0;	

		nextslideX=4.8;
		nextslideY=4.0;
		nextslideZ=4.9;
	}

	// Calculate the orientation and other shit : pivot+camera
	currentPivotX=Engine.InterpolateValue(currentPivotX, nextPivotX,pivotSmooth,0.0);
	currentPivotY=Engine.InterpolateValue(currentPivotY, nextPivotY,pivotSmooth,0.0);
	currentPivotZ=Engine.InterpolateValue(currentPivotZ, nextPivotZ,pivotSmooth,0.0);
	
	slidepivot.transform.position = Vector3(currentPivotX,currentPivotY, currentPivotZ);

	currentSlideX=Engine.InterpolateValue(currentSlideX, nextslideX,cameraSmooth,0.0);
	currentSlideY=Engine.InterpolateValue(currentSlideY, nextslideY,cameraSmooth,0.0);
	currentSlideZ=Engine.InterpolateValue(currentSlideZ, nextslideZ,cameraSmooth,0.0);

	GetComponent.<Camera>().transform.position = Vector3(currentSlideX, currentSlideY, currentSlideZ);
	
	// Pointing camera to pivot
	GetComponent.<Camera>().transform.LookAt(slidepivot.transform); 
	
}

	
// --------------------
// Check keyboard entry
// --------------------
function GetInputKey(){

	//Gestion du zoom
	if (Input.GetKeyDown ("space") ){
		zoomSwitch=1-zoomSwitch;
		
		if (zoomSwitch==0){	zoomValue= zoomIn; }	
		if (zoomSwitch==1){	zoomValue= zoomOut; }	
	}

	//Right key
	if (Input.GetKeyDown ("right") ){
		currentWaypoint++; 
		videoStop=1;
		
		if (currentWaypoint>= waypoints.Length ){
			currentWaypoint= waypoints.Length-1;
		}
	}	

	//Left Key
	if (  Input.GetKeyDown ("left") ){
		currentWaypoint--; 
		videoStop=1;
	
		if (currentWaypoint<0 ){
			currentWaypoint= 0;
		}
	}

}


