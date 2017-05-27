using UnityEngine;
using System.Collections;

public class LightRotate : MonoBehaviour {

    public float speed = 10f;

	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        transform.Rotate(0, Time.deltaTime * speed, 0, Space.World);
	}
}
