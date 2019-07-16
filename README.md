U3D Shaders Collection
======================
pics
# Description
desc
# Content
## Basics
* Half-Lambert Lighting Model (Optimized)
* Blinn-Phong Lighting Model
* Rim Lighting
* Outline

## Toon Style Shading
* Toon Shader
* Anime Hair Shading

## Post-Processing 
* Gaussian Blur
* Bloom
* Volumetric Light

### Basics
#### Half-Lambert Lighting Model (optimized)
The most basic way of calculating the color of a point P on a diffuse surface is by `Diffuse Color = Texture Color of P * Light Color * dot (L, N)` , where L is the direction from P to the light, and N is the normal direction of P. This model raises a proble. When the angle between such two vectors is greater than 90°, that is, `dot (L, N) < 0`, the value of color will be less than or equal to 0, therefore become entirely black. Half-Lambert lighting can be used to display more changes in color in areas that are not exposed to light directly by using `0.5 + dot (L, N) * 0.5 `, which is in the range of [0, 1] instead of [-1, 1]. Yet now, the color in shadow will still gradually descends to black. This is not desired in Japnese Toon shading style, so I made a self-selectable shadow color.<br>
<br>
#### Blinn-Phong Lighting Model
This is implemented as a standard Blinn-Phong shader where `Specular Color =  Specular Color * pow(max(0.0, dot(N, H)), _Gloss) * Light Color` where `H = normalize(L + V)`, and V is the view direction from the point on the surface to the camera. More detailed description on how Blinn-Phong Model works can be found on this [link](https://www.jianshu.com/p/6c45f0d7afd2).
