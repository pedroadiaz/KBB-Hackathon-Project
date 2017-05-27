using UnityEngine;
using System.Collections;

public class guiSelect : MonoBehaviour {

    public string title;
    public float buttonW;
    public float buttonH;
    public Texture2D bl;
    public Texture2D br;
    public Material mat0;
    public Material mat2;
    public Material mat5;
    public Material mat8;
    public Material mat9;
    public GUIStyle guiStyle;
    public GUIStyle guiStyleSlider;
    public GUIStyle guiStyleThumb;
    public int idx;

	void Start () {
        title = GetComponent<MouseOrbit>().titles[0];
	}

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            idx = GetComponent<MouseOrbit>().SwitchCar(0);
        }

        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            idx = GetComponent<MouseOrbit>().SwitchCar(1);
        }
    }

    void OnGUI()
    {
        GUI.backgroundColor = Color.white;
        guiStyle.normal.background = null;
        GUI.Label(new Rect(Screen.width / 2, Screen.height * 0.05f, 50, 500), title, guiStyle);
        GUI.backgroundColor = new Color(1, 1, 1, 0.8f);
        guiStyle.normal.background = bl;
        if (GUI.Button(new Rect(Screen.width / 2 - buttonW, Screen.height -80, buttonW, buttonH), "", guiStyle))
        {
           idx = GetComponent<MouseOrbit>().SwitchCar(0);
        }
        guiStyle.normal.background = br;
        if(GUI.Button(new Rect(Screen.width / 2, Screen.height -80, buttonW, buttonH), "", guiStyle))
        {
            idx = GetComponent<MouseOrbit>().SwitchCar(1);
        }
        if (idx == 0)
        {
            mat0.SetFloat("_RimAmt", GUI.HorizontalSlider(new Rect(Screen.width / 2 - buttonW, Screen.height -98, buttonW * 2, 20), mat0.GetFloat("_RimAmt"), 10, 0, guiStyleSlider, guiStyleThumb));
        }
        if (idx == 2)
        {
            mat2.SetFloat("_RimAmt", GUI.HorizontalSlider(new Rect(Screen.width / 2 - buttonW, Screen.height -98, buttonW * 2, 20), mat2.GetFloat("_RimAmt"), 10, 0, guiStyleSlider, guiStyleThumb));
        }
        if (idx == 5)
        {
            mat5.SetFloat("_RimPwr", GUI.HorizontalSlider(new Rect(Screen.width / 2 - buttonW, Screen.height -98, buttonW * 2, 20), mat5.GetFloat("_RimPwr"), 0, 10, guiStyleSlider, guiStyleThumb));
        }
        if (idx == 8)
        {
            mat8.SetFloat("_DecAmt", GUI.HorizontalSlider(new Rect(Screen.width / 2 - buttonW, Screen.height -98, buttonW * 2, 20), mat8.GetFloat("_DecAmt"), 0, 1, guiStyleSlider, guiStyleThumb));
        }
        if (idx == 9)
        {
            mat9.SetFloat("_DecAmt", GUI.HorizontalSlider(new Rect(Screen.width / 2 - buttonW, Screen.height -98, buttonW * 2, 20), mat9.GetFloat("_DecAmt"), 0, 1, guiStyleSlider, guiStyleThumb));
        }

        GUI.backgroundColor = Color.cyan;
        GUI.Label(new Rect(Screen.width / 2 - 45, Screen.height - 39, 150, 20), "Mouse1: Rotate");
        GUI.Label(new Rect(Screen.width / 2 - 63, Screen.height - 22, 150, 20), "Mouse2: FieldOfView");
    }
}
