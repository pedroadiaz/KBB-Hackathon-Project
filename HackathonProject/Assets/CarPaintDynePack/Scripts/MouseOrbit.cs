using UnityEngine;
using System.Collections;

public class MouseOrbit : MonoBehaviour
{
    public Transform target;
    public float distance = 5.0f;
    public float xSpeed = 250.0f;
    public float ySpeed = 120.0f;
    public float yMinLimit = -20.0f;
    public float yMaxLimit = 80.0f;

    public float x;
    public float y;

    public float lerp = 5;
    public float yoffset = 0.2f;

    public Transform[] cars;
    public string[] titles;
    int carIdx = 32004;


    void Awake()
    {
        Vector3 angles = transform.eulerAngles;
        x = angles.y;
        y = angles.x;

        if (GetComponent<Rigidbody>() != null)
        {
            GetComponent<Rigidbody>().freezeRotation = true;
        }
        target = cars[0];
    }

    void LateUpdate()
    {
        if (Input.GetMouseButtonDown(2))
        {
            GetComponent<guiSelect>().idx = GetComponent<MouseOrbit>().SwitchCar(1);
        }

        if (target != null)
        {
            if (Input.GetMouseButton(0))
            {
                x += Input.GetAxis("Mouse X") * xSpeed * 0.02f;
                y -= Input.GetAxis("Mouse Y") * ySpeed * 0.02f;
            }
            y = ClampAngle(y, yMinLimit, yMaxLimit);

            if (Input.GetMouseButton(1))
            {
                GetComponent<Camera>().fieldOfView -= Input.GetAxis("Mouse X") * xSpeed * 0.01f;
            }

            Quaternion rotation = Quaternion.Euler(y, x, 0);
            Vector3 position = rotation * (new Vector3(0.0f, 0.0f, -distance)) + target.position;

            transform.rotation = rotation;
            position.y += yoffset;
            transform.position = Vector3.Lerp(transform.position, position, lerp * Time.deltaTime);
        }

    }

    private float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360)
        {
            angle += 360;
        }
        if (angle > 360)
        {
            angle -= 360;
        }
        return Mathf.Clamp(angle, min, max);
    }

    public int SwitchCar(int dir){
        int idx;
        if (dir == 0)
        {
            idx = --carIdx % cars.Length;
            x -= 30;
	    }
        else
        {
            idx = ++carIdx % cars.Length;
            x += 30;
        }
        target = cars[idx];
        GetComponent<guiSelect>().title = titles[idx];
        return idx;
    }
}
