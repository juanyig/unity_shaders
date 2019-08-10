using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class postprocessingcamera : MonoBehaviour {

	public Material postProcessingMat;
	// Use this for initialization
	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, postProcessingMat);
	}
}
